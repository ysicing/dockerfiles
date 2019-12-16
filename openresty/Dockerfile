FROM openresty/openresty:1.15.8.2-stretch

LABEL maintainer="ysicing <i@ysicing.me>"

ENV TZ Asia/Shanghai

COPY conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

RUN set -x \
    && rm -rf /etc/apt/sources.list.d/*.list \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y apt-transport-https ca-certificates procps curl net-tools nano \
    && rm -rf /var/lib/apt/lists/*


