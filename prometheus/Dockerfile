FROM registry.cn-beijing.aliyuncs.com/k7scn/prometheus:2-debian-10

LABEL maintainer "ysicing <i@ysicing.me>"

ENV TZ=Asia/Shanghai

CMD [ "--web.enable-lifecycle", "--config.file=/opt/bitnami/prometheus/conf/prometheus.yml", "--storage.tsdb.path=/opt/bitnami/prometheus/data", "--web.console.libraries=/opt/bitnami/prometheus/conf/console_libraries", "--web.console.templates=/opt/bitnami/prometheus/conf/consoles" ]
