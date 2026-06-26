# Task: Add a new feature

> Goal: add a self-contained feature end-to-end, in one PR.
> Deep dives: [architecture.md](../agents/architecture.md),
> [layering-rules.md](../agents/layering-rules.md),
> [feature-recipe.md](../agents/feature-recipe.md).

## Goal

Create `lib/features/<feature>/` with domain, data, presentation, and tests,
wired into Riverpod and the router.

## Preconditions

- Feature name confirmed (singular noun).
- Routes decided (typed names).
- Failure modes listed.

## Steps (in order)

1. **Create directory tree** under `lib/features/<feature>/` — see
   [feature-recipe.md](../agents/feature-recipe.md) § Step 1.
2. **Domain entity** in `domain/entities/<feature>.dart` — pure Dart.
3. **Repository contract** in `domain/repositories/<feature>_repository.dart`
   returning `Future<Either<Failure, T>>`.
4. **Data layer** — DTOs, mapper, remote (and local) data source, repository
   impl. See [error-handling.md](../agents/error-handling.md).
5. **Providers** in `<feature>_providers.dart` — expose repository +
   controller. See [state-management.md](../agents/state-management.md).
6. **UI** — sealed `*State` + exhaustive `switch`. See
   [styling.md](../agents/styling.md).
7. **Routes** — add typed constant, register in `app_router.dart`. See
   [navigation.md](../agents/navigation.md).
8. **Tests** — repository + mapper + controller + widget smoke. See
   [testing.md](../agents/testing.md).
9. **Localization** — add keys to `app_en.arb` and `app_es.arb`. See
   [localization.md](../agents/localization.md).

## Done criteria

- [ ] `fvm dart format --set-exit-if-changed .` clean
- [ ] `fvm flutter analyze` clean
- [ ] `fvm flutter test` clean
- [ ] All copy localized in en + es
- [ ] PR references the design doc / issue

## Related

- [feature-recipe.md](../agents/feature-recipe.md) — full recipe.
- [architecture.md](../agents/architecture.md) — layering diagram.
