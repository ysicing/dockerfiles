local: local_build local_test

local_build:
	docker build -t local/srs .

local_test:
	docker run -it --name srs local/srs


all: build push

build:
	docker build -t spanda/srs .

push:
	docker push spanda/srs