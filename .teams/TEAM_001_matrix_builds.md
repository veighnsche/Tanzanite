# TEAM_001: Matrix Build Implementation

## Summary
Implemented multi-base image matrix builds for Tanzanite, enabling the same customizations to be applied to different base images (Fedora Cosmic Atomic, Aurora, Bluefin, etc.).

## Changes Made

### Containerfile
- Added `BASE_IMAGE` and `BASE_NAME` build args
- Made base image configurable at build time
- Moved filesystem fixes to build.sh for conditional logic

### build_files/build.sh
- Added `BASE_NAME` detection with helper functions (`is_ublue()`, `is_fedora_atomic()`)
- Made /opt and /usr/local fixes conditional (only on vanilla Fedora Atomic)
- uBlue bases skip these fixes as they're already handled

### .github/workflows/build.yml
- Added matrix strategy for multiple base images
- Currently builds: `cosmic` and `aurora` variants
- Each variant gets its own image name: `tanzanite-cosmic`, `tanzanite-aurora`
- Commented-out `bluefin` variant ready to enable

### Justfile
- Added base image variant support with new parameters
- New recipes: `build-cosmic`, `build-aurora`, `build-bluefin`, `build-all`
- Environment variables for default base configuration

## Output Images
- `ghcr.io/<owner>/tanzanite-cosmic:latest` - Fedora Cosmic Atomic base
- `ghcr.io/<owner>/tanzanite-aurora:latest` - Aurora (uBlue) base

## Local Build Commands
```bash
just build-cosmic          # Build cosmic variant
just build-aurora          # Build aurora variant
just build-all             # Build all enabled variants
```

## Notes
- The Containerfile lint warning about `${BASE_IMAGE}` is a false positive - ARG before FROM is valid Docker syntax
- To add more variants, add entries to the matrix in `.github/workflows/build.yml`

## Status
✅ Complete - Ready for testing
