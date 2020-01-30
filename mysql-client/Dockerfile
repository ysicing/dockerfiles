FROM ysicing/gobuild-alpine as tools

RUN apk update

RUN apk add git

RUN go get github.com/subfuzion/envtpl/...

FROM ysicing/alpine

COPY --from=tools /go/bin/envtpl /usr/local/bin/

ENV TZ "Asia/Shanghai"

RUN apk upgrade \
    && apk add --no-cache mysql-client \
    && rm -rf /var/cache/apk/* 

ADD entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]