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
    --with github.com/mholt/caddy-ratelimit

FROM ghcr.io/ysicing/debian

COPY --from=build /go/src/caddy /usr/local/bin/caddy
