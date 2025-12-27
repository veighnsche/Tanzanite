# Local Build Instructions for MacBook M4

Your M4 MacBook can build these images **much faster** than GitHub Actions runners (which are 2-4 vCPU Ubuntu VMs). However, there's a catch: you're building x86_64 Linux images on ARM64 macOS, so you need emulation.

## Prerequisites

### 1. Install Podman Desktop (Recommended)

```bash
brew install podman-desktop
```

Or install just the CLI:

```bash
brew install podman
```

### 2. Initialize Podman Machine

Create a Podman machine with enough resources:

```bash
# Create a machine with 8 CPUs, 16GB RAM, 100GB disk
podman machine init --cpus 8 --memory 16384 --disk-size 100

# Start the machine
podman machine start
```

### 3. Enable x86_64 Emulation (QEMU)

Your M4 is ARM64, but the images are x86_64. Podman handles this via QEMU:

```bash
# The Podman machine should auto-configure this, but verify:
podman run --rm --platform linux/amd64 alpine uname -m
# Should output: x86_64
```

## Building the Image

### Quick Build (Single Variant)

```bash
cd /path/to/Tanzanite

# Build Aurora variant
just build tanzanite-aurora latest

# Or build Cosmic variant
just build tanzanite-cosmic latest
```

### Manual Build Command

```bash
# Aurora
podman build \
  --platform linux/amd64 \
  --build-arg BASE_IMAGE=ghcr.io/ublue-os/aurora:stable \
  --build-arg BASE_NAME=aurora \
  -t tanzanite-aurora:latest \
  .

# Cosmic
podman build \
  --platform linux/amd64 \
  --build-arg BASE_IMAGE=quay.io/fedora-ostree-desktops/cosmic-atomic:43 \
  --build-arg BASE_NAME=cosmic \
  -t tanzanite-cosmic:latest \
  .
```

## Speed Comparison

| Environment | Estimated Build Time |
|-------------|---------------------|
| GitHub Actions (2 vCPU) | 45-90 minutes |
| M4 MacBook (8 cores, emulated) | 20-40 minutes |
| Native x86_64 Linux (8 cores) | 10-20 minutes |

**Note:** Even with emulation overhead, your M4 should be ~2x faster than GitHub Actions due to raw CPU power and better I/O.

## Testing the Image Locally

### Option 1: VM with QEMU

```bash
# First, build a qcow2 disk image
just build-qcow2 tanzanite-aurora latest

# Then run it
just run-vm-qcow2 tanzanite-aurora latest
```

### Option 2: Inspect the Image

```bash
# List layers
podman history tanzanite-aurora:latest

# Inspect contents
podman run --rm -it tanzanite-aurora:latest /bin/bash
```

## Pushing to GHCR

To push your locally-built image to GitHub Container Registry:

```bash
# Login to GHCR
echo $GITHUB_TOKEN | podman login ghcr.io -u YOUR_USERNAME --password-stdin

# Tag for GHCR
podman tag tanzanite-aurora:latest ghcr.io/veighnsche/tanzanite-aurora:latest

# Push
podman push ghcr.io/veighnsche/tanzanite-aurora:latest
```

## Troubleshooting

### Build runs out of disk space

```bash
# Prune unused images and containers
podman system prune -a

# Or recreate the machine with more disk
podman machine rm
podman machine init --cpus 8 --memory 16384 --disk-size 150
podman machine start
```

### Build is slow

The x86_64 emulation adds overhead. Tips:
- Ensure Rosetta 2 is installed: `softwareupdate --install-rosetta`
- Close other apps to free RAM
- Use `--jobs` flag if available to parallelize

### Platform mismatch errors

Always specify `--platform linux/amd64`:

```bash
podman build --platform linux/amd64 ...
```

## Automated Local Build Script

Create `build-local.sh` in the repo root:

```bash
#!/bin/bash
set -euo pipefail

BASE_NAME="${1:-aurora}"
TAG="${2:-latest}"

case "$BASE_NAME" in
  aurora)
    BASE_IMAGE="ghcr.io/ublue-os/aurora:stable"
    ;;
  cosmic)
    BASE_IMAGE="quay.io/fedora-ostree-desktops/cosmic-atomic:43"
    ;;
  *)
    echo "Unknown base: $BASE_NAME"
    exit 1
    ;;
esac

echo "Building tanzanite-$BASE_NAME:$TAG..."
podman build \
  --platform linux/amd64 \
  --build-arg BASE_IMAGE="$BASE_IMAGE" \
  --build-arg BASE_NAME="$BASE_NAME" \
  -t "tanzanite-$BASE_NAME:$TAG" \
  .

echo "Done! Image: tanzanite-$BASE_NAME:$TAG"
```

Make it executable:

```bash
chmod +x build-local.sh
./build-local.sh aurora latest
```
