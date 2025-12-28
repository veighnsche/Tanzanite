# Open Questions: BlueBuild Migration

**Plan:** `.plans/bluebuild-migration/`  
**Team:** TEAM_004  
**Created:** 2025-12-28  
**Reviewer:** TEAM_005

---

## Q1: Flutter Root Warning

**Question:** Flutter warns against running as root. How should we handle this during container builds?

**Options:**
- A) Use `--no-analytics` and ignore the warning
- B) Skip Flutter precache entirely, let users do it on first run
- C) Use a non-root user during build (complex)

**Status:** Open

**Impact:** Affects `files/scripts/install-flutter.sh` implementation

---

## Q2: Caching Strategy

**Question:** Is BlueBuild's `use_cache: true` sufficient for our caching needs, or do we need additional layer caching strategy?

**Context:** Current build pre-caches:
- Go modules and tools (~200MB)
- Rust crates and tools (~500MB)  
- Node.js global packages (~100MB)
- Gradle wrapper distributions (~400MB)
- Flutter SDK and pub cache (~1GB)

**Status:** Open

**Impact:** Affects build times and image layer structure

---

## Q3: Base Image Compatibility

**Question:** ~~Is `quay.io/fedora-ostree-desktops/cosmic-atomic:43` (Cosmic variant) officially supported by BlueBuild?~~

**Status:** Resolved (N/A)

**Resolution:** Cosmic support has been removed from Tanzanite. Only Aurora (uBlue) base is supported.
