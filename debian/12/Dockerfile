FROM debian:bookworm-backports

# set environment variables
ENV HOME="/root" \
    LANGUAGE="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    TERM="xterm" \
    TZ=Asia/Shanghai

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y apt-transport-https ca-certificates procps curl wget net-tools nano git \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/* \
        /etc/apt/sources.list.d/debian.sources \
        /etc/apt/sources.list.d/backports.list

COPY sources.list /etc/apt/sources.list
