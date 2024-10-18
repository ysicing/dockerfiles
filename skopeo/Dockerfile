FROM ysicing/debian

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y skopeo \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/skopeo"]
