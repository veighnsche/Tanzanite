# TEAM_005: BlueBuild Migration Plan Review

## Team Info
- **Created:** 2025-12-28
- **Purpose:** Review and refine the BlueBuild migration plan (TEAM_004)
- **Status:** Complete

## Review Scope
Reviewing `.plans/bluebuild-migration/` phases 1-5 following the `/review-a-plan` workflow.

## Progress Log
- [2025-12-28] Team registered, beginning plan review
- [2025-12-28] Completed full review of all 5 phases

---

# Review Findings

## Phase 1: Questions and Answers Audit

### Open Questions Status
Phase 1 lists 3 open questions (lines 110-119):

1. **Flutter as root** — No answer documented. Plan mentions "use `--no-analytics` and ignore" in Phase 5 (line 76) but this isn't in a questions file.
2. **Caching strategy** — No answer documented. Plan assumes `use_cache: true` is sufficient.
3. **Multiple recipes** — Implicitly answered by Phase 2: separate recipes per variant.

**Finding:** No `.questions/` files exist for this plan. Open questions should be formalized.

---

## Phase 2: Scope and Complexity Check

### Overengineering Concerns

1. **Excessive UoW splitting in Phase 2** — 6 steps for what is essentially "create directory structure and YAML files". Steps 1-5 could be a single UoW.

2. **Module file separation** — Plan proposes 5 separate module YAML files (`packages.yml`, `languages.yml`, `devtools.yml`, `android.yml`, `environment.yml`). Given the actual content is small, these could be consolidated into 2-3 files or even inline in the recipe.

### Oversimplification Concerns

1. **Missing: Windsurf IDE installation** — `02-packages.sh` installs Windsurf via custom repo (lines 25-36). This is NOT in the Phase 2 package list.

2. **Missing: dnf5 upgrade** — Current build runs `dnf5 upgrade --refresh -y` (02-packages.sh:9). Not mentioned in plan.

3. **Missing: System hostname** — `02-packages.sh:39` sets hostname to "tanzanite". Not in plan.

4. **Missing: systemctl enable podman.socket** — `07-containers.sh:12`. Not in plan.

5. **Missing: scrcpy installation** — `05-android.sh:44-71` installs scrcpy with desktop entry. Not in plan.

6. **Missing: Pre-cached packages** — Current build pre-caches:
   - Python: ruff, black, mypy, pytest, ipython
   - Go: gopls, dlv, golangci-lint, air
   - Rust: rust-analyzer, rustfmt, clippy, cargo-watch, cargo-edit, cargo-expand, sccache
   - Node: typescript, ts-node, eslint, prettier, biome, turbo, nx
   - Dart: devtools, dart_style
   - Gradle: wrapper versions 8.9-8.12
   
   Phase 2 only mentions language runtimes, not these cached tools.

7. **Missing: AOSP build dependencies** — `04-devtools.sh:20-32` installs extensive 32-bit libs for Android development. Not in Phase 2 packages.

8. **Incomplete package list** — Phase 2 packages.yml example (lines 73-110) is incomplete compared to actual modules.

### Verdict
**The plan undersimplifies the extraction work.** Phase 2 package lists are incomplete and will cause regressions if followed literally.

---

## Phase 3: Architecture Alignment

### BlueBuild Module Type Errors

1. **`type: dnf` syntax is incorrect** — Phase 2 shows:
   ```yaml
   type: dnf
   install:
     packages:
       - gcc
   ```
   But BlueBuild dnf module uses:
   ```yaml
   type: dnf
   install:
     packages:
       - gcc
   ```
   This is actually correct, but the plan shows `install: packages:` which matches the new dnf module, not the old rpm-ostree module.

2. **`type: files` doesn't exist** — Phase 2 line 125-132 shows:
   ```yaml
   type: files
   files:
     - source: system
       destination: /
   ```
   BlueBuild doesn't have a `type: files` module. Files are copied by placing them in `files/` directory and they're automatically available at `/tmp/files/` during build. The `copy` module or `containerfile` module with COPY instruction is needed.

3. **Claim: "optfix is now automatic"** — Phase 1 line 91 claims BlueBuild handles `/opt`, `/usr/local` via "optfix (now automatic)". This is **incorrect**. The `optfix` parameter is deprecated and only applies to specific packages that install to `/opt`. BlueBuild does NOT automatically handle `/root`, `/opt`, or `/usr/local` symlink issues.

### Directory Structure Mismatch

Plan proposes `recipes/modules/` but BlueBuild expects module files referenced via `from-file:` to be in the same directory as the recipe or a relative path from it. The standard structure is:
```
recipes/
├── recipe.yml
└── common-packages.yml  # referenced as from-file: common-packages.yml
```
Or in config/ directory.

---

## Phase 4: Global Rules Compliance

| Rule | Status | Notes |
|------|--------|-------|
| Rule 0 (Quality) | ⚠️ | Plan has technical inaccuracies that would cause regressions |
| Rule 1 (SSOT) | ✅ | Plan is in `.plans/bluebuild-migration/` |
| Rule 2 (Team Registration) | ✅ | TEAM_004 file exists |
| Rule 3 (Before Starting) | ⚠️ | No evidence of reading existing team logs |
| Rule 4 (Regression Protection) | ❌ | No baseline outputs defined. Phase 3 has checklist but no automated tests |
| Rule 5 (Breaking Changes) | ✅ | Plan correctly removes old system entirely |
| Rule 6 (No Dead Code) | ✅ | Phase 4 covers cleanup |
| Rule 7 (Modular Refactoring) | ⚠️ | Module splitting may be excessive |
| Rule 8 (Ask Questions) | ❌ | No `.questions/` files created for open questions |
| Rule 9 (Maximize Context) | ✅ | Work is batched into phases |
| Rule 10 (Before Finishing) | ⚠️ | Handoff checklist exists but incomplete |
| Rule 11 (TODO Tracking) | ❌ | No TODO.md entries for open questions |

---

## Phase 5: Verification and References

### Verified Claims
- ✅ BlueBuild has `dnf` module (new, replaces rpm-ostree)
- ✅ BlueBuild has `script` module for custom bash scripts
- ✅ `use_cache: true` exists in GitHub Action
- ✅ BlueBuild supports `from-file:` for modular configs
- ✅ Cosign signing is supported

### Incorrect/Unverified Claims
- ❌ **"optfix is now automatic"** — Deprecated, not automatic
- ❌ **`type: files` module** — Does not exist in BlueBuild
- ❌ **"BlueBuild handles /root, /opt, /usr/local"** — It does not. Filesystem fixes still needed.
- ⚠️ **Cosmic base image** — `quay.io/fedora-ostree-desktops/cosmic-atomic:43` should be verified as BlueBuild-compatible

---

# Critical Issues

## Issue 1: Filesystem Handling Not Addressed

**Severity:** Critical

The current `01-filesystem.sh` handles:
- `/root` symlink → directory conversion
- `/opt` symlink → directory conversion  
- `/usr/local` symlink → directory conversion
- Directory structure creation for caches

The plan claims "Not needed - BlueBuild handles this" but **this is false**. BlueBuild's `optfix` is deprecated and only handles specific package installations, not general filesystem setup.

**Fix:** Add a `type: script` module that runs filesystem fixes FIRST, before any package installation.

## Issue 2: Incomplete Package Extraction

**Severity:** High

Phase 2 package list is missing:
- AOSP 32-bit dependencies (glibc-devel.i686, etc.)
- Java 21 OpenJDK
- Windsurf IDE + repo setup
- automake, autoconf, libtool, flex, bison, patch
- podman-docker, docker-compose

**Fix:** Extract complete package list from all current modules.

## Issue 3: `type: files` Module Doesn't Exist

**Severity:** High

Phase 2 proposes using `type: files` module which doesn't exist in BlueBuild.

**Fix:** Use `type: containerfile` with COPY instruction, or place files in `files/` and use a `type: script` to copy them.

## Issue 4: No Questions File

**Severity:** Medium

Open questions exist but aren't formalized in `.questions/`.

**Fix:** Create `.questions/TEAM_004_bluebuild.md` with the 3 open questions.

---

# Recommended Plan Changes

## Phase 1 Updates
1. Remove claim that BlueBuild handles filesystem fixes automatically
2. Update architecture mapping table to show filesystem.sh IS needed
3. Create `.questions/TEAM_004_bluebuild.md`

## Phase 2 Updates
1. Add complete package extraction from ALL current modules
2. Replace `type: files` with correct approach
3. Add filesystem setup script as first module
4. Include ALL pre-cached tools, not just runtimes
5. Include Windsurf, scrcpy, and other missing components

## Phase 3 Updates
1. Workflow example needs `cosign_private_key` secret name verification
2. Add filesystem verification step

## Phase 4 Updates
1. No changes needed

## Phase 5 Updates
1. Add automated regression test for tool versions
2. Add script to compare installed tools with current image

---

# Summary

**Plan Quality:** Needs Work

The plan has a good structure and correctly identifies the motivation for migration. However:

1. **Technical inaccuracies** about BlueBuild capabilities will cause build failures
2. **Incomplete extraction** will cause tool regressions
3. **Missing questions file** violates Rule 8
4. **No regression protection** violates Rule 4

**Recommendation:** Update Phase 1 and Phase 2 before implementation begins.

---

# Actions Taken

1. Created `.questions/TEAM_004_bluebuild.md` with 3 open questions
2. Fixed Phase 1 architecture mapping table (filesystem.sh IS needed)
3. Fixed Phase 1 constraint about symlink handling
4. Fixed Phase 2 `type: files` → `type: containerfile` with COPY
5. Added `00-filesystem.sh` to script list
6. Added `filesystem.yml` module to recipe (MUST BE FIRST)
7. Added missing scripts: `install-scrcpy.sh`, `install-windsurf.sh`

## Remaining Issues (for TEAM_004 to address)

1. **Package list incomplete** — Need full extraction from all modules
2. **Pre-cached tools not listed** — Python, Go, Rust, Node tools missing
3. **AOSP 32-bit deps missing** — glibc-devel.i686, etc.
4. **No regression tests** — Need automated version checks

---

# Handoff

- [x] Team file updated
- [x] Questions file created
- [x] Critical plan corrections applied
- [x] Review documented

**TEAM_005 review complete.**
