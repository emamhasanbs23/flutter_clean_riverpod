# Task: Cut a release tag

> Goal: produce a tag-push that triggers CI's release pipeline.

## Preconditions

- All PRs intended for the release are merged to `main`.
- `main` is green locally (format, analyze, test).
- Version bump agreed (SemVer).

## Steps

1. **Pre-flight**:
   ```bash
   git checkout main && git pull
   fvm dart format --set-exit-if-changed .
   fvm flutter analyze
   fvm flutter test
   ```
2. **Bump**: update `pubspec.yaml` `version:` (`MAJOR.MINOR.PATCH+BUILD`).
3. **Commit**:
   ```bash
   git commit -am "chore(release): v1.2.3"
   ```
4. **Tag** (must start with `release` — CI only triggers on this prefix):
   ```bash
   git tag release/v1.2.3
   git push origin main --tags
   ```
5. **Watch CI**: confirm `.github/workflows/ci.yml` jobs `quality` and
   `android-smoke` pass.

## What you may NOT do

- ❌ Tag without bumping `pubspec.yaml`.
- ❌ Use a tag prefix other than `release*` — CI won't trigger.
- ❌ Push the tag before local gates are green.

## Rollback

CI artifacts are immutable once the tag exists. To revert: cut a new
patch tag with the revert, don't force-push the existing tag.

## Done criteria

- [ ] `pubspec.yaml` version bumped.
- [ ] Tag format `release/vX.Y.Z` (or `release-…`).
- [ ] CI pipeline green.

## Related

- [ci.md](../agents/ci.md) — what the release pipeline runs.
- [git-workflow.md](../agents/git-workflow.md) — release flow.
- [commands.md](../agents/commands.md) — local mirror commands.
