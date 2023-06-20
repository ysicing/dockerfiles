FROM python:3.11-slim-bookworm

LABEL maintainer="ysicing <i@ysicing.me>"

ENV TZ="Asia/Shanghai"

COPY sources.list /etc/apt/sources.list

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y apt-transport-https ca-certificates procps curl wget net-tools nano \
    && rm -rf /var/lib/apt/lists/*
