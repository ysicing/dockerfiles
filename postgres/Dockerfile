# PostgreSQL with pgvector and common extensions
# Based on pgvector official image (Debian trixie)

ARG PG_VERSION=18
FROM pgvector/pgvector:pg${PG_VERSION}-trixie

LABEL maintainer="ysicing <ysicing@12306.work>"

ENV TZ="Asia/Shanghai"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        "postgresql-${PG_MAJOR}-hypopg" \
        "postgresql-${PG_MAJOR}-cron" \
    && rm -rf /var/lib/apt/lists/*

# Copy custom configuration and initialization script
COPY postgresql.conf.d/ /etc/postgresql/conf.d/
COPY docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/
