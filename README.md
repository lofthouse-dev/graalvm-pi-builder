# graalvm-pi-builder

A general-purpose aarch64 GraalVM build environment matched to Raspberry Pi OS 12 (Debian bookworm).

## What this image is

`ghcr.io/lofthouse-dev/graalvm-pi-builder` is a container image built for `linux/arm64` on top of
`debian:bookworm` — the same glibc base as Raspberry Pi OS 12. It bundles:

- **GraalVM Community Edition** (Java 25) with `native-image`
- **gcc, libc-dev, zlib1g-dev** — native toolchain required by `native-image` to link binaries
- **libi2c-dev** — I2C headers for compiling FFM bindings against Pi hardware (required by Pi4J SMBusContext)

The image is version-pinned and reproducible, making it suitable for local development via
Podman + QEMU and for CI on native arm64 runners.

## Use cases

- Capturing FFM reachability metadata with the `native-image-agent`
- Generating CAP caches (`-H:+NewCAPCache`) for GraalVM native-image builds
- Building GraalVM native binaries targeting aarch64 / Pi OS 12

## Image tags

| Tag | Type | Meaning |
|---|---|---|
| `bookworm-graal25` | Mutable | Latest GraalVM 25.x on Debian bookworm; updated in place |
| `bookworm-25.0.2` | Immutable | Pinned to a specific GraalVM release |

Use the mutable tag to track updates; use the immutable tag to pin a known-good build.

## Prerequisites

- [Podman](https://podman.io/)
- On x86_64 hosts: QEMU aarch64 binfmt support (`make setup-podman`)

## Build

```bash
# One-time QEMU setup (Arch Linux x86_64 hosts only)
make setup-podman

# Dev iteration — builds tagged :latest
make build-dev

# Named mutable release tag
make build

# Both mutable and immutable tags
make build-release
```

`build-dev` is the iteration target during development. `build` and `build-release` are for
publishing to GHCR.

## Updating GraalVM

1. Change `GRAALVM` in `Makefile`
2. Change the `ARG GRAALVM_VERSION` default in `Containerfile`
3. Run `make build-release`

## Using the image

As a base image:

```dockerfile
FROM ghcr.io/lofthouse-dev/graalvm-pi-builder:bookworm-graal25
```

As a container for native-image workloads:

```bash
podman run --rm -v $(pwd):/build:z ghcr.io/lofthouse-dev/graalvm-pi-builder:bookworm-graal25 \
  native-image -jar myapp.jar
```

## License

Apache License 2.0 — see [LICENSE](LICENSE).
