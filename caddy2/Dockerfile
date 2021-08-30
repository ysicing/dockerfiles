FROM ghcr.io/ysicing/god AS build

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN xcaddy build \
    --with github.com/caddyserver/ntlm-transport \
    --with github.com/kirsch33/realip \
    --with github.com/abiosoft/caddy-yaml \
    --with github.com/lolPants/caddy-requestid \
    --with github.com/porech/caddy-maxmind-geolocation \
    --with github.com/sjtug/caddy2-filter \
    --with github.com/WingLim/caddy-webhook \
    --with github.com/mholt/caddy-ratelimit \
    --with github.com/greenpau/caddy-auth-jwt \
    --with github.com/greenpau/caddy-auth-portal \
    --with github.com/greenpau/caddy-trace \
    --with github.com/hairyhenderson/caddy-teapot-module \
    --with github.com/caddyserver/format-encoder \
    --with github.com/mholt/caddy-webdav

RUN /go/caddy list-modules

FROM ghcr.io/ysicing/debian as geoip

RUN cd /root/ && wget https://github.com/Hackl0us/GeoIP2-CN/raw/release/Country.mmdb

FROM ghcr.io/ysicing/debian

COPY --from=build /go/caddy /usr/local/bin/caddy

COPY --from=geoip /root/Country.mmdb /root/geoip.mmdb

COPY caddy /etc/caddy

COPY www /root/www

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
