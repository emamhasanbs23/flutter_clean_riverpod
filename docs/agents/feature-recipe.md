# Adding a New Feature

> The exact, ordered recipe for adding a feature end-to-end.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## Step 0 — Plan

Pick a short feature name (singular noun). Confirm:

- Which routes it needs (typed names).
- Which use cases (verbs).
- Which failure modes (network, server, auth, validation, cache).

## Step 1 — Directory tree

```
lib/features/<feature>/
├── data/
│   ├── datasources/
│   │   ├── <feature>_remote_data_source.dart
│   │   └── <feature>_local_data_source.dart      # only if needed
│   ├── models/
│   │   ├── <feature>_dto.dart
│   │   └── <feature>_mapper.dart
│   └── repositories/
│       └── <feature>_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── <feature>.dart
│   ├── repositories/
│   │   └── <feature>_repository.dart
│   └── usecases/
│       └── <verb>_<feature>.dart
└── presentation/
    ├── pages/
    │   └── <feature>_page.dart
    ├── widgets/
    └── controllers/
        └── <feature>_controller.dart

<feature>_providers.dart     # Provider/NotifierProvider exports
```

## Step 2 — Domain entity

`domain/entities/<feature>.dart` — **pure Dart**. No Flutter, no Dio, no Riverpod imports.

## Step 3 — Repository contract

`domain/repositories/<feature>_repository.dart` returns `Future<Either<Failure, T>>`.

## Step 4 — Data layer

- DTOs (`<feature>_dto.dart`) match the wire schema.
- Mappers (`<feature>_mapper.dart`) convert DTO ↔ entity. Use `dynamic` calls only inside mappers — see [analyzer-overrides.md](./analyzer-overrides.md).
- Remote data source talks to Dio via the central `dioClientProvider`.
- Repository impl maps `DioException` → `Failure` and returns `Either`.

## Step 5 — Providers

`<feature>_providers.dart` exposes:

- `repositoryProvider`
- `featureControllerProvider` (or per-use-case providers)

Do **not** import this file from `core/`.

## Step 6 — UI

- Sealed `*State` in the controller.
- Exhaustive `switch` in the page widget.
- `AppSize` constants and theme extensions (see [styling.md](./styling.md)).
- All copy via `context.l10n.*` (see [localization.md](./localization.md)).

## Step 7 — Routes

- Extend the relevant `*Routes` class in `lib/core/router/route_descriptor.dart`.
- Register the `GoRoute` in `app_router.dart`.
- If deep-linkable, add to the whitelist — see [deep-links.md](./deep-links.md).

## Step 8 — Tests

- Repository: success + every Failure subclass (see [testing.md](./testing.md)).
- Mapper: DTO ↔ entity + missing-field edges.
- Controller: every sealed-state transition.
- Widget: smoke test (loading + error + one data state).

## Step 9 — Localization

Add new keys to **both** `app_en.arb` and `app_es.arb`. Run `fvm flutter gen-l10n` (see [localization.md](./localization.md)).

## Done criteria

- [ ] `fvm dart format --set-exit-if-changed .` clean.
- [ ] `fvm flutter analyze` clean.
- [ ] `fvm flutter test` clean.
- [ ] All copy localized in en + es.

## Related

- [architecture.md](./architecture.md) — the layering this recipe respects.
- [layering-rules.md](./layering-rules.md) — what each layer may import.
- [../../AGENTS.md](../../AGENTS.md) — index.
