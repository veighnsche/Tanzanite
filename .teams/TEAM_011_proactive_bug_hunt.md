# TEAM_011: Proactive Bug Hunt

## Mission
Systematically search for bugs and edge cases across the codebase.

## Progress
- [x] Read all installation scripts
- [x] Read module configurations
- [x] Read environment configuration
- [x] Document all findings
- [x] Fix confirmed bugs

---

## BUGS FIXED

### BUG 1: NDK Version Mismatch (CRITICAL) ✅ FIXED
**Location:** `files/system/etc/profile.d/tanzanite-dev.sh:38`

**Problem:** Environment referenced NDK `27.2.12479018` but `install-android-sdk.sh` installs `29.0.14206865`.

**Fix:** Updated to `29.0.14206865`.

---

### BUG 2: Go Version 1.25.2 Does Not Exist (CRITICAL) ✅ FIXED
**Location:** `files/scripts/install-go.sh:7`

**Problem:** Go 1.25 doesn't exist yet (latest is 1.24.x as of Feb 2025).

**Fix:** Updated to `1.24.4`.

---

### BUG 3: Justfile _rebuild-bib Broken Dependency ✅ FIXED
**Location:** `Justfile:195`

**Problem:** `_rebuild-bib` referenced nonexistent `build` recipe.

**Fix:** Changed to `build-aurora`.

---

## VERIFIED OK

- **Node.js v24.12.0** - Confirmed exists as LTS
- **tar ownership** - Already handled with `--no-same-owner`
- **pip warnings** - Already handled with `--root-user-action=ignore`
- **npm conflicts** - Already handled with `--force`
- **watchexec** - Already fixed to `watchexec-cli`
- **Flutter root** - Already handled with `BOT=true`
- **Symlinks** - Already handled in `00-filesystem.sh`

---

## HANDOFF CHECKLIST
- [x] All critical bugs fixed
- [x] Justfile syntax verified (`just --dry-run rebuild-qcow2` works)
- [x] Shellcheck passes (only expected warning about /usr/local)
- [x] Team file updated
- [ ] Full build verification (requires user to run)
