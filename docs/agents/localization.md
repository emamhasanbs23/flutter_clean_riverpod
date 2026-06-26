# Localization (ARB)

> ARB-based i18n with `AppLocalizations`, accessed via `context.l10n.*`.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## Where the strings live

```
lib/l10n/
├── app_en.arb      # source of truth
└── app_es.arb      # Spanish (and any other locale added)
```

`l10n.yaml` declares the contract (`arb-dir`, `template-arb-file`, `output-class`).

## Generating code

```bash
fvm flutter gen-l10n
```

This regenerates `AppLocalizations` and the per-locale accessors under `lib/l10n/` (or `.dart_tool/` — see `l10n.yaml`).

## Using it in widgets

```dart
Text(context.l10n.loginButtonLabel)
```

The `context.l10n` extension lives in `lib/core/l10n/l10n_extension.dart`. Do **not** import `package:flutter_gen/gen_l10n/app_localizations.dart` directly — go through the extension.

## Rules

- All user-visible strings are localized. **No** hard-coded English in widgets.
- When adding a key, add it to **both** `app_en.arb` and `app_es.arb`.
- Use `{placeholder}` syntax for interpolated values; never build strings via concatenation.
- Placeholders must declare a `type` (and `example`) in the ARB metadata.

## Adding a new locale

1. Drop `lib/l10n/app_<locale>.arb` next to the others.
2. Add the locale to `l10n.yaml` `untranslated-locales` (initially) or `supportedLocales` (when complete).
3. Run `fvm flutter gen-l10n`.

## Related

- [styling.md](./styling.md) — typography pairs with copy.
- [commands.md](./commands.md) — `flutter gen-l10n` invocation.
- [../../AGENTS.md](../../AGENTS.md) — index.
