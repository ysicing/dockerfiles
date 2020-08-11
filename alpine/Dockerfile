FROM alpine:3.12

LABEL maintainer="ysicing <i@ysicing.me>"

ARG TZ="Asia/Shanghai"

ENV TZ ${TZ}

RUN apk update \
    && apk add --no-cache bash tzdata curl busybox-extras drill \
    && sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && date \
    && apk del --no-cache tzdata \
    && rm -rf /var/cache/apk/* \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

CMD ["/bin/bash"]
