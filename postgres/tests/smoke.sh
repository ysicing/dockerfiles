#!/usr/bin/env bash
set -euo pipefail

image="${1:?Usage: bash smoke.sh IMAGE [PLATFORM]}"
platform="${2:-$(docker image inspect --format '{{.Os}}/{{.Architecture}}' "$image")}"
test_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
run_id="postgres-smoke-$$-${RANDOM}"
password="$(openssl rand -hex 16)"
containers=()
volumes=()
cleanup() {
    status=$?
    set +eu
    trap - EXIT
    for container in "${containers[@]}"; do
        if (( status != 0 )); then
            docker logs --tail 200 "$container" >&2 || true
        fi
        docker rm -f "$container" >/dev/null || status=1
    done
    for volume in "${volumes[@]}"; do
        docker volume rm "$volume" >/dev/null || status=1
    done
    exit "$status"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

query() {
    docker exec -i "$container" psql -X -v ON_ERROR_STOP=1 \
        --username smoke_user --dbname "$1" -At
}

wait_for_postgres() {
    for (( attempt = 0; attempt < 120; attempt++ )); do
        if [[ "$(docker inspect --format '{{.State.Running}}' "$container")" != true ]]; then
            echo "PostgreSQL container exited before becoming ready" >&2
            return 1
        fi
        # 临时初始化实例只监听 Unix socket，通过容器内 TCP 等待最终实例
        if docker exec "$container" bash -c \
            'pg_isready --host 127.0.0.1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"' \
            >/dev/null 2>&1; then
            return 0
        fi
        sleep 1
    done
    echo "Timed out waiting for PostgreSQL initialization" >&2
    return 1
}

for database in postgres smoke_app; do
    container="${run_id}-${database}"
    volume="${container}-data"
    docker volume create "$volume" >/dev/null
    volumes+=("$volume")
    containers+=("$container")
    echo "Testing $image with POSTGRES_DB=$database"
    docker run --detach --platform "$platform" --name "$container" \
        --network none --cpus 2 --memory 512m \
        --mount "type=volume,source=$volume,target=/var/lib/postgresql" \
        --env POSTGRES_USER=smoke_user \
        --env "POSTGRES_DB=$database" --env "POSTGRES_PASSWORD=$password" \
        "$image" -c max_connections=20 >/dev/null
    wait_for_postgres

    query "$database" < "$test_directory/features.sql"
    if [[ "$(query postgres <<< 'SELECT count(*) FROM cron.job;')" != 0 ]]; then
        echo "Image unexpectedly contains preconfigured cron jobs" >&2
        exit 1
    fi

    query postgres <<'SQL'
CREATE ROLE smoke_runner LOGIN;
GRANT USAGE ON SCHEMA cron TO smoke_runner;
GRANT EXECUTE ON FUNCTION cron.schedule_in_database(text,text,text,text,text,boolean)
TO smoke_runner;
SQL
    query "$database" <<'SQL'
CREATE TABLE smoke_cron_events (message text);
GRANT INSERT ON smoke_cron_events TO smoke_runner;
SQL
    docker exec -i "$container" psql -X -v ON_ERROR_STOP=1 \
        --username smoke_runner --dbname postgres --set "database=$database" <<'SQL'
SELECT cron.schedule_in_database(
    'smoke-success', '2 seconds',
    $$INSERT INTO public.smoke_cron_events VALUES ('executed')$$, :'database'
);
SELECT cron.schedule('smoke-failure', '2 seconds', 'SELECT 1/0');
SQL
    completed=false
    for (( attempt = 0; attempt < 60; attempt++ )); do
        result="$(query postgres <<'SQL'
SELECT EXISTS (
    SELECT 1 FROM cron.job_run_details
    JOIN cron.job USING (jobid)
    WHERE jobname = 'smoke-success' AND status = 'succeeded'
) AND EXISTS (
    SELECT 1 FROM cron.job_run_details
    JOIN cron.job USING (jobid)
    WHERE jobname = 'smoke-failure' AND status = 'failed'
        AND return_message LIKE '%division by zero%'
);
SQL
)"
        if [[ "$result" == t ]]; then
            completed=true
            break
        fi
        sleep 1
    done
    if [[ "$completed" != true ]]; then
        query postgres <<< 'TABLE cron.job_run_details;' >&2
        echo "Cron success and failure records were not observed" >&2
        exit 1
    fi
    query postgres <<'SQL'
SELECT cron.unschedule(jobid) FROM cron.job
WHERE jobname = 'smoke-failure';
SQL
    docker restart --time 30 "$container" >/dev/null
    wait_for_postgres
    if [[ "$(query "$database" <<'SQL'
SELECT (SELECT count(*) FROM smoke_vectors) = 3
    AND EXISTS (SELECT 1 FROM smoke_cron_events);
SQL
)" != t ]] || [[ "$(query postgres <<< 'SELECT count(*) FROM cron.job;')" != 1 ]]; then
        echo "Data or cron state did not survive restart" >&2
        exit 1
    fi
    previous_events="$(query "$database" <<< 'SELECT count(*) FROM smoke_cron_events;')"
    resumed=false
    for (( attempt = 0; attempt < 60; attempt++ )); do
        current_events="$(query "$database" <<< 'SELECT count(*) FROM smoke_cron_events;')"
        if (( current_events > previous_events )); then
            resumed=true
            break
        fi
        sleep 1
    done
    if [[ "$resumed" != true ]]; then
        echo "Cron scheduler did not resume after restart" >&2
        exit 1
    fi
    query postgres <<< "SELECT cron.unschedule(jobid) FROM cron.job WHERE jobname = 'smoke-success';"
    if [[ "$(query postgres <<< 'SELECT count(*) FROM cron.job;')" != 0 ]]; then
        echo "Cron test jobs were not removed" >&2
        exit 1
    fi
    if [[ "$(docker exec "$container" bash -c \
        'grep -Fxc "include_dir = '\''/etc/postgresql/conf.d'\''" "$PGDATA/postgresql.conf"')" != 1 ]]; then
        echo "Custom configuration include is missing or duplicated" >&2
        exit 1
    fi
    echo "PASS POSTGRES_DB=$database: extensions, indexes, SQL statistics, cron and restart"
    docker stop --time 30 "$container" >/dev/null
done
