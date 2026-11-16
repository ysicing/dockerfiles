\set ON_ERROR_STOP on

DO $$
DECLARE
    missing_extensions text[];
    required_library text;
BEGIN
    SELECT array_agg(required.name) INTO missing_extensions
    FROM unnest(ARRAY[
        'vector', 'hypopg', 'uuid-ossp', 'pg_trgm', 'pg_stat_statements', 'unaccent',
        'pgcrypto', 'btree_gin', 'btree_gist', 'hstore', 'ltree', 'fuzzystrmatch'
    ]) AS required(name)
    WHERE NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = required.name);
    IF missing_extensions IS NOT NULL THEN
        RAISE EXCEPTION 'Missing extensions: %', missing_extensions;
    END IF;

    FOREACH required_library IN ARRAY ARRAY['pg_stat_statements', 'auto_explain', 'pg_cron']
    LOOP
        IF NOT required_library = ANY(
            regexp_split_to_array(current_setting('shared_preload_libraries'), '\s*,\s*')
        ) THEN
            RAISE EXCEPTION 'Library is not preloaded: %', required_library;
        END IF;
    END LOOP;

    IF current_setting('cron.database_name') <> 'postgres'
        OR current_setting('cron.timezone') <> 'Asia/Shanghai'
        OR current_setting('cron.use_background_workers') <> 'on'
        OR current_setting('cron.max_running_jobs') <> '2'
        OR current_setting('auto_explain.log_timing') <> 'off'
        OR current_setting('max_connections') <> '20' THEN
        RAISE EXCEPTION 'Unexpected PostgreSQL configuration';
    END IF;

    IF EXISTS (
        SELECT 1 FROM pg_file_settings
        WHERE sourcefile LIKE '%/custom.conf' AND error IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'Custom configuration contains errors';
    END IF;

    IF (current_database() = 'postgres') <> EXISTS (
        SELECT 1 FROM pg_extension WHERE extname = 'pg_cron'
    ) THEN
        RAISE EXCEPTION 'pg_cron must be installed only in postgres';
    END IF;

    IF uuid_generate_v4() IS NULL
        OR similarity('postgres', 'postgres') <> 1
        OR unaccent('Hôtel') <> 'Hotel'
        OR octet_length(digest('abc', 'sha256')) <> 32
        OR (hstore('key', 'value') -> 'key') <> 'value'
        OR NOT ('Top.Child'::ltree <@ 'Top'::ltree)
        OR levenshtein('kitten', 'sitting') <> 3 THEN
        RAISE EXCEPTION 'Extension function returned an unexpected result';
    END IF;
END
$$;

CREATE TABLE smoke_vectors (id integer PRIMARY KEY, embedding vector(3));
INSERT INTO smoke_vectors VALUES (1, '[1,0,0]'), (2, '[0,1,0]'), (3, '[0,0,1]');
CREATE INDEX smoke_vectors_hnsw ON smoke_vectors USING hnsw (embedding vector_l2_ops);
CREATE INDEX smoke_vectors_gin ON smoke_vectors USING gin (id);
CREATE INDEX smoke_vectors_gist ON smoke_vectors USING gist (id);
SET enable_seqscan = off;

DO $$
DECLARE
    nearest_id integer;
BEGIN
    SELECT id INTO nearest_id FROM smoke_vectors
    ORDER BY embedding <-> '[0.9,0,0]'::vector LIMIT 1;
    IF nearest_id IS DISTINCT FROM 1 THEN
        RAISE EXCEPTION 'Unexpected vector nearest neighbor: %', nearest_id;
    END IF;
END
$$;

CREATE TABLE smoke_hypopg (id integer, value integer);
INSERT INTO smoke_hypopg SELECT value, value FROM generate_series(1, 1000) AS value;
ANALYZE smoke_hypopg;

DO $$
DECLARE
    hypothetical_name text;
    query_plan json;
BEGIN
    SELECT indexname INTO hypothetical_name
    FROM hypopg_create_index('CREATE INDEX ON smoke_hypopg (value)');
    EXECUTE 'EXPLAIN (FORMAT JSON) SELECT * FROM smoke_hypopg WHERE value = 42'
        INTO query_plan;
    IF hypothetical_name IS NULL OR query_plan IS NULL
        OR position(hypothetical_name IN query_plan::text) = 0 THEN
        RAISE EXCEPTION 'HypoPG index was not used: %', query_plan;
    END IF;
    PERFORM hypopg_reset();
END
$$;

RESET enable_seqscan;
SELECT pg_stat_statements_reset();
SELECT sum(id) FROM smoke_vectors;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_stat_statements
        WHERE query LIKE 'SELECT sum(id) FROM smoke_vectors%' AND calls > 0
    ) THEN
        RAISE EXCEPTION 'pg_stat_statements did not record the test query';
    END IF;
END
$$;
