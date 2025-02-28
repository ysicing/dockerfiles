FROM golang:1-bookworm as tool

ENV GO111MODULE=on

RUN go install github.com/go-task/task/v3/cmd/task@latest

RUN go install github.com/google/gops@latest

RUN go install github.com/mitchellh/gox@latest

# RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

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

COPY --from=tool /go/bin/ /usr/bin/
