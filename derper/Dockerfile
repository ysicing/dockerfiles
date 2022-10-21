FROM ysicing/god as install

RUN go install tailscale.com/cmd/derper@main

FROM ysicing/debian

COPY --from=install /root/go/bin/derper /usr/local/bin/derper

RUN chmod +x /usr/local/bin/derper

