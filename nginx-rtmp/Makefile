build:
	@docker build -t spanda/nginx:rtmp .

test:
	@docker run -itd --rm --name rtmp -p 1935:1935 -p 8080:8080 spanda/nginx:rtmp

push:
	@docker push spanda/nginx:rtmp