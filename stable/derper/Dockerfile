FROM ysicing/god as install

RUN go install tailscale.com/cmd/derper@main

FROM ysicing/debian

COPY --from=install /go/bin/derper /usr/local/bin/derper

COPY entrypoint /usr/local/bin/entrypoint

RUN chmod +x /usr/local/bin/derper /usr/local/bin/entrypoint

VOLUME /root/.cache/tailscale

EXPOSE 77 3478

CMD /usr/local/bin/entrypoint
