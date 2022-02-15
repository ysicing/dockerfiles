FROM ysicing/god AS builder

# https://tailscale.com/kb/1118/custom-derp-servers/
RUN go install tailscale.com/cmd/derper@v1.20.4

FROM ysicing/debian

COPY --from=builder /go/bin/derper /usr/bin/derper

COPY entrypoint /usr/local/bin/entrypoint

CMD /usr/local/bin/entrypoint
