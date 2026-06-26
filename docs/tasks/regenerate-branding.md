# Task: Regenerate branding (icons + splash)

> Goal: regenerate launcher icons and native splash for one or all
> flavors.

## Preconditions

- Source assets updated in `assets/branding/`.
- Per-flavor YAML configs present (`flutter_launcher_icons-<flavor>.yaml`,
  `flutter_native_splash-<flavor>.yaml`).

## Steps

```bash
# Optional: regenerate placeholder assets first
python3 assets/branding/_generate_placeholders.py

# Per-flavor icons
fvm dart run flutter_launcher_icons -f flutter_launcher_icons-dev.yaml
fvm dart run flutter_launcher_icons -f flutter_launcher_icons-staging.yaml
fvm dart run flutter_launcher_icons -f flutter_launcher_icons-prod.yaml

# Per-flavor splash
fvm dart run flutter_native_splash -f flutter_native_splash-dev.yaml
fvm dart run flutter_native_splash -f flutter_native_splash-staging.yaml
fvm dart run flutter_native_splash -f flutter_native_splash-prod.yaml
```

## Verify

- `fvm flutter build apk --flavor dev -t lib/main_dev.dart` builds
  clean (smoke check that resources resolve).

## What you may NOT do

- ❌ Hand-edit files under `android/app/src/main/res/` or
  `ios/Runner/Assets.xcassets/` — these are generated.
- ❌ Share assets across flavors if the brand differs.

## Done criteria

- [ ] All three flavor configs regenerated.
- [ ] Smoke build for at least dev succeeds.

## Related

- [commands.md](../agents/commands.md) — branding section.
- [flavors.md](../agents/flavors.md) — per-flavor files.
