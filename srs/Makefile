build:
	docker build -t local/srs .

test:
	docker run -it -v $(PWD)/err.log:/opt/objs/srs.log --name srs local/srs