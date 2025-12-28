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
- [ ] Verify build process (install scripts) still works with these changes.
