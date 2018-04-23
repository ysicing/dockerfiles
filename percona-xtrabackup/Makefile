all: base plugins
test: base plugins ysicing
base:
	@docker build -t spanda/percona-xtrabackup:base -f Dockerfile.base .

plugins:
	@docker build -t spanda/plugins:xtrabackup -f Dockerfile.plugin .

ysicing:
	@docker tag spanda/plugins:xtrabackup ysicing/xtrabackup
	@docker push ysicing/xtrabackup