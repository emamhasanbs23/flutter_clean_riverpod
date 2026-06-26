# Task: Run the pre-PR quality gates locally

> Goal: catch what CI would catch before opening a PR.

## Command sequence

```bash
fvm dart format --set-exit-if-changed .
fvm flutter analyze
fvm flutter test
```

All three must exit 0.

## What each catches

| Gate                | Catches                                                       |
|---------------------|---------------------------------------------------------------|
| `dart format`       | Unformatted code (CI fails the PR).                           |
| `flutter analyze`   | Lint violations, dead code, sealed-switch exhaustiveness.     |
| `flutter test`      | Regressions in domain, mapper, controller, widget smoke.      |

## Optional sanity check

```bash
fvm flutter build apk --flavor dev -t lib/main_dev.dart
```

Only needed if the change touches Android Gradle, native plugins, or
asset wiring.

## Common fixes

- Analyzer flags a missing sealed-state switch arm → add the arm.
- Analyzer flags a public API without docs → not an error here
  (`public_member_api_docs` is intentionally off); see
  [analyzer-overrides.md](../agents/analyzer-overrides.md).
- Test fails on `Left` assertion → confirm the repo's expected
  `Failure` subclass in [error-handling.md](../agents/error-handling.md).

## Done criteria

- [ ] All three commands exit 0.
- [ ] (Optional) Android smoke build green.

## Related

- [git-workflow.md](../agents/git-workflow.md) — pre-PR checklist.
- [commands.md](../agents/commands.md) — exact CLI invocations.
- [ci.md](../agents/ci.md) — what the pipeline runs.
