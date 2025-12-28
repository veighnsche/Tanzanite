# Phase 5: Hardening and Handoff

**Team:** TEAM_004  
**Status:** Pending  
**Depends on:** Phase 4 complete

---

## Final Verification

### Build Verification

- [ ] Aurora builds on schedule (daily cron)
- [ ] PR builds work (no push to registry)
- [ ] Manual workflow_dispatch works
- [ ] Build caching reduces subsequent build times

### Runtime Verification

Test on actual hardware after rebasing:

- [ ] System boots correctly
- [ ] All dev tools accessible
- [ ] Flutter apps can be built
- [ ] Android development works
- [ ] Containers (podman) work
- [ ] No permission issues

### Security Verification

- [ ] Images signed with cosign
- [ ] Signatures verifiable
- [ ] No secrets in image layers

---

## Documentation Updates

### README.md

Update to reflect:
- BlueBuild-based build system
- How to customize the image
- How to add packages
- How to run local builds

### docs/LOCAL_BUILD.md

Update for BlueBuild:
```bash
# Install BlueBuild CLI
cargo install blue-build

# Build locally
bluebuild build recipes/recipe-aurora.yml

# Or generate Containerfile and build with podman
bluebuild generate recipes/recipe-aurora.yml
podman build -f Containerfile .
```

---

## Handoff Notes

### For Future Maintainers

1. **Adding packages:** Edit `recipes/modules/packages.yml`
2. **Adding custom scripts:** Add to `files/scripts/` and reference in `recipes/modules/languages.yml`
3. **Changing base image:** Edit `base-image` in recipe files
4. **Adding environment variables:** Edit `files/system/etc/profile.d/tanzanite-dev.sh`

### Known Limitations

1. **Flutter root warning:** Flutter warns about running as root during build. This is expected and harmless.
2. **Build time:** Full builds take 30-60 minutes. Use `use_cache: true` for faster subsequent builds.
3. **Cross-architecture:** Currently x86_64 only. ARM64 would require separate base images.

### BlueBuild Resources

- Documentation: https://blue-build.org/
- Recipe reference: https://blue-build.org/reference/recipe/
- Module reference: https://blue-build.org/reference/module/
- Community: https://blue-build.org/community

---

## Completion Checklist

- [ ] All phases complete
- [ ] All tests pass
- [ ] Documentation updated
- [ ] Team file marked complete
- [ ] Handoff notes written
- [ ] No TODOs remaining

---

## Team Sign-off

**TEAM_004** migration complete.

All work from **TEAM_002** and **TEAM_003** has been incorporated into the BlueBuild structure.
