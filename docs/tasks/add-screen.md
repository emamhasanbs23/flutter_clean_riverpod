# Task: Add a new screen to an existing feature

> Goal: add one page + controller + route without breaking layering.

## Preconditions

- Target feature exists in `lib/features/<feature>/` with `domain/`, `data/`,
  and `presentation/` slices (or `presentation/` only for UI-only features like `splash`).
- Route name decided (typed constant in the feature's `*Routes` class).

## Steps

1. **Page file**: `lib/features/<feature>/presentation/<screen>_page.dart` at the feature
   presentation root (or a screen subfolder, e.g. `presentation/todo_list/`). Decompose UI into
   `<Feature><Section>Widget` classes under `widgets/`; exhaustive `switch` on the controller state. See
   [split-presentation-widgets.md](./split-presentation-widgets.md) and
   [styling.md](../agents/styling.md).
2. **Controller**: in `lib/features/<feature>/presentation/riverpod/<feature>_providers.dart`
   as a `@riverpod` Notifier with sealed `*State`.
3. **Provider**: in `lib/features/<feature>/presentation/riverpod/<feature>_providers.dart`.
4. **Route**: extend the relevant `*Routes` class with the typed constant;
   register in `app_router.dart`. See [navigation.md](../agents/navigation.md).
5. **Localization**: add copy to `app_en.arb` + `app_es.arb`. See
   [localization.md](../agents/localization.md).
6. **Tests** under `test/features/<feature>/presentation/`:
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
