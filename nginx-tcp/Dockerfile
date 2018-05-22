FROM spanda/ptcore

LABEL maintainer="ysicing"

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y openssl libssl-dev \
    && rm -rf /var/lib/apt/lists/*  

ADD nginx.tgz /usr/local/

COPY nginx.conf /usr/local/nginx/conf/nginx.conf

WORKDIR /usr/local/nginx/

ENV PATH=$PATH:/usr/local/nginx/sbin

EXPOSE 80 443

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]