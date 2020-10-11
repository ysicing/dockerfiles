FROM golang:buster

LABEL maintainer="ysicing <i@ysicing.me>"

ENV GOPROXY https://goproxy.cn

ENV GO111MODULE on

ENV TZ="Asia/Shanghai"

COPY sources.list /etc/apt/sources.list

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y git \
    && rm -rf /var/lib/apt/lists/*

COPY upx /usr/local/bin/upx

RUN chmod +x /usr/local/bin/upx