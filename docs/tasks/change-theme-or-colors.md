# Task: Change app colors / typography

> Goal: update visual tokens without breaking the styling contract.

## Preconditions

- Decision made about *which* surface changes (seed color, semantic
  color, text style, spacing scale).

## Steps

1. **Seed color** (whole palette): edit the single seed in
   `lib/core/theme/app_theme.dart`. Material 3 regenerates light + dark.
2. **Semantic colors** (success/warning/info/etc.): edit
   `AppSemanticColors` (a `ThemeExtension`) in
   `lib/core/theme/app_theme.dart`. Implement `copyWith` + `lerp`.
3. **Typography**: edit `AppCustomTextStyles` extension or the
   `TextTheme` block in `app_theme.dart`.
4. **Spacing / sizing**: edit `AppSize` in `lib/core/constants/app_size.dart`.
   Don't add one-off constants in widgets — see [styling.md](../agents/styling.md).
5. **Verify**: open all three flavors; spot-check dark mode + dynamic
   text scaling.

## What you may NOT do

- ❌ Hard-code `Colors.x` in widgets.
- ❌ Inline `EdgeInsets.all(N)` — use `AppSize`.
- ❌ Override the `TextStyle` of individual widgets without going
  through the textTheme.

## Done criteria

- [ ] All changes go through theme files or `AppSize`.
- [ ] No widget references raw color/size literals.
- [ ] Light + dark + dynamic scaling checked.

## Related

- [styling.md](../agents/styling.md) — `AppSize` + theme extensions.
- [localization.md](../agents/localization.md) — copy pairs with style.
