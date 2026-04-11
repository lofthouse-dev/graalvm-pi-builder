# CLAUDE.md — graalvm-pi-builder

## Image purpose

`ghcr.io/lofthouse-dev/graalvm-pi-builder` is an aarch64 container image built on
`debian:bookworm` (same glibc as Raspberry Pi OS 12). It bundles:

- GraalVM Community Edition (Java 25) with `native-image`
- `gcc`, `libc-dev`, `zlib1g-dev` — native toolchain required by `native-image` to link binaries
- `libi2c-dev` — I2C headers for Pi hardware FFM bindings (required by Pi4J SMBusContext)

## Image name and tags

| Variable | Value |
|---|---|
| Image | `ghcr.io/lofthouse-dev/graalvm-pi-builder` |
| Mutable tag | `bookworm-graal25` |
| Immutable tag | `bookworm-25.0.2` |
| Dev/local tag | `latest` |

## Current versions

| Tool | Version |
|---|---|
| GraalVM CE | 25.0.2 |

## Build commands

```bash
make build-dev      # build :latest — dev iteration
make build          # build :bookworm-graal25
make build-release  # build :bookworm-graal25 + :bookworm-25.0.2
make setup-podman   # install QEMU aarch64 binfmt (Arch Linux only)
```

## Future work

- GitHub Actions PR workflow: build test (no push)
- GitHub Actions tag push workflow: build + push to GHCR
