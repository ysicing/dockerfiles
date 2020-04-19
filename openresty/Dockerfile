FROM openresty/openresty:1.15.8.3-1-buster

LABEL maintainer="ysicing <i@ysicing.me>"

ENV TZ Asia/Shanghai

COPY conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY nginxconfig.io /usr/local/openresty/nginx/conf/nginxconfig.io

RUN set -x \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --no-install-suggests -y openresty-opm apt-transport-https ca-certificates procps curl net-tools nano \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -pv /var/log/nginx/