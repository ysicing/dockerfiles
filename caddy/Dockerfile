FROM ysicing/god AS xcaddy

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

WORKDIR /go/src/

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddy-dns/tencentcloud \
    --with github.com/caddy-dns/alidns \
    --with github.com/caddy-dns/dnspod \
    --with github.com/ysicing/caddy2-geocn \
    --with github.com/mholt/caddy-l4 \
    --with github.com/mholt/caddy-ratelimit

RUN /go/src/caddy list-modules

FROM ysicing/debian

WORKDIR /app

COPY --from=xcaddy /go/src/caddy /usr/bin/caddy

RUN chmod +x /usr/bin/caddy && \
    mkdir -p \
    /config/caddy \
    /etc/caddy \
    /data/caddy \
    /var/log/caddy

ENV XDG_CONFIG_HOME /config

ENV XDG_DATA_HOME /data

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp

VOLUME /config

VOLUME /data

VOLUME /var/log/caddy

CMD caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
