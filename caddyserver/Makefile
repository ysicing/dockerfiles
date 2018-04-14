CADDY_IMAGE := spanda/caddy

.PHONY: all

all: build push

build:
	@docker build -t $(CADDY_IMAGE) .

push:
	@docker push $(CADDY_IMAGE)