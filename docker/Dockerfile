FROM ysicing/goa

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

RUN apk add --no-cache git make wget curl musl-dev ca-certificates libc6-compat openssh-client

RUN wget -O docker.tgz https://download.docker.com/linux/static/stable/x86_64/docker-20.10.11.tgz ; \
    tar --extract \
		--file docker.tgz \
		--strip-components 1 \
		--directory /usr/local/bin/ \
	; \
	rm docker.tgz; \
	\
	dockerd --version; \
	docker --version

RUN go install golang.org/x/tools/cmd/goimports@latest; \
    wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.43.0

COPY modprobe.sh /usr/local/bin/modprobe
COPY docker-entrypoint.sh /usr/local/bin/

ENV DOCKER_TLS_CERTDIR=/certs

RUN mkdir /certs /certs/client && chmod 1777 /certs /certs/client

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["sh"]