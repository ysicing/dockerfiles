FROM debian:sid-slim

LABEL maintainer="ysicing"

ENV TZ=Asia/Shanghai

RUN apt-get update && apt-get install -yqq --no-install-recommends curl git ssh hugo ca-certificates \
    && rm -rf /var/lib/apt/lists/* 

RUN curl https://getcaddy.com | bash -s personal dyndns,hook.service,http.authz,http.cache,http.cgi,http.cors,http.datadog,http.expires,http.filemanager,http.filter,http.forwardproxy,http.git,http.hugo,http.ipfilter,http.locale,http.login,http.mailout,http.minify,http.nobots,http.prometheus,http.proxyprotocol,http.ratelimit,http.realip,http.jekyll,http.geoip,http.reauth,http.restic,http.upload,http.webdav,net 

VOLUME /root/.caddy

COPY *.html /tmp/

COPY Caddyfile /etc/Caddyfile

COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 80 443

ENTRYPOINT [ "bash", "/start.sh"]

CMD [ "--conf", "/etc/Caddyfile", "--log", "stdout", "--agree"]