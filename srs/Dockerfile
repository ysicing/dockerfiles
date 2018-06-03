FROM debian:stretch-slim AS builder

RUN  \
    apt-get update && \
    apt-get install -y  --no-install-recommends libpcre3 zlib1g libpcre3-dev zlib1g-dev build-essential curl ca-certificates && \
    apt-get install -y  --no-install-recommends git gcc make g++ gdb unzip sudo python && \
    git clone https://github.com/ossrs/srs /tmp/build/ && \
    cd /tmp/build/trunk && \
    ./configure --prefix=/srs --disable-all --with-hls --with-ssl --with-http-server && \
    make && \
    make install && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

FROM spanda/ptcore

COPY --from=builder /srs/ /opt/

WORKDIR /opt/objs/

RUN mkdir -p /opt/objs/nginx/html /opt/objs/conf/ /opt/objs/tmp

COPY start.sh /start.sh

COPY http.hls.conf /opt/objs/conf/http.hls.conf

RUN chmod +x /start.sh

ENTRYPOINT [ "bash", "/start.sh" ]

CMD [ "-c", "conf/http.hls.conf" ]