FROM golang:1-bookworm

ENV GOPROXY=https://goproxy.cn,direct

ENV GO111MODULE=on

ENV TZ="Asia/Shanghai"

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y git build-essential nano \
    && rm -rf \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/* \
        /etc/apt/sources.list.d/debian.sources \
        /etc/apt/sources.list.d/backports.list

COPY sources.list /etc/apt/sources.list
