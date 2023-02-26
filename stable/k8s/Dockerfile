FROM ysicing/debian as getkubectl

RUN wget https://dl.k8s.io/v1.26.1/kubernetes-client-linux-amd64.tar.gz && \
  tar xzvfC kubernetes-client-linux-amd64.tar.gz /tmp && \
  mv /tmp/kubernetes/client/bin/kubectl /usr/local/bin/kubectl

FROM ysicing/debian as gethelm

RUN wget https://get.helm.sh/helm-v3.11.0-linux-amd64.tar.gz && \
  tar xzvfC helm-v3.11.0-linux-amd64.tar.gz /tmp && \
  mv /tmp/linux-amd64/helm /usr/local/bin/helm

FROM ysicing/debian

COPY --from=getkubectl /usr/local/bin/kubectl /usr/local/bin/kubectl

COPY --from=gethelm /usr/local/bin/helm /usr/local/bin/helm

RUN chmod +x /usr/local/bin/kubectl /usr/local/bin/helm
