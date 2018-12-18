dns:
	docker build -t spanda/dns .

test:
	docker run -it --rm -p 53:53/udp -p 5380:8080 -e "HTTP_USER=dns" -e "HTTP_PASS=dns" spanda/dns