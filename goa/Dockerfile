FROM golang:1-alpine as tool

ENV GO111MODULE=on

RUN go install github.com/go-task/task/v3/cmd/task@latest

RUN go install github.com/google/gops@latest

RUN go install github.com/mitchellh/gox@latest

# RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# 基础镜像
FROM golang:1-alpine

# ENV GOPROXY=https://goproxy.cn,direct

ENV GO111MODULE=on

# 设置容器时区为亚洲/上海
ENV TZ="Asia/Shanghai"

RUN set -x \
    && apk add --no-cache \
        git \
        build-base \
        nano \
    && rm -rf \
        /tmp/* \
        /var/tmp/*

COPY --from=tool /go/bin/ /usr/bin/
