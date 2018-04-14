FROM debian:sid-slim

RUN apt-get update && apt-get install -yqq --no-install-recommends curl git ssh hugo ca-certificates \
    && curl https://getcaddy.com | bash -s personal dyndns,hook.service,http.authz,http.cache,http.cgi,http.cors,http.datadog,http.expires,http.filemanager,http.filter,http.forwardproxy,http.git,http.hugo,http.ipfilter,http.locale,http.login,http.mailout,http.minify,http.nobots,http.prometheus,http.proxyprotocol,http.ratelimit,http.realip \
    && rm -rf /var/lib/apt/lists/* 

RUN /usr/local/bin/caddy -version

RUN /usr/local/bin/caddy -plugins

EXPOSE 80 443

VOLUME /root/.caddy /proxy
WORKDIR /proxy

COPY index.html /proxy/index.html
COPY Caddyfile /etc/Caddyfile

ENV TZ=Asia/Shanghai

ENTRYPOINT [ "/usr/local/bin/caddy" ]
CMD [ "--conf", "/etc/Caddyfile", "--log", "stdout"]