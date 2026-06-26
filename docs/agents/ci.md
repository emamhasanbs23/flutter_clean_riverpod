# CI

> Tag-triggered pipeline: format, analyze, unit tests, Android dev smoke.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## Trigger

`.github/workflows/ci.yml` runs **only on tag pushes matching `release*`**. PRs do **not** trigger CI — local pre-PR gates are authoritative.

## Pipeline

```yaml
jobs:
  quality:
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: 3.41.8
      - run: fvm flutter pub get
      - run: fvm dart format --set-exit-if-changed .
      - run: fvm flutter analyze
      - run: fvm flutter test
  android-smoke:
    needs: quality
    steps:
      - run: fvm flutter build apk --flavor dev -t lib/main_dev.dart
```

## What's NOT in CI

- iOS build (slower, requires macOS runner with signing).
- Web build (out of scope for the boilerplate).
- Localization regen (run locally; the ARB diff is the source of truth).

## Local mirror

Run the same gates locally before pushing a tag:

```bash
fvm dart format --set-exit-if-changed .
fvm flutter analyze
fvm flutter test
```

## Related

- [commands.md](./commands.md) — the exact local commands.
- [git-workflow.md](./git-workflow.md) — tag-push release flow.
- [../../AGENTS.md](../../AGENTS.md) — index.
