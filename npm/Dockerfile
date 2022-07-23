FROM node:lts-alpine3.15

LABEL maintainer ysicing

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tencent.com/g' /etc/apk/repositories \
    && apk --no-cache add tzdata git svn\
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata \
    && rm -rf /var/cache/apk/*

RUN npm config set registry https://registry.npmmirror.com
