FROM golang:buster

LABEL maintainer="ysicing <i@ysicing.me>"

ENV TZ Asia/Shanghai

ENV GOPROXY https://goproxy.cn

ENV GO111MODULE on

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y apt-transport-https ca-certificates procps curl wget net-tools \
    && rm -rf /var/lib/apt/lists/*

COPY sources.list /etc/apt/sources.list