FROM spanda/ptcore

ENV REPO="https://github.com/TelegramMessenger/MTProxy"

RUN apt-get update && apt-get install -y git curl build-essential libssl-dev zlib1g-dev make && mkdir /proxy

WORKDIR /proxy

RUN git clone https://github.com/TelegramMessenger/MTProxy

RUN cd MTProxy && make

FROM spanda/ptcore

ENV default_secret=0c39a63d897865506b0969fd5365656c

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y libc6 \
    && rm -rf /var/lib/apt/lists/* 

COPY --from=0 /proxy/MTProxy/objs/bin/mtproto-proxy /usr/local/bin/mtproto-proxy

COPY run.sh /run.sh

RUN chmod +x /run.sh

ENTRYPOINT [ "/run.sh" ]




