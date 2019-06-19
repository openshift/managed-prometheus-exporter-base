SHELL := bash -e

include project.mk

# Generate version and tag information from inputs
COMMIT_NUMBER=$(shell git rev-list `git rev-list --parents HEAD | egrep "^[a-f0-9]{40}$$"`..HEAD --count)
CURRENT_COMMIT=$(shell git rev-parse --short=8 HEAD)
VERSION_FULL=$(VERSION_MAJOR).$(VERSION_MINOR).$(COMMIT_NUMBER)-$(CURRENT_COMMIT)

IMG ?= $(IMAGE_REGISTRY)/$(IMAGE_REPOSITORY)/$(IMAGE_NAME):$(VERSION_FULL)

BUILD_ARCHES ?= amd64

default: all

all: docker-build

.PHONY: clean docker-build
clean:
	docker rmi $(IMG) || true

docker-build: clean
	docker build -t $(IMG) -f Dockerfile .
