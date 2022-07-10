FROM golang:1.18-bullseye

LABEL maintainer="ysicing <i@ysicing.me>"

ENV GOPROXY https://goproxy.cn

ENV GO111MODULE on

ENV TZ="Asia/Shanghai"

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y git build-essential upx \
    && rm -rf /var/lib/apt/lists/*

COPY sources.list /etc/apt/sources.list
