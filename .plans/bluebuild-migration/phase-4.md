# Phase 4: Cleanup

**Team:** TEAM_004  
**Status:** Pending  
**Depends on:** Phase 3 complete (verified builds working)

---

## Dead Code Removal

Once BlueBuild migration is verified, remove old build system:

### Files to Delete

```
build_files/                    # Entire directory
├── build.sh
├── lib/
│   └── common.sh
└── modules/
    ├── 01-filesystem.sh
    ├── 02-packages.sh
    ├── 03-languages.sh
    ├── 04-devtools.sh
    ├── 05-android.sh
    ├── 06-environment.sh
    └── 07-containers.sh

Containerfile                   # Old hand-rolled Containerfile
```

### Files to Keep

```
recipes/                        # BlueBuild recipes
files/                          # BlueBuild files (scripts, system)
.github/workflows/build.yml     # New BlueBuild workflow
docs/LOCAL_BUILD.md             # Update for BlueBuild local builds
```

---

## Steps

### Step 1: Archive Old Build System (Optional)

If you want to preserve history:
```bash
git tag pre-bluebuild-migration
```

### Step 2: Remove Old Files

```bash
rm -rf build_files/
rm Containerfile
```

### Step 3: Update Documentation

Update `README.md` and `docs/LOCAL_BUILD.md`:
- Document BlueBuild structure
- Update local build instructions
- Remove references to old build system

### Step 4: Clean Up Team Files

Update team files to reflect completion:
- Mark TEAM_003 work as superseded
- Update TEAM_004 status to complete

---

## Exit Criteria

- Old build system removed
- No dead code in repository
- Documentation updated
- Team files updated
