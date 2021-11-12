FROM ysicing/goa AS builder

# https://tailscale.com/kb/1118/custom-derp-servers/
RUN go install tailscale.com/cmd/derper@main

FROM ysicing/debian

COPY --from=builder /go/bin/derper /usr/bin/derper

COPY entrypoint /usr/local/bin/entrypoint

CMD /usr/local/bin/entrypoint
