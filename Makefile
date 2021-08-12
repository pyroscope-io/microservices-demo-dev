all: build push

.PHONY: build
build:
	docker-compose build

push:
	docker-compose push
