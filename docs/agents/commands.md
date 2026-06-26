# Commands

> Every Flutter / Dart command runs through `fvm`. Local mirrors of CI.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## Setup

```bash
fvm install                          # installs the pinned 3.41.8 SDK
fvm use                              # writes .fvm/
fvm flutter pub get
```

## Run (per flavor)

```bash
fvm flutter run --flavor dev     -t lib/main_dev.dart
fvm flutter run --flavor staging -t lib/main_staging.dart
fvm flutter run --flavor prod    -t lib/main_prod.dart
```

## Build

```bash
# Android
fvm flutter build apk   --flavor dev     -t lib/main_dev.dart
fvm flutter build appbundle --flavor prod -t lib/main_prod.dart

# iOS
fvm flutter build ios --flavor prod -t lib/main_prod.dart --no-codesign
```

## Quality gates (run before opening a PR)

```bash
fvm dart format --set-exit-if-changed .
fvm flutter analyze
fvm flutter test
```

## Localization

```bash
fvm flutter gen-l10n                 # regenerates AppLocalizations from ARB
```

## Tests

```bash
fvm flutter test
fvm flutter test test/path/to/file_test.dart
fvm flutter test --coverage
```

## Env / secrets

- Per-flavor env lives in `env.<flavor>.json` (committed, **non-secret** values).
- `android/key.properties` is gitignored; copy from `key.properties.example`.
- Never commit real keys, tokens, or signing material.

## Branding regeneration

```bash
python3 assets/branding/_generate_placeholders.py
fvm dart run flutter_launcher_icons -f flutter_launcher_icons-dev.yaml
fvm dart run flutter_launcher_icons -f flutter_launcher_icons-prod.yaml
fvm dart run flutter_native_splash  -f flutter_native_splash-dev.yaml
```

## Related

- [ci.md](./ci.md) — what the pipeline runs.
- [flavors.md](./flavors.md) — per-flavor files and entrypoints.
- [git-workflow.md](./git-workflow.md) — pre-PR checklist.
- [../../AGENTS.md](../../AGENTS.md) — index.
