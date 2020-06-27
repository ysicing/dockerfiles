FROM ysicing/gobuild as gotools

ENV GOPROXY=https://goproxy.cn

RUN apt update; apt install -y git && \
    go get -u github.com/google/gops

FROM ysicing/debian

LABEL maintainer="ysicing <i@ysicing.me>"

ENV TZ Asia/Shanghai

COPY --from=gotools /go/bin/gops /usr/local/bin/gops

RUN chmod +x /usr/local/bin/gops