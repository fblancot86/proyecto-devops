# Variables used to configure
IMAGE_REGISTRY	?= ghcr.io
IMAGE_REPO		= fblancot86
IMAGE_NAME		?= flask-app
VERSION			?= 0.0.87

# Variables used to configure docker images registries to build and push
IMAGE			= $(IMAGE_REGISTRY)/$(IMAGE_REPO)/$(IMAGE_NAME):$(VERSION)
IMAGE_LATEST	= $(IMAGE_REGISTRY)/$(IMAGE_REPO)/$(IMAGE_NAME):latest

.PHONY: docker-build
docker-build: ## Build main image
	docker build -t $(IMAGE) -t $(IMAGE_LATEST) ../application/flask-mysql-app/.

.PHONY: publish
publish: docker-build ## Publish main image
	docker push $(IMAGE)
	docker push $(IMAGE_LATEST)
	
