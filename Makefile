GOOS ?= linux

# Image URL to use all building/pushing image targets
IMG_PREFIX ?= registry.tydic.com/kubevirt
TAG ?= v0.1
IMG ?= ${IMG_PREFIX}/virtvnc:$(TAG)

##@ Release
.PHONY: publish # Push the image to the remote registry
publish:
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--output "type=image,push=true" \
		--file ./Dockerfile \
		--tag $(IMG) \
		.
