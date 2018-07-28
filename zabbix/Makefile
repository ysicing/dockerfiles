all: build-ui build-proxy build-server
build-ui:
	docker build -t spanda/zabbix-ui:v3.4 ui

build-proxy:
	docker build -t spanda/zabbix-proxy:v3.4 proxy

build-server:
	docker build -t spanda/zabbix-server:v3.4 server

push:
	docker push spanda/zabbix-server:v3.4
	docker push spanda/zabbix-proxy:v3.4
	docker push spanda/zabbix-ui:v3.4