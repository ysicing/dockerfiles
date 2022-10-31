FROM golang:1.19-bullseye

LABEL maintainer="ysicing <i@ysicing.me>"

ENV GOPROXY https://goproxy.cn

ENV GO111MODULE on

ENV TZ="Asia/Shanghai"

COPY sources.list /etc/apt/sources.list

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y git build-essential upx nano \
    && rm -rf /var/lib/apt/lists/*
