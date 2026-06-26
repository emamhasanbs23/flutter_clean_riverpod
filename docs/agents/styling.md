# Styling & Theming

> Material 3 `ColorScheme` from a single seed, plus `AppSize` constants and `ThemeExtension`s.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## ColorScheme from seed

A single seed color drives the whole Material 3 palette via `ColorScheme.fromSeed(seedColor: ...)`. No hand-picked primary/secondary pairs.

## AppSize constants

All spacing, radius, and component dimensions come from `lib/core/theme/app_size.dart`. Widgets reference constants — never inline literals:

```dart
// ✅
padding: const EdgeInsets.all(AppSize.spaceLg),
borderRadius: BorderRadius.circular(AppSize.radiusMd),

// ❌
padding: const EdgeInsets.all(16),
borderRadius: BorderRadius.circular(8),
```

For one-offs in a single widget, use a **named local** at the top of `build()` — still no inline literals.

## ThemeExtensions

Two extensions live in `lib/core/theme/app_theme.dart`:

- `AppSemanticColors` — semantic colors that aren't in `ColorScheme` (success, warning, danger, info).
- `AppCustomTextStyles` — button, link, and strike-through text styles tuned for the brand.

Both register `*.fallback(...)` factories so widgets stay safe when a bare `ThemeData()` is used in tests.

## BuildContext convenience extension

Import `lib/core/theme/theme_context_extension.dart` for namespaced theme access (mirrors the `context.l10n` pattern):

```dart
context.colors.primary          // ColorScheme role
context.semantic.danger         // AppSemanticColors (non-null)
context.textStyles.button       // AppCustomTextStyles (non-null)
context.textTheme.bodySmall     // Material TextTheme
if (context.isDarkMode) { ... }
```

Each getter subscribes to theme changes the same way `Theme.of(context)` does.

## Theme mode toggle

User-controlled light/dark/system preference is held in `themeModeControllerProvider` (`lib/core/theme/theme_mode_controller.dart`) and wired into `MaterialApp.themeMode` in `lib/app.dart`. In-memory only for now — persistence is a follow-up.

## Localization + styling together

User-facing copy is **always** localized via `context.l10n.*`. Styling decisions (font sizes, paddings) follow the constants above — never inline.

## What you may NOT do

- No inline `16`, `8`, `0xFF...` in widgets.
- No `Colors.blue`, `Colors.red`, etc. in production code — go through `ColorScheme` or `AppSemanticColors`.
- No overriding `TextStyle` per-widget unless there's a named constant for it.
- No raw `Theme.of(context).extension<...>()` in widgets — use `context.semantic` / `context.textStyles`.

## Related

- [localization.md](./localization.md) — `context.l10n` is the i18n companion to theming.
- [../../AGENTS.md](../../AGENTS.md) — index.
