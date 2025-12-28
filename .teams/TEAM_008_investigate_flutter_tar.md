# TEAM_008: Flutter Gradle Wrapper Tar Ownership Bug

**Created:** 2025-12-28
**Status:** Investigating
**Bug:** Flutter `precache --android` fails with tar ownership errors

---

## Symptom Description

### Expected Behavior
`flutter precache --android --linux --web` should download and extract Gradle wrapper without errors.

### Actual Behavior
```
/usr/sbin/tar: gradle/wrapper/gradle-wrapper.properties: Cannot change ownership to uid 397546, gid 5000: Invalid argument
/usr/sbin/tar: Exiting with failure status due to previous errors
```

### Delta
Tar is trying to preserve ownership from the archive (uid 397546, gid 5000 - Google's internal IDs) which don't exist in the container.

---

## Attempted Fixes (Failed)

### Attempt 1: TAR_OPTIONS environment variable
```bash
export TAR_OPTIONS="--no-same-owner"
```
**Result:** Failed. Flutter calls tar with absolute path, bypasses env var.

### Attempt 2: Replace /usr/sbin/tar with wrapper
```bash
cp /usr/sbin/tar /usr/sbin/tar.real
cat > /usr/sbin/tar << 'EOF'
#!/bin/bash
exec /usr/sbin/tar.real --no-same-owner "$@"
EOF
```
**Result:** Failed. Still seeing the same error.

---

## Hypotheses

### H1: Build cache - old script layer is cached
**Confidence:** High
**Evidence needed:** Check if BlueBuild is using cached layer with old script
**Test:** Force rebuild without cache

### H2: BlueBuild copies scripts to different location
**Confidence:** Medium
**Evidence needed:** Check where BlueBuild puts scripts and when they run
**Test:** Read BlueBuild documentation and build output

### H3: Script runs but tar replacement happens AFTER flutter precache
**Confidence:** Low
**Evidence needed:** Check script execution order in build output

### H4: Flutter uses a different tar binary (not /usr/sbin/tar)
**Confidence:** Low
**Evidence needed:** The error clearly shows /usr/sbin/tar

---

## Investigation Log

### Finding: Wrong Build System
The error output shows:
```
STEP "RUN ... /ctx/build.sh"
```

This proves the build is using the **OLD build system** (`build_files/build.sh`), NOT BlueBuild.

My previous fixes were applied to `files/scripts/install-flutter.sh` (BlueBuild), but the actual build uses `build_files/modules/03-languages.sh`.

### Root Cause
**H1 CONFIRMED** (partially) - Not cache, but wrong file. The tar wrapper fix was applied to the wrong script.

### Fix Applied
Added tar wrapper to `build_files/modules/03-languages.sh` before `flutter precache` call.

---

## Status: RESOLVED

### Final Fix Applied

**Both build systems now have robust tar wrapper:**

1. `build_files/modules/03-languages.sh` - OLD build system ✅
2. `files/scripts/install-flutter.sh` - BlueBuild system ✅

**Fix details:**
- Wraps BOTH `/usr/sbin/tar` AND `/usr/bin/tar`
- Checks if tar exists before wrapping
- Checks if already wrapped to avoid double-wrapping
- Properly restores both binaries after flutter precache
- Uses `${0}.real` pattern so wrapper finds the correct .real file

### Handoff Checklist
- [x] Root cause identified
- [x] Fix applied to OLD build system
- [x] Fix applied to BlueBuild system
- [x] Fix is robust (handles both tar paths)
- [x] Team file updated

