# TEAM_004: BlueBuild Migration

## Team Info
- **Created:** 2025-12-28
- **Purpose:** Migrate from hand-rolled Containerfile/shell scripts to BlueBuild framework
- **Status:** Planning

## Context
The current build system uses:
- Custom `Containerfile` with shell script modules
- `build_files/` directory with modular bash scripts
- Custom GitHub Actions workflow

Pain points:
- Complex debugging (e.g., `/root` directory issues, Flutter tar ownership errors)
- No standardized caching
- Manual handling of rpm-ostree symlinks
- Build errors are hard to diagnose

## Target
Migrate to BlueBuild which provides:
- Declarative `recipe.yml` configuration
- Built-in modules for common tasks (dnf, files, script)
- Standardized GitHub Action with proper caching (`use_cache: true`)
- Community-supported best practices
- Automatic handling of atomic Fedora quirks

## Planning Artifacts
- `.plans/bluebuild-migration/phase-1.md` - Discovery and Safeguards
- `.plans/bluebuild-migration/phase-2.md` - Structural Extraction  
- `.plans/bluebuild-migration/phase-3.md` - Migration
- `.plans/bluebuild-migration/phase-4.md` - Cleanup
- `.plans/bluebuild-migration/phase-5.md` - Hardening and Handoff

## Progress Log
- [2025-12-28] Team registered, beginning planning phase
