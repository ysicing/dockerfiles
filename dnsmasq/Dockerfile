FROM spanda/ptcore

ENV WEBPROC_VERSION 0.1.9
ENV WEBPROC_URL https://github.com/jpillora/webproc/releases/download/$WEBPROC_VERSION/webproc_linux_amd64.gz

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y dnsmasq   \
    && curl -sL $WEBPROC_URL | gzip -d - > /usr/local/bin/webproc \
    && chmod +x /usr/local/bin/webproc \
    && echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq \
    && rm -rf /var/lib/apt/lists/* 

COPY dnsmasq.conf /etc/dnsmasq.conf
ENTRYPOINT ["webproc","--config","/etc/dnsmasq.conf","--","dnsmasq","--no-daemon"]