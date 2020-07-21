# Makefile
GIT_SHA1 = $(shell git rev-parse --verify HEAD)
IMAGES_TAG = ${shell git describe --exact-match 2> /dev/null || echo 'latest'}

IMAGE_DIRS = $(wildcard services/* bases/*)

# All targets are `.PHONY` ie allways need to be rebuilt
.PHONY: all ${IMAGE_DIRS}

# Build all images
all: ${IMAGE_DIRS}

# Build and tag a single image
${IMAGE_DIRS}:
	$(eval IMAGE_NAME := $(word 2,$(subst /, ,$@)))
	docker build -t freight-trust/${IMAGE_NAME}:${IMAGES_TAG} -t freight-trust/${IMAGE_NAME}:latest --build-arg TAG=${IMAGES_TAG} --build-arg GIT_SHA1=${GIT_SHA1} $@


# Specify dependencies between images
services/generic-node: bases/generic-node
services/generic-rust: bases/generic-rust
services/generic-service: bases/generic-base

