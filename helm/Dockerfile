FROM ysicing/debian as gethelm

RUN wget https://get.helm.sh/helm-v3.10.3-linux-amd64.tar.gz && \
  tar xzvfC helm-v3.10.3-linux-amd64.tar.gz /tmp && \
  mv /tmp/linux-amd64/helm /usr/local/bin/helm

FROM ysicing/debian

COPY --from=gethelm /usr/local/bin/helm /usr/local/bin/helm

RUN chmod +x /usr/local/bin/helm

CMD [ "/usr/local/bin/helm" ]
