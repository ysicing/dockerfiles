FROM ysicing/debian AS fetch

RUN wget https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz && \
    tar -zxvf node_exporter-1.9.1.linux-amd64.tar.gz && \
    mv node_exporter-1.9.1.linux-amd64/node_exporter /usr/bin/node_exporter && \
    chmod +x /usr/bin/node_exporter && \
    rm -rf node_exporter-1.9.1.linux-amd64.tar.gz

FROM ysicing/debian

WORKDIR /app

COPY --from=fetch /usr/bin/node_exporter /usr/bin/node_exporter

COPY entrypoint.sh /entrypoint.sh

CMD [ "/entrypoint.sh" ]
