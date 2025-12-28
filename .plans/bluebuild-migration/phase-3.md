# Phase 3: Migration

**Team:** TEAM_004  
**Status:** Pending  
**Depends on:** Phase 2 complete

---

## Migration Strategy

### Order of Operations

1. Create new BlueBuild structure alongside existing code
2. Create and test GitHub Actions workflow with BlueBuild
3. Verify builds work
4. Remove old build system

### Rollback Plan

- Keep old `Containerfile` and `build_files/` until new system is verified
- Can revert to old workflow by restoring `.github/workflows/build.yml`

---

## Steps

### Step 1: Create BlueBuild GitHub Action Workflow

Replace current workflow with BlueBuild action:

```yaml
# .github/workflows/build.yml
name: Build BlueBuild Image

on:
  pull_request:
    branches: [main]
  schedule:
    - cron: '05 10 * * *'
  push:
    branches: [main]
    paths-ignore:
      - '**/README.md'
  workflow_dispatch:

jobs:
  build-aurora:
    name: Build Aurora
    runs-on: ubuntu-24.04
    permissions:
      contents: read
      packages: write
      id-token: write
    steps:
      - uses: blue-build/github-action@v1
        with:
          recipe: recipe-aurora.yml
          cosign_private_key: ${{ secrets.SIGNING_SECRET }}
          registry_token: ${{ github.token }}
          pr_event_number: ${{ github.event.number }}
          use_cache: true

```

### Step 2: Move Recipe Files to Correct Location

BlueBuild expects recipes in `config/` or `recipes/`:
- Move `recipes/recipe-aurora.yml` → `recipes/recipe-aurora.yml` (already correct)
- Or use `config/recipe-aurora.yml` if preferred

### Step 3: Test Build Locally (Optional)

```bash
# Install BlueBuild CLI
cargo install blue-build

# Build locally
bluebuild build recipes/recipe-aurora.yml

# Or with podman
podman build -f Containerfile.bluebuild .
```

### Step 4: Push and Verify CI

1. Commit all new files
2. Push to trigger workflow
3. Monitor build logs
4. Verify image is pushed to GHCR
5. Verify cosign signature

### Step 5: Test Rebasing

On a test machine:
```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/veighnsche/tanzanite-aurora:latest
systemctl reboot
```

Verify:
- All dev tools present (`flutter --version`, `go version`, etc.)
- Environment variables set correctly
- No missing dependencies

---

## Verification Checklist

- [ ] Aurora build succeeds
- [ ] Images pushed to GHCR
- [ ] Images signed with cosign
- [ ] `flutter --version` works
- [ ] `go version` works
- [ ] `rustc --version` works
- [ ] `node --version` works
- [ ] `bun --version` works
- [ ] `adb --help` works
- [ ] Environment variables present in `/etc/profile.d/tanzanite-dev.sh`

---

## Exit Criteria

- Aurora variant builds successfully via BlueBuild
- Images are signed and pushed to GHCR
- All verification checks pass
