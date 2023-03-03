run:
	docker compose run --rm -it -u $(shell id -u):$(shell id -g) node
