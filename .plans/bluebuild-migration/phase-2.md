# Phase 2: Structural Extraction

**Team:** TEAM_004  
**Status:** Pending  
**Depends on:** Phase 1 complete

---

## Target Design

### Recipe Structure

Aurora variant recipe file:

```yaml
# recipes/recipe-aurora.yml
---
# yaml-language-server: $schema=https://schema.blue-build.org/recipe-v1.json
name: tanzanite-aurora
description: Aurora (uBlue) with developer tooling
base-image: ghcr.io/ublue-os/aurora
image-version: stable

modules:
  - from-file: modules/filesystem.yml    # MUST BE FIRST - fixes symlinks
  - from-file: modules/packages.yml
  - from-file: modules/languages.yml
  - from-file: modules/devtools.yml
  - from-file: modules/android.yml
  - from-file: modules/environment.yml
```

### Module Files (recipes/modules/)

Modular YAML files for organization:

```
recipes/
├── recipe-aurora.yml
└── modules/
    ├── filesystem.yml     # FIRST: Convert symlinks to directories
    ├── packages.yml       # Base packages via dnf module
    ├── languages.yml      # Script module for language toolchains
    ├── devtools.yml       # Build tools, Gradle
    ├── android.yml        # Android SDK
    └── environment.yml    # Containerfile module for env vars
```

### Script Files (files/scripts/)

Custom bash scripts for complex installations:

```
files/
├── scripts/
│   ├── 00-filesystem.sh       # CRITICAL: Convert /root, /opt, /usr/local symlinks
│   ├── install-uv.sh          # Python uv package manager
│   ├── install-go.sh          # Go toolchain + tools
│   ├── install-rust.sh        # Rust toolchain + components
│   ├── install-node.sh        # Node.js + npm/pnpm packages
│   ├── install-bun.sh         # Bun runtime
│   ├── install-flutter.sh     # Flutter SDK (careful with root)
│   ├── install-gradle.sh      # Gradle + wrapper cache
│   ├── install-android-sdk.sh # Android SDK components
│   ├── install-scrcpy.sh      # scrcpy + desktop entry
│   └── install-windsurf.sh    # Windsurf IDE + repo
├── containerfiles/
│   └── copy-env.Containerfile # COPY for environment files
└── system/
    └── etc/
        └── profile.d/
            └── tanzanite-dev.sh  # Environment variables
```

**Note:** `00-filesystem.sh` MUST run first before any package installation.

---

## Module Specifications

### packages.yml (dnf module)

```yaml
type: dnf
install:
  packages:
    # Base development
    - gcc
    - gcc-c++
    - make
    - pkg-config
    - openssl-devel
    - git
    - clang
    - cmake
    - ninja-build
    
    # Python
    - python3
    - python3-pip
    - python3-devel
    
    # Flutter dependencies
    - gtk3-devel
    
    # Containers
    - podman
    - buildah
    - skopeo
    
    # Utilities
    - tmux
    - mosh
    - curl
    - wget
    - unzip
    - zip
```

### filesystem.yml (script module - MUST BE FIRST)

```yaml
type: script
scripts:
  - 00-filesystem.sh
```

### languages.yml (script module)

```yaml
type: script
scripts:
  - install-uv.sh
  - install-go.sh
  - install-rust.sh
  - install-node.sh
  - install-bun.sh
  - install-flutter.sh
```

### environment.yml (containerfile module)

```yaml
# NOTE: BlueBuild doesn't have a "type: files" module.
# Use containerfile module with COPY instruction instead:
type: containerfile
containerfiles:
  - copy-env.Containerfile
```

Where `files/containerfiles/copy-env.Containerfile` contains:
```dockerfile
COPY files/system/etc/profile.d/tanzanite-dev.sh /etc/profile.d/tanzanite-dev.sh
```

**Alternative:** Use a script module to copy from `/tmp/files/` during build.

---

## Steps

### Step 1: Create Directory Structure
- Create `recipes/`, `recipes/modules/`, `files/scripts/`, `files/system/`

### Step 2: Create Package Module
- Extract all dnf packages from current scripts
- Create `recipes/modules/packages.yml`

### Step 3: Create Language Install Scripts
- Convert `03-languages.sh` sections into individual scripts
- Each script is self-contained and idempotent
- Remove `/root` handling (BlueBuild handles this)

### Step 4: Create Environment Files
- Move `tanzanite-dev.sh` to `files/system/etc/profile.d/`

### Step 5: Create Recipe Files
- Create `recipe-aurora.yml`
- Include all modules in correct order

### Step 6: Verify Structure
- Ensure all files are in place
- Validate YAML syntax

---

## Exit Criteria
- All module YAML files created
- All script files created
- Recipe files reference modules correctly
- No syntax errors in YAML
