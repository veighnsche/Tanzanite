# Tanzanite

A pre-configured developer workstation image based on [Aurora (uBlue)](https://getaurora.dev/), built with [BlueBuild](https://blue-build.org/).

## What's Included

### Programming Languages & Runtimes
- **Python** - with [uv](https://github.com/astral-sh/uv) package manager, ruff, black, mypy, pytest
- **Go** - with gopls, delve, golangci-lint
- **Rust** - with rust-analyzer, clippy, cargo tools
- **Node.js** - with npm, pnpm, typescript, eslint, prettier
- **Bun** - fast JavaScript runtime
- **Flutter/Dart** - with Android support

### Development Tools
- **Android SDK** - platform-tools, build-tools, NDK, emulator
- **Gradle** - with pre-cached wrapper distributions
- **Windsurf IDE** - AI-powered code editor
- **Container tools** - Podman, Buildah, Skopeo

### Build Essentials
- GCC, Clang, CMake, Ninja
- AOSP build dependencies (32-bit libs, Java 21)

## Installation

### Switch from an existing Fedora Atomic system

```bash
sudo bootc switch ghcr.io/veighnsche/tanzanite-aurora:latest
systemctl reboot
```

### Fresh Install via ISO

Download the ISO from the [Releases](https://github.com/veighnsche/Tanzanite/releases) page or build one locally:

```bash
just build-iso tanzanite-aurora latest
```

## Building Locally

See [docs/LOCAL_BUILD.md](./docs/LOCAL_BUILD.md) for detailed instructions.

### Quick Start

```bash
# Build the image
just build-aurora

# Or build with BlueBuild
bluebuild build recipes/recipe-aurora.yml
```

## Repository Structure

```
Tanzanite/
├── recipes/
│   ├── recipe-aurora.yml      # BlueBuild recipe
│   └── modules/               # Modular YAML configs
├── files/
│   ├── scripts/               # Installation scripts
│   └── system/                # System config files
├── disk_config/               # ISO/disk build configs
└── .github/workflows/         # CI/CD
```

## Customization

### Adding Packages

Edit `recipes/modules/packages.yml`:

```yaml
type: dnf
install:
  packages:
    - your-package-here
```

### Adding Scripts

1. Create script in `files/scripts/`
2. Reference in appropriate module YAML

### Environment Variables

Edit `files/system/etc/profile.d/tanzanite-dev.sh`

## Building Disk Images

Build installable disk images (ISO, qcow2, raw) using the [build-disk.yml](./.github/workflows/build-disk.yml) workflow or locally:

```bash
# Build ISO
just build-iso tanzanite-aurora latest

# Build QCOW2 for VMs
just build-qcow2 tanzanite-aurora latest
```

## Justfile Commands

| Command | Description |
|---------|-------------|
| `just build-aurora` | Build Aurora variant |
| `just build-qcow2 <image> <tag>` | Build QCOW2 VM image |
| `just build-iso <image> <tag>` | Build installable ISO |
| `just run-vm-qcow2 <image> <tag>` | Run VM from QCOW2 |
| `just clean` | Remove build artifacts |
| `just lint` | Run shellcheck on scripts |

## Resources

- [BlueBuild Documentation](https://blue-build.org/)
- [Universal Blue](https://universal-blue.org/)
- [Aurora](https://getaurora.dev/)

## License

MIT
