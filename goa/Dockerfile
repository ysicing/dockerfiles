FROM ysicing/goa as tool

RUN go install github.com/go-task/task/v3/cmd/task@latest

RUN go install github.com/google/gops@latest

RUN go install github.com/mitchellh/gox@latest

RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

FROM golang:1.20-alpine

LABEL maintainer="ysicing <i@ysicing.me>"

ENV GOPROXY https://goproxy.cn

ENV GO111MODULE on

ARG TZ="Asia/Shanghai"

ENV TZ ${TZ}

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tencent.com/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache bash tzdata curl make git upx \
    && sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && date \
    && apk del --no-cache tzdata \
    && rm -rf /var/cache/apk/*

COPY --from=tool /go/bin/ /usr/bin/
