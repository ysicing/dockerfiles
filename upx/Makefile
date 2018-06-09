local:
	docker build -t local/upx .

build:
	docker build -t spanda/upx .

test:
	docker run -v `pwd`:/go/src/ -w /go/src/ --rm -it spanda/upx go build -o world ./hello/
	docker run -v `pwd`:/go/src/ -w /go/src/ --rm -it spanda/upx /usr/local/bin/upx --best world

local-alpine:
	docker build -t local/upx:alpine -f Dockerfile.alpine .

build-alpine:
	docker build -t spanda/upx:alpine -f Dockerfile.alpine .

test-alpine:
	docker run -v `pwd`:/go/src/ -w /go/src/ --rm -it spanda/upx:alpine go build -o world ./hello/
	docker run -v `pwd`:/go/src/ -w /go/src/ --rm -it spanda/upx:alpine /usr/bin/upx --best world
