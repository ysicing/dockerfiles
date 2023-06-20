FROM node:lts-alpine3.15

LABEL maintainer ysicing

RUN apk --no-cache add tzdata git \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata \
    && rm -rf /var/cache/apk/*

RUN npm config set registry https://registry.npmmirror.com
