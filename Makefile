GOOS ?= linux

# Image URL to use all building/pushing image targets
IMG_PREFIX ?= registry.tydic.com/kubevirt
TAG ?= v0.1
IMG ?= ${IMG_PREFIX}/virtvnc:$(TAG)
IMG_NAME ?= ${IMG_PREFIX}/virtvnc

##@ Release
.PHONY: publish # Push the image to the remote registry
publish:
	docker buildx build \
		--no-cache \
		--platform linux/amd64,linux/arm64 \
		--output "type=image,push=true" \
		--file ./Dockerfile \
		--tag $(IMG) \
		.

.PHONY: docker
docker:
	- docker rmi $(IMG_NAME):$(TAG)-arm64
	- docker rmi $(IMG_NAME):$(TAG)-amd64
	- docker manifest rm registry.tydic.com/kubevirt/virtvnc:v0.1
	docker build --build-arg ARCH=linux/arm64 -t $(IMG_NAME):$(TAG)-arm64 . -f Dockerfile_manifest
	docker push $(IMG_NAME):$(TAG)-arm64
	docker build --build-arg ARCH=linux/amd64 -t $(IMG_NAME):$(TAG)-amd64 . -f Dockerfile_manifest
	docker push $(IMG_NAME):$(TAG)-amd64
	docker manifest create --insecure --amend $(IMG_NAME):$(TAG) $(IMG_NAME):$(TAG)-arm64 $(IMG_NAME):$(TAG)-amd64
	docker manifest annotate $(IMG_NAME):$(TAG) $(IMG_NAME):$(TAG)-arm64 --os linux --arch arm64
	docker manifest annotate $(IMG_NAME):$(TAG) $(IMG_NAME):$(TAG)-amd64 --os linux --arch amd64
	docker manifest push --insecure $(IMG_NAME):$(TAG)
