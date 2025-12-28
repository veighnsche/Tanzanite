# TEAM_006: Implement BlueBuild Migration

## Team Info
- **Created:** 2025-12-28
- **Purpose:** Implement the BlueBuild migration plan (Phase 2 structural extraction)
- **Status:** Complete (Phase 4 blocked on verification)

## Context
- Plan location: `.plans/bluebuild-migration/`
- Plan reviewed by: TEAM_005
- Open questions: `.questions/TEAM_004_bluebuild.md`

## Pre-Implementation Checklist
- [x] Read all phase files
- [x] Check open questions
- [x] Verify current build works (baseline)

## Progress Log
- [2025-12-28] Team registered, starting implementation
- [2025-12-28] Phase 2 complete: Created BlueBuild directory structure
- [2025-12-28] Phase 3 complete: Created GitHub Actions workflow

---

## Files Created

### Directory Structure
```
recipes/
├── recipe-aurora.yml
├── recipe-cosmic.yml
└── modules/
    ├── filesystem.yml
    ├── packages.yml
    ├── languages.yml
    ├── devtools.yml
    ├── android.yml
    ├── environment.yml
    └── system.yml

files/
├── scripts/
│   ├── 00-filesystem.sh
│   ├── install-uv.sh
│   ├── install-go.sh
│   ├── install-rust.sh
│   ├── install-node.sh
│   ├── install-bun.sh
│   ├── install-flutter.sh
│   ├── install-gradle.sh
│   ├── install-android-sdk.sh
│   ├── install-scrcpy.sh
│   ├── install-windsurf.sh
│   └── setup-system.sh
└── system/
    └── etc/
        └── profile.d/
            └── tanzanite-dev.sh

.github/workflows/
└── build-bluebuild.yml
```

### Key Decisions
1. **Q1 (Flutter root):** Using `--no-analytics` and ignoring the warning
2. **Q2 (Caching):** Using `use_cache: true` from BlueBuild
3. **Environment files:** Using script snippet to copy from `/tmp/files/`

---

## Phase 4: Cleanup (BLOCKED)

**Status:** Waiting for build verification

Do NOT delete old build system until:
- [ ] Aurora build succeeds via BlueBuild
- [ ] Cosmic build succeeds via BlueBuild
- [ ] All tools verified present in image
- [ ] Cosign signing verified

Files to delete after verification:
- `build_files/` (entire directory)
- `Containerfile`
- `.github/workflows/build.yml` (old workflow)

---

## Handoff Notes

### To Test the Build

1. Push this branch to trigger the new workflow
2. Monitor `.github/workflows/build-bluebuild.yml`
3. Verify images at `ghcr.io/veighnsche/tanzanite-aurora:latest` and `ghcr.io/veighnsche/tanzanite-cosmic:latest`

### To Complete Phase 4 (Cleanup)

After successful build verification:
```bash
rm -rf build_files/
rm Containerfile
rm .github/workflows/build.yml
git add -A && git commit -m "chore: Remove old build system after BlueBuild migration"
```

### Known Issues

1. **Q3 (Cosmic compatibility):** Still open - may need testing
2. **IDE lint false positive:** `build-bluebuild.yml` shows lint error but YAML is valid

---

## Handoff Checklist

- [x] Project builds cleanly (YAML validated)
- [x] All new files created
- [x] Team file updated
- [x] Remaining work documented
- [ ] Phase 4 cleanup (blocked on verification)

**TEAM_006 implementation complete.**
