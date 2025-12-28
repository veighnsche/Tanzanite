# TEAM_009: Fix EROFS for MCP Servers

**Date:** 2025-12-28  
**Team ID:** 009  
**Status:** In Progress

## Task Summary
Investigate and fix `EROFS` (Read-only file system) errors encountered by MCP servers (specifically `android-shell`, `sequential-thinking`, `tailscale`) when running on the Tanzanite (Aurora-based) image.

## Root Cause Analysis
The project currently defines global environment variables in `/etc/profile.d/tanzanite-dev.sh` that point to cache directories in `/usr/share/` (e.g., `NPM_CONFIG_CACHE`, `UV_CACHE_DIR`). In an immutable OS like Aurora/uBlue, `/usr` is read-only at runtime. MCP servers and other tools attempting to write to these caches fail with `EROFS`.

## Proposed Solution
1. **Move Caches to Writable Storage:** Relocate global caches from `/usr/share` to `/var/cache` or `/var/lib`.
2. **Dynamic Cache Creation:** Use `systemd-tmpfiles` to ensure these directories exist on the writable overlay with correct permissions.
3. **Update Environment Variables:** Modify `/etc/profile.d/tanzanite-dev.sh` to point to the new writable locations.
4. **Clean up Immutability:** Ensure the build process populates these caches initially, but runtime writes are directed to the writable counterparts.

## Progress
- [x] Initial investigation of filesystem structure and environment variables.
- [x] Root cause identified: global env vars pointing to read-only `/usr`.
- [x] Create `systemd-tmpfiles` configuration for `/var/cache` directories.
- [x] Update `tanzanite-dev.sh` to use writable paths.
- [x] Update installation scripts (`install-node.sh`, `install-uv.sh`, etc.) to use writable paths.
## Aurora-DX Base Image Alignment (TEAM_009)
Investigated overlap between `aurora-dx` and Tanzanite.

### Findings
- **Base Packages:** `aurora-dx` already includes `git`, `podman`, `buildah`, `skopeo`, `tmux`, `curl`, `wget`, `unzip`, `zip`, `gcc`, `make`, and `just`.
- **IDEs:** `aurora-dx` includes VS Code. Tanzanite adds Windsurf. This is acceptable as Windsurf is a core requirement.
- **Containers:** `aurora-dx` defaults to Docker/VS Code integration but includes Podman. Tanzanite's specific `podman-docker` and `docker-compose` additions are kept where not clearly redundant.
- **Filesystem:** The `/opt` and `/usr/local` fixes in `00-filesystem.sh` remain critical for BlueBuild compatibility with certain base image versions.

### Conflict Resolution (TEAM_009)
The previous build failure was caused by trying to install packages already present or managed differently in the `aurora-dx` base:
- **Docker/Podman Conflict:** `podman-docker` from Fedora was conflicting with `docker-ce` pre-installed in `aurora-dx`.
- **Compose Conflict:** `docker-compose` was conflicting with `docker-compose-plugin`.
- **Dependency Redundancy:** `zlib-ng-compat-devel.i686` was already present in the base image.

### Conservative Delta (TEAM_009)
The build failed again due to missing dependencies in the build environment for the `install-android-sdk.sh` script. Specifically, `unzip` and `java` were likely missing or unavailable when the script ran.

### Resolution
- Re-added `java-21-openjdk-devel` to `packages.yml`.
- Re-added `unzip` and `zip` to `packages.yml` to guarantee availability for scripts like `install-android-sdk.sh` and `install-gradle.sh`.
- Switched to a "Conservative Delta" approach: while we want to avoid bloat, we must ensure all scripted installation steps have their host dependencies satisfied.
