# Task: Add a new locale

> Goal: add a new ARB file, regenerate `AppLocalizations`, and verify
> all keys translate.

## Preconditions

- Locale code decided (e.g. `fr`).
- Source-of-truth ARB is `app_en.arb`. **All** existing keys must be
  translated.

## Steps

1. **Copy**: `cp lib/l10n/app_en.arb lib/l10n/app_<locale>.arb`.
2. **Translate**: change every `"value"` while keeping the keys
   identical. Keep ICU `{placeholder}` syntax intact.
3. **Register**: add to `l10n.yaml` under `arb-dir: lib/l10n`. If not
   fully translated, add to `untranslated-locales` until complete; then
   move to `supportedLocales`.
4. **Regenerate**:
   ```bash
   fvm flutter gen-l10n
   ```
5. **Verify**: the build's golden test (manual) — open the app, switch
   device locale, check every screen.
6. **Tests**: if any screen asserts copy, update the assertions to use
   the new locale too.

## What you may NOT do

- ❌ Add a key to only one ARB file — both/all files must move together.
- ❌ Hard-code a locale code outside `l10n.yaml` and the loader.
- ❌ Concatenate strings — use ICU placeholders.

## Done criteria

- [ ] New ARB file has every key from `app_en.arb`.
- [ ] `fvm flutter gen-l10n` runs clean.
- [ ] App renders correctly in the new locale.

## Related

- [localization.md](../agents/localization.md) — ARB workflow.
- [commands.md](../agents/commands.md) — `flutter gen-l10n`.
