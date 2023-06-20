FROM ysicing/god as tool

RUN go install github.com/go-task/task/v3/cmd/task@latest

RUN go install github.com/google/gops@latest

RUN go install github.com/mitchellh/gox@latest

RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

FROM golang:1.20-bookworm

LABEL maintainer="ysicing <i@ysicing.me>"

ENV GOPROXY https://goproxy.cn

ENV GO111MODULE on

ENV TZ="Asia/Shanghai"

COPY sources.list /etc/apt/sources.list

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y git build-essential upx nano \
    && rm -rf /var/lib/apt/lists/*

COPY --from=tool /go/bin/ /usr/bin/
