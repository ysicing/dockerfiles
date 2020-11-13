FROM registry.cn-beijing.aliyuncs.com/k7scn/prometheus:2-debian-10

LABEL maintainer "ysicing <i@ysicing.me>"

ENV TZ=Asia/Shanghai

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y apt-transport-https ca-certificates procps curl wget net-tools \
    && rm -rf /var/lib/apt/lists/*

CMD [ "--web.enable-lifecycle", "--config.file=/opt/bitnami/prometheus/conf/prometheus.yml", "--storage.tsdb.path=/opt/bitnami/prometheus/data", "--web.console.libraries=/opt/bitnami/prometheus/conf/console_libraries", "--web.console.templates=/opt/bitnami/prometheus/conf/consoles" ]
