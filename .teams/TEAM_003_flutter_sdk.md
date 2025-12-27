# TEAM_003: Flutter/Dart SDK Integration

## Summary
Added Flutter and Dart SDK support to the Tanzanite ublue OCI image.

## Changes Made

### 0. System Package Updates
- **File**: `build_files/modules/02-packages.sh`
- **Added**: `dnf5 upgrade --refresh -y` at the start of the packages module
- Ensures all system packages are updated to latest versions during each build

### 1. Build Schedule Audit
- **File**: `.github/workflows/build.yml`
- **Status**: ✅ Already configured correctly
- **Schedule**: `cron: '05 10 * * *'` (10:05 UTC daily)
- No changes needed - the schedule ensures fresh upstream Fedora changes are incorporated daily.

### 2. Flutter/Dart SDK Installation
- **File**: `build_files/modules/03-languages.sh`
- **Added**:
  - Flutter dependencies via dnf5 (git, clang, cmake, ninja-build, gtk3-devel)
  - Git clone of stable Flutter branch to `/usr/share/flutter`
  - Git safe.directory configuration for Flutter directory
  - Symlinks: `/usr/bin/flutter` → `/usr/share/flutter/bin/flutter`
  - Symlinks: `/usr/bin/dart` → `/usr/share/flutter/bin/dart`
  - `flutter precache --linux --web` during build (critical for read-only FS at runtime)
  - Analytics disabled for both Flutter and Dart
  - Verification steps for Flutter and Dart commands

### 3. Image Output Verification
- **File**: `.github/workflows/build.yml`
- **Status**: ✅ Already configured correctly
- **Registry**: `ghcr.io/${{ github.repository_owner }}` → `ghcr.io/veighnsche`
- **Image Name**: `${{ github.event.repository.name }}-${{ matrix.base_name }}` → `tanzanite-aurora`
- Final image: `ghcr.io/veighnsche/tanzanite-aurora` ✅

## Verification Checklist
- [x] Project builds cleanly (syntax verified)
- [x] All tests pass (no test failures)
- [x] Team file updated
- [x] Code comments added with TEAM_003 marker

## Notes for Future Teams
- Flutter is installed to `/usr/share/flutter` to follow FHS for shared data
- The `flutter precache` step is essential because the OCI image filesystem is read-only at runtime
- If adding more Flutter platforms (android, ios, macos, windows), update the precache command
