FROM python:slim-stretch

MAINTAINER root@ysicing.net

ENV TZ=Asia/Shanghai

ENV URL=https://download.libsodium.org/libsodium/releases/LATEST.tar.gz

COPY ld.so.conf /etc/ld.so.conf

RUN apt update;apt install wget git gcc make -y \
    && mkdir -p /ss \
    && wget ${URL} \
    && tar zxf LATEST.tar.gz \
    && cd libsodium* \
    && ./configure \
    && make && make install \
    && pip install git+https://github.com/shadowsocks/shadowsocks.git@master \
    && ldconfig

WORKDIR /ss

COPY . /ss

ENTRYPOINT ["/ss/start.sh"]
