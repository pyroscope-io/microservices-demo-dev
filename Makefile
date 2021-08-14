release: build push release-chart ## Builds and pushes image then releases the helm chart

release-chart: ## Releases helm chart
	$(shell) VERSION=${TAG} scripts/release-chart.sh

build:
	docker-compose build

push:
	docker-compose push
