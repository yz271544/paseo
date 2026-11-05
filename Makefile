.DEFAULT_GOAL := build

DOCKER ?= docker
IMAGE ?= registry.cn-beijing.aliyuncs.com/dc_huzy/paseo-trixie
TAG ?= $(shell git describe --tags --always)
NODE_IMAGE ?= node:24.20.0-trixie
DOCKERFILE ?= docker/base/Dockerfile
BUILD_ARGS ?=

# Resolve the Git version once so build and push use the same tag.
IMAGE_REF := $(IMAGE):$(TAG)

.PHONY: build push image help

build:
	$(DOCKER) build \
		--build-arg "NODE_IMAGE=$(NODE_IMAGE)" \
		-f "$(DOCKERFILE)" \
		-t "$(IMAGE_REF)" \
		$(BUILD_ARGS) .

push: build
	$(DOCKER) push "$(IMAGE_REF)"

image:
	@printf '%s\n' "$(IMAGE_REF)"

help:
	@printf '%s\n' \
		'make / make build    Build the image with the Git version tag' \
		'make push            Build and push the image' \
		'make image           Print the full image name' \
		'make build TAG=local NODE_IMAGE=node:24.20.0-trixie' \
		'make build IMAGE=paseo BUILD_ARGS="--no-cache --pull"'
