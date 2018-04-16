.PHONY: all

all: build push

build:
	@docker build --no-cache -t spanda/rsshub .

push:
	@docker push spanda/rsshub