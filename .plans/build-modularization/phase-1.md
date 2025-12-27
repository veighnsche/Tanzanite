# Phase 1: Discovery and Safeguards

## Refactor Summary
Modularize `build_files/build.sh` (328 lines) into separate scripts per functional area to improve maintainability, testability, and reusability.

## Pain Points
- Single 328-line file is harder to navigate
- Can't reuse individual parts (e.g., just install Android SDK)
- Testing individual sections is difficult
- Multiple contributors could cause merge conflicts

## Success Criteria
- Main `build.sh` orchestrates modular scripts
- Each module is self-contained and independently testable
- Build output identical to current behavior
- File sizes < 100 lines per module

## Current Structure (7 Parts)

| Part | Lines | Responsibility |
|------|-------|----------------|
| Header/Helpers | 1-93 | Functions: section, subsection, retry, download_file, download_pipe, is_ublue, is_fedora_atomic |
| Part 1 | 95-121 | Filesystem Setup (/opt, /usr/local fixes) |
| Part 2 | 123-153 | Base Packages (tmux, mosh, windsurf, hostname) |
| Part 3 | 155-197 | Programming Languages (Python/uv, Go, Rust, Node.js, Bun) |
| Part 4 | 199-227 | Dev Tools & AOSP deps (gcc, make, Java, libs) |
| Part 5 | 229-273 | Android Tools (repo, SDK, NDK, scrcpy) |
| Part 6 | 275-300 | Environment Config (profile.d) |
| Part 7 | 302-327 | Container Runtimes (podman) + Summary |

## Target Module Structure

```
build_files/
├── build.sh              # Orchestrator (sources all modules)
├── lib/
│   └── common.sh         # Helper functions (section, retry, download_*)
├── modules/
│   ├── 01-filesystem.sh  # Part 1
│   ├── 02-packages.sh    # Part 2
│   ├── 03-languages.sh   # Part 3
│   ├── 04-devtools.sh    # Part 4
│   ├── 05-android.sh     # Part 5
│   ├── 06-environment.sh # Part 6
│   └── 07-containers.sh  # Part 7
```

## Behavioral Contracts
- Build must produce identical container image
- All error handling (retry, download_file) must work identically
- Section/subsection output format unchanged
- Environment variables (BASE_NAME) propagate to all modules

## Constraints
- Modules must be sourced (not subshells) to share state
- Helper functions must be available to all modules
- Order of execution matters (filesystem before languages)

## Open Questions
None - proceeding with extraction.
