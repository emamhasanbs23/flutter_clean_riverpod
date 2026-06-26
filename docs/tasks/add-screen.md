# Task: Add a new screen to an existing feature

> Goal: add one page + controller + route without breaking layering.

## Preconditions

- Target feature exists in `lib/features/<feature>/`.
- Route name decided (typed constant in the feature's `*Routes` class).

## Steps

1. **Page file**: `lib/features/<feature>/presentation/pages/<screen>_page.dart`.
   Small private `Widget` classes, exhaustive `switch` on the controller
   state. See [styling.md](../agents/styling.md).
2. **Controller**: `presentation/controllers/<screen>_controller.dart`
   extending `Notifier<*State>`. Sealed `*State`.
3. **Provider**: in `<feature>_providers.dart`.
   ```dart
   final screenControllerProvider =
       NotifierProvider.autoDispose<ScreenController, ScreenState>(
           ScreenController.new);
   ```
4. **Route**: extend the relevant `*Routes` class with the typed constant;
   register in `app_router.dart`. See [navigation.md](../agents/navigation.md).
5. **Localization**: add copy to `app_en.arb` + `app_es.arb`. See
   [localization.md](../agents/localization.md).
6. **Tests**:
   - Controller: one test per sealed-state transition.
   - Widget: smoke (loading + error + one data state). See
     [testing.md](../agents/testing.md).

## Done criteria

- [ ] Layering holds (no `data/` import from `presentation/`).
- [ ] Sealed state exhaustive `switch` (analyzer-enforced).
- [ ] No inline `16`/`8`/`Colors.x` — uses `AppSize` and theme.
- [ ] Route uses typed name; no raw path string.

## Related

- [navigation.md](../agents/navigation.md) — typed route names.
- [state-management.md](../agents/state-management.md) — Notifier patterns.
- [styling.md](../agents/styling.md) — `AppSize` + theme.
