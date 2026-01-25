# PostgreSQL with pgvector and common extensions
# Based on pgvector official image (Debian bookworm)

ARG PG_VERSION=18
FROM pgvector/pgvector:pg${PG_VERSION}-bookworm

LABEL maintainer="ysicing <ysicing@12306.work>"

ENV TZ="Asia/Shanghai"

# Copy custom configuration and initialization script
COPY postgresql.conf.d/ /etc/postgresql/conf.d/
COPY docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/
