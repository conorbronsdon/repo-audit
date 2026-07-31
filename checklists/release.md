# Release

The repo ships versioned artifacts — tags, packages, binaries, container images.

- [ ] Version is set in one place, and everything else derives from it
- [ ] `CHANGELOG.md` has an entry for the version being shipped, naming behavior not commits
- [ ] Tag matches the changelog heading and the version in the manifest
- [ ] Build is reproducible from a clean checkout — verify in a fresh clone, not your working tree
- [ ] Release artifacts carry checksums, and the checksum file names every artifact exactly once
- [ ] Install path documented in the README matches the artifacts actually published for each platform
- [ ] Installer scripts, if any, are shipped inside the release archive as well as served from the default branch — otherwise a pinned version cannot reproduce its own installer
- [ ] Every install path is tested, not just the one you use
- [ ] Someone other than the author can follow the release runbook
