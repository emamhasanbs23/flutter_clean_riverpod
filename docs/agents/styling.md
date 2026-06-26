# Styling & Theming

> Material 3 `ColorScheme` from a single seed, plus `AppSize` constants and `ThemeExtension`s.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## ColorScheme from seed

A single seed color drives the whole Material 3 palette via `ColorScheme.fromSeed(seedColor: ...)`. No hand-picked primary/secondary pairs.

## AppSize constants

All spacing, radius, and component dimensions come from `lib/core/constants/app_size.dart`. Widgets reference constants — never inline literals:

```dart
// ✅
padding: const EdgeInsets.all(AppSize.paddingM),
borderRadius: BorderRadius.circular(AppSize.radiusS),

// ❌
padding: const EdgeInsets.all(16),
borderRadius: BorderRadius.circular(8),
```

For one-offs in a single widget, use a **named local** at the top of `build()` — still no inline literals.

## ThemeExtensions

Two extensions live in `lib/core/theme/`:

- `AppSemanticColors` — semantic colors that aren't in `ColorScheme` (success, warning, info).
- `AppCustomTextStyles` — display/heading/body text styles tuned for the brand.

Access via `Theme.of(context).extension<AppSemanticColors>()` or the convenience extension on `BuildContext`.

## Localization + styling together

User-facing copy is **always** localized via `context.l10n.*`. Styling decisions (font sizes, paddings) follow the constants above — never inline.

## What you may NOT do

- No inline `16`, `8`, `0xFF...` in widgets.
- No `Colors.blue`, `Colors.red`, etc. in production code — go through `ColorScheme` or `AppSemanticColors`.
- No overriding `TextStyle` per-widget unless there's a named constant for it.

## Related

- [localization.md](./localization.md) — `context.l10n` is the i18n companion to theming.
- [../../AGENTS.md](../../AGENTS.md) — index.
