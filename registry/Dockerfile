FROM ysicing/debian AS Get

RUN wget https://github.com/distribution/distribution/releases/download/v2.8.3/registry_2.8.3_linux_amd64.tar.gz \
    && tar -zxvf registry_2.8.3_linux_amd64.tar.gz \
    && mv registry /usr/bin/registry

FROM ysicing/debian

COPY --from=Get /usr/bin/registry /usr/bin/registry

COPY config.yml /config.yml

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 5000

ENTRYPOINT ["/entrypoint.sh"]
