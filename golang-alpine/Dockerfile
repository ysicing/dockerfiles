FROM ysicing/gobuild-alpine as gotools

ENV GOPROXY=https://goproxy.cn

RUN apk update; apk add git && \
    go get -u github.com/google/gops

FROM ysicing/alpine

LABEL MAINTAINER="ysicing<i@ysicing.me>"
 
COPY --from=gotools /go/bin/gops /usr/local/bin/gops

RUN chmod +x /usr/local/bin/gops
