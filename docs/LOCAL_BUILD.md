# Local Build Instructions

## Prerequisites

### Install BlueBuild CLI

```bash
cargo install blue-build
```

Or use the container-based build (no installation needed).

### For macOS (M1/M2/M3/M4)

Your Mac can build these images but needs x86_64 emulation:

```bash
# Install Podman
brew install podman-desktop

# Create a machine with enough resources
podman machine init --cpus 8 --memory 16384 --disk-size 100
podman machine start

# Verify x86_64 emulation works
podman run --rm --platform linux/amd64 alpine uname -m
# Should output: x86_64
```

## Building the Image

### Using BlueBuild (Recommended)

```bash
cd /path/to/Tanzanite

# Build Aurora variant
bluebuild build recipes/recipe-aurora.yml

# Or use just
just build-aurora
```

### Using Podman Directly

BlueBuild can generate a Containerfile:

```bash
# Generate Containerfile from recipe
bluebuild generate recipes/recipe-aurora.yml

# Build with podman
podman build --platform linux/amd64 -t tanzanite-aurora:latest .
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

## Resources

- [BlueBuild Documentation](https://blue-build.org/)
- [BlueBuild Recipe Reference](https://blue-build.org/reference/recipe/)
- [BlueBuild Module Reference](https://blue-build.org/reference/module/)
