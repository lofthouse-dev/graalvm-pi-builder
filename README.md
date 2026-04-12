# graalvm-pi-builder

A general-purpose aarch64 GraalVM build environment matched to Raspberry Pi OS 12 (Debian bookworm).

## What this image is

`ghcr.io/lofthouse-dev/graalvm-pi-builder` is a container image built for `linux/arm64` on top of
`debian:bookworm` — the same glibc base as Raspberry Pi OS 12. It bundles:

- **GraalVM Community Edition** (Java 25) with `native-image`
- **gcc, libc-dev, zlib1g-dev** — native toolchain required by `native-image` to link binaries
- **libi2c-dev** — I2C headers for compiling FFM bindings against Pi hardware (required by Pi4J SMBusContext)

The image is intended as a build tool, not a runtime base. System library versions follow Debian
bookworm and will change between builds as security patches land.

## Use cases

- Capturing FFM reachability metadata with the `native-image-agent`
- Generating CAP caches (`-H:+NewCAPCache`) for GraalVM native-image builds
- Building GraalVM native binaries targeting aarch64 / Pi OS 12

## Image tags

| Tag | Type | Meaning |
|---|---|---|
| `bookworm-graal25` | Mutable | Latest build of GraalVM 25.x on Debian bookworm; updated on each publish |
| `bookworm-25.0.2` | Rolling | GraalVM version pinned; apt packages reflect the latest bookworm at publish time |
| `bookworm-25.0.2-YYYYMMDD` | Snapshot | Exact build date — use this tag when you need a fully reproducible reference |

Use the mutable tag to track updates. Pin to a snapshot tag when you need reproducibility.

## Pulling the image

This is an `linux/arm64`-only image. On x86_64 hosts you must specify the platform explicitly:

```bash
# Latest GraalVM 25 on bookworm
podman pull --platform linux/arm64 ghcr.io/lofthouse-dev/graalvm-pi-builder:bookworm-graal25
docker pull --platform linux/arm64 ghcr.io/lofthouse-dev/graalvm-pi-builder:bookworm-graal25

# Pinned to a specific GraalVM version
podman pull --platform linux/arm64 ghcr.io/lofthouse-dev/graalvm-pi-builder:bookworm-25.0.2

# Reproducible snapshot
podman pull --platform linux/arm64 ghcr.io/lofthouse-dev/graalvm-pi-builder:bookworm-25.0.2-20260120
```

On native arm64 hosts (e.g. Raspberry Pi, Apple Silicon) the `--platform` flag is not needed.

## Using the image

As a base image in a Containerfile or Dockerfile:

```dockerfile
FROM ghcr.io/lofthouse-dev/graalvm-pi-builder:bookworm-graal25
```

Running a native-image build directly (add `--platform linux/arm64` on x86_64 hosts):

```bash
podman run --rm --platform linux/arm64 -v $(pwd):/build:z \
  ghcr.io/lofthouse-dev/graalvm-pi-builder:bookworm-graal25 \
  native-image -jar myapp.jar
```

## Building locally

### Prerequisites

- [Podman](https://podman.io/)
- On x86_64 hosts: QEMU aarch64 binfmt support (`make setup-podman` — Arch Linux only; see
  your distro docs for other systems)

### Makefile targets

```bash
# One-time QEMU setup (Arch Linux x86_64 hosts only)
make setup-podman

# Dev iteration — builds tagged :latest
make build-dev

# Named mutable release tag (:bookworm-graal25)
make build

# All three tags: mutable, version-pinned, and timestamped snapshot
make build-release
```

`build-dev` is the iteration target during development. `build-release` mirrors what the publish
workflow pushes to GHCR.

## Publishing via GitHub Actions

Images are published to GHCR manually via a `workflow_dispatch` workflow. To trigger a publish:

1. Go to the [Actions tab](../../actions/workflows/publish.yml) in the repository
2. Select **Publish container image**
3. Click **Run workflow**
4. Optionally override the GraalVM version (defaults to the current release)
5. Click **Run workflow**

The workflow builds the `linux/arm64` image using QEMU on a standard GitHub-hosted runner and
pushes all three tags (`bookworm-graalN`, `bookworm-X.Y.Z`, `bookworm-X.Y.Z-YYYYMMDD`) in a
single build.

## Updating GraalVM

When a new GraalVM CE release is available:

1. Change `GRAALVM` in `Makefile`
2. Change the `ARG GRAALVM_VERSION` default in `Containerfile`
3. Change the `graalvm_version` default in `.github/workflows/publish.yml`
4. Push to the repository
5. Trigger the publish workflow via the Actions tab

## License

Apache License 2.0 — see [LICENSE](LICENSE).
