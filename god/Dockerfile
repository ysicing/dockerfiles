FROM golang:1-bookworm as tool

ENV GOPROXY=https://goproxy.cn,direct

ENV GO111MODULE=on

RUN go install github.com/go-task/task/v3/cmd/task@latest

RUN go install github.com/google/gops@latest

RUN go install github.com/mitchellh/gox@latest

RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

FROM golang:1-bookworm

ENV GOPROXY=https://goproxy.cn,direct

ENV GO111MODULE=on

ENV TZ="Asia/Shanghai"

COPY sources.list /etc/apt/sources.list

RUN set -x \
    && rm -rf /etc/apt/sources.list.d/debian.sources /etc/apt/sources.list.d/backports.list \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y git build-essential nano \
    && rm -rf /var/lib/apt/lists/*

# COPY --from=tool /go/bin/ /usr/bin/

# COPY bin/ /usr/bin/
