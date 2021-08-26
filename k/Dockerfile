FROM bitnami/kubectl

LABEL maintainer="ysicing <i@ysicing.me>"

ENV TZ=Asia/Shanghai

USER root

COPY run.sh /opt/bitnami/kubectl/bin/run.sh

RUN chmod +x /opt/bitnami/kubectl/bin/run.sh

USER 1001

ENTRYPOINT /opt/bitnami/kubectl/bin/run.sh

CMD kubectl --help