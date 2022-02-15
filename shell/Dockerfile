FROM ysicing/ergo as getergo

FROM ysicing/debian

LABEL maintainer="ysicing <i@ysicing.me>"

COPY --from=getergo /usr/local/bin/ergo /usr/local/bin/ergo

RUN chmod +x /usr/local/bin/ergo

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y git \
    && rm -rf /var/lib/apt/lists/*