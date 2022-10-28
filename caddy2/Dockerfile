FROM ysicing/god AS build

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN xcaddy build \
    --with github.com/porech/caddy-maxmind-geolocation \
    --with github.com/abiosoft/caddy-exec \
    --with github.com/caddyserver/transform-encoder \
    --with github.com/WingLim/caddy-webhook \
    --with github.com/RussellLuo/caddy-ext/ratelimit \
    --with github.com/mholt/caddy-webdav \
    --with github.com/mholt/caddy-dynamicdns \
    --with github.com/ysicing/caddy2-geocn \
    --with github.com/mholt/caddy-l4 \
    --with github.com/imgk/caddy-trojan \
    --with github.com/caddy-dns/dnspod \
    --with github.com/caddy-dns/alidns \
    --with github.com/mholt/caddy-events-exec

RUN /go/caddy list-modules

FROM ysicing/debian as geoip

RUN cd /root/ && wget https://github.com/Hackl0us/GeoIP2-CN/raw/release/Country.mmdb

FROM ysicing/debian

COPY --from=build /go/caddy /usr/local/bin/caddy

COPY --from=geoip /root/Country.mmdb /etc/caddy/geoip.mmdb

COPY caddy /etc/caddy

COPY www /etc/caddy/www

COPY page /etc/caddy/page

WORKDIR /etc/caddy

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
