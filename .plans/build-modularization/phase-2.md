# Phase 2: Structural Extraction

## Objective
Extract each part into its own module file while keeping the main build.sh working.

## Step 1: Create lib/common.sh
Extract helper functions:
- `section()`
- `subsection()`
- `retry()`
- `download_file()`
- `download_pipe()`
- `is_ublue()`
- `is_fedora_atomic()`

## Step 2: Create module files
Each module:
- Starts with a guard: `[[ -n "$TANZANITE_BUILD" ]] || { echo "Must be sourced from build.sh"; exit 1; }`
- Contains exactly one "Part" from current build.sh
- Uses functions from common.sh

### Module mapping:
| File | Content |
|------|---------|
| `01-filesystem.sh` | Lines 95-121 (Part 1) |
| `02-packages.sh` | Lines 123-153 (Part 2) |
| `03-languages.sh` | Lines 155-197 (Part 3) |
| `04-devtools.sh` | Lines 199-227 (Part 4) |
| `05-android.sh` | Lines 229-273 (Part 5) |
| `06-environment.sh` | Lines 275-300 (Part 6) |
| `07-containers.sh` | Lines 302-327 (Part 7) |

## Step 3: Update main build.sh
- Set `TANZANITE_BUILD=1`
- Source `lib/common.sh`
- Source each module in order
- Print final summary

## Exit Criteria
- All files created
- Build succeeds in container
- Output matches previous behavior
