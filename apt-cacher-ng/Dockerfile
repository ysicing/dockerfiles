FROM debian:stretch-backports

LABEL maintainer="i@ysicing.me"

ENV TZ=Asia/Shanghai

COPY hack/sources.list /etc/apt/sources.list

ENV APT_CACHER_NG_CACHE_DIR=/var/cache/apt-cacher-ng \
    APT_CACHER_NG_LOG_DIR=/var/log/apt-cacher-ng \
    APT_CACHER_NG_USER=apt-cacher-ng

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-cacher-ng ca-certificates nano wget procps curl net-tools \
    && rm -rf /var/lib/apt/lists/*

COPY hack/acng.conf /etc/apt-cacher-ng/acng.conf

COPY hack/mirrors /etc/apt-cacher-ng/

COPY hack/apt.conf /etc/apt/apt.conf

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

VOLUME [ "/var/cache/apt-cacher-ng" ]

VOLUME [ "/var/log/apt-cacher-ng" ]

EXPOSE 3142

HEALTHCHECK --interval=10s --timeout=2s --retries=3 \
    CMD wget -q - http://localhost:3142/acng-report.html || exit 1

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/apt-cacher-ng"]
