FROM debian:sid-slim

LABEL maintainer="ysicing"

ENV TZ=Asia/Shanghai

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y apt-transport-https ca-certificates procps curl net-tools \
    && rm -rf /var/lib/apt/lists/* 
