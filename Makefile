IMAGE     = ghcr.io/lofthouse-dev/graalvm-pi-builder
GRAALVM   = 25.0.2
MUTABLE   = bookworm-graal25
IMMUTABLE = bookworm-$(GRAALVM)
SNAPSHOT  = bookworm-$(GRAALVM)-$(shell date +%Y%m%d%H%M)
LOCAL     = latest

.DEFAULT_GOAL := help

.PHONY: help build-dev build build-release setup-podman

help:
	@echo "Targets:"
	@echo "  build-dev      Build tagged $(IMAGE):$(LOCAL) (dev iteration)"
	@echo "  build          Build tagged $(IMAGE):$(MUTABLE)"
	@echo "  build-release  Build and tag as $(IMAGE):$(MUTABLE), $(IMAGE):$(IMMUTABLE),"
	@echo "                 and $(IMAGE):$(SNAPSHOT)"
	@echo "  setup-podman   Install QEMU aarch64 binfmt support (Arch Linux)"

build-dev:
	podman build --platform linux/arm64 -t $(IMAGE):$(LOCAL) .

build:
	podman build --platform linux/arm64 -t $(IMAGE):$(MUTABLE) .

build-release:
	podman build --platform linux/arm64 \
	  -t $(IMAGE):$(MUTABLE) \
	  -t $(IMAGE):$(IMMUTABLE) \
	  -t $(IMAGE):$(SNAPSHOT) \
	  .

setup-podman:
	scripts/setup/setup-podman.sh
