SHELL := bash -e

include project.mk

default: all

all: docker-build

.PHONY: clean docker-build docker-push build push
clean:
	$(CONTAINER_ENGINE) --config=$(CONTAINER_ENGINE_CONFIG_DIR) rmi $(IMG) $(IMG_LATEST) || true

build: docker-build
docker-build: clean
	$(CONTAINER_ENGINE) --config=$(CONTAINER_ENGINE_CONFIG_DIR) build -t $(IMG) -f Dockerfile .
	$(CONTAINER_ENGINE) --config=$(CONTAINER_ENGINE_CONFIG_DIR) tag $(IMG) $(IMG_LATEST)

push: docker-push
docker-push: docker-build
	@skopeo copy --dest-creds "$(QUAY_USER):$(QUAY_TOKEN)" \
		"docker-daemon:$(IMG_LATEST)" \
		"docker://$(IMG_LATEST)"
	@skopeo copy --dest-creds "$(QUAY_USER):$(QUAY_TOKEN)" \
		"docker-daemon:$(IMG)" \
		"docker://$(IMG)"
