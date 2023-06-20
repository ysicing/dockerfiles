FROM ysicing/debian as getkubectl

RUN wget https://dl.k8s.io/v1.27.3/kubernetes-client-linux-amd64.tar.gz && \
  tar xzvfC kubernetes-client-linux-amd64.tar.gz /tmp && \
  mv /tmp/kubernetes/client/bin/kubectl /usr/local/bin/kubectl

FROM ysicing/debian

COPY --from=getkubectl /usr/local/bin/kubectl /usr/local/bin/kubectl

RUN chmod +x /usr/local/bin/kubectl

CMD [ "/usr/local/bin/kubectl" ]
