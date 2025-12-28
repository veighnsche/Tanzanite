# Phase 1: Discovery and Safeguards

**Team:** TEAM_004  
**Status:** Planning  
**Purpose:** Understand current system, map to BlueBuild equivalents, identify behavioral contracts

---

## Refactor Summary

Migrate Tanzanite from a hand-rolled Containerfile + bash script build system to BlueBuild's declarative `recipe.yml` framework.

### Pain Points
1. Complex `/root` and `/usr/local` symlink handling required
2. Flutter/Gradle tar ownership errors in container builds
3. No cross-run build caching
4. Manual dnf5 package management in bash
5. Environment variables scattered across modules
6. Hard to debug build failures

### Motivation
- BlueBuild handles atomic Fedora quirks automatically
- Declarative YAML is easier to maintain than bash scripts
- Built-in caching via `use_cache: true`
- Community-supported modules for common tasks
- Standardized GitHub Action

---

## Success Criteria

### Before (Current)
```
Tanzanite/
├── Containerfile                    # Hand-rolled, single RUN command
├── .github/workflows/build.yml      # Custom buildah workflow
└── build_files/
    ├── build.sh                     # Orchestrator
    ├── lib/common.sh                # Helper functions
    └── modules/
        ├── 01-filesystem.sh         # /root, /opt, /usr/local fixes
        ├── 02-packages.sh           # dnf packages + Windsurf
        ├── 03-languages.sh          # Python, Go, Rust, Node, Bun, Flutter
        ├── 04-devtools.sh           # gcc, Gradle
        ├── 05-android.sh            # Android SDK
        ├── 06-environment.sh        # Environment variables
        └── 07-containers.sh         # Podman/Docker
```

### After (Target)
```
Tanzanite/
├── recipes/
│   └── recipe-aurora.yml            # Aurora variant recipe
├── config/                          # (alternative location)
├── files/
│   ├── scripts/                     # Custom build scripts
│   │   ├── install-languages.sh     # Python, Go, Rust, Node, Bun
│   │   ├── install-flutter.sh       # Flutter SDK (special handling)
│   │   ├── install-android.sh       # Android SDK
│   │   └── install-gradle.sh        # Gradle
│   └── system/
│       └── etc/
│           └── profile.d/
│               └── tanzanite-dev.sh # Environment variables
└── .github/workflows/build.yml      # BlueBuild GitHub Action
```

---

## Behavioral Contracts

### Must Preserve
1. **Image output:** `ghcr.io/veighnsche/tanzanite-aurora:latest`
2. **Installed tools:** All languages and dev tools must be present
3. **Environment variables:** All PATH and cache env vars must be set
4. **Cosign signing:** Images must be signed

### Can Change
1. Build internals (Containerfile → recipe.yml)
2. GitHub Actions workflow structure
3. File organization

---

## Current Architecture Mapping

| Current Module | BlueBuild Equivalent |
|----------------|---------------------|
| `01-filesystem.sh` | `type: script` module - **STILL NEEDED**. BlueBuild's `optfix` is deprecated and only handles specific packages. Must convert `/root`, `/opt`, `/usr/local` symlinks manually. |
| `02-packages.sh` | `type: dnf` module |
| `03-languages.sh` | `type: script` module with custom scripts |
| `04-devtools.sh` | `type: dnf` + `type: script` modules |
| `05-android.sh` | `type: script` module |
| `06-environment.sh` | `type: containerfile` with COPY, or `type: script` to copy from `files/` dir |
| `07-containers.sh` | `type: dnf` module |

---

## Constraints

1. **Base images:** Aurora (uBlue) - other uBlue variants (bluefin, bazzite) may be added later
2. **Architecture:** x86_64 only (for now)
3. **No user-space files:** Cannot write to `/home/` at build time
4. **rpm-ostree symlinks:** Base images may have `/root/`, `/usr/local/`, `/opt/` as symlinks - must convert to directories in filesystem setup script

---

## Open Questions

1. **Flutter as root:** Flutter warns against running as root. Should we:
   - Use `--no-analytics` and ignore the warning?
   - Skip Flutter precache entirely and let users do it on first run?
   - Use a non-root user during build (complex)?

2. **Caching strategy:** BlueBuild's `use_cache: true` pushes layers to registry. Is this sufficient?

3. **Multiple recipes:** Should we use one recipe with conditionals or separate recipes per variant?

---

## Steps

### Step 1: Map Current Packages to DNF Module
- Extract all `dnf5 install` commands from current scripts
- Create declarative package lists for BlueBuild `dnf` module

### Step 2: Create BlueBuild File Structure
- Create `recipes/`, `files/scripts/`, `files/system/` directories
- Create initial `recipe.yml` skeleton

### Step 3: Convert GitHub Actions Workflow
- Replace current workflow with BlueBuild GitHub Action
- Maintain cosign signing

### Step 4: Test Build
- Run local build with `bluebuild build`
- Verify all tools are present
- Compare with current image

---

## Next Phase
After Phase 1, proceed to Phase 2 (Structural Extraction) to begin creating the actual BlueBuild configuration.
