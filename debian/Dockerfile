FROM debian:bookworm-slim

LABEL maintainer="ysicing <i@ysicing.me>"

# set environment variables
ENV HOME="/root" \
    LANGUAGE="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    TERM="xterm" \
    TZ=Asia/Shanghai

COPY sources.list /etc/apt/sources.list

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y apt-transport-https ca-certificates procps curl wget net-tools iproute2 jq nano pwgen \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/*
