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
lib/domain/<feature>/
├── entities/
│   └── <feature>.dart
├── repositories/
│   └── <feature>_repository.dart
└── usecases/
    └── <verb>_<feature>_use_case.dart

lib/data/<feature>/
├── api/
│   └── <feature>_api.dart
├── remote/
│   └── <feature>_remote_source.dart          # Retrofit + guard
├── data_source/
│   ├── <feature>_data_source.dart            # aggregate contract (repo depends on this)
│   └── <feature>_data_source_impl.dart       # facade; holds _remoteSource
├── mock/                                     # only if needed
│   └── <feature>_mock_source.dart
├── local/                                    # only if needed
│   └── <feature>_local_source.dart
├── mapper/
│   └── <feature>_mapper.dart
├── model/
│   └── <feature>_dto.dart
└── repository_impl/
    └── <feature>_repository_impl.dart

lib/presentation/<feature>/
├── riverpod/
│   └── <feature>_providers.dart
├── <feature>_page.dart              # entry widget at feature root
└── widgets/
    ├── <section>_widget.dart        # one public widget class per file
    └── dialogs/                     # optional
        └── <name>_dialog.dart
```

## Step 2 — Domain entity

`lib/domain/<feature>/entities/<feature>.dart` — **pure Dart**. No Flutter, no Dio, no Riverpod imports.

## Step 3 — Repository contract

`lib/domain/<feature>/repositories/<feature>_repository.dart` returns `Future<Either<Failure, T>>`.

## Step 4 — Data layer

- DTOs (`lib/data/<feature>/model/<feature>_dto.dart`) match the wire schema.
- Mappers (`lib/data/<feature>/mapper/<feature>_mapper.dart`) convert DTO ↔ entity. Use `dynamic` calls only inside mappers — see [analyzer-overrides.md](./analyzer-overrides.md).
- Remote data source talks to Dio via the central `dioClientProvider` —
  lives in `remote/<feature>_remote_source.dart` and is injected into
  `<feature>_data_source_impl.dart`.
- Repository impl depends on `<Feature>DataSource` (aggregate), maps
  `DioException` → `Failure` and returns `Either`.

## Step 5 — Providers

`lib/presentation/<feature>/riverpod/<feature>_providers.dart` exposes:

- `repositoryProvider`
- `featureControllerProvider` (or per-use-case providers)

Do **not** import this file from `core/`.

## Step 6 — UI

- Page at `lib/presentation/<feature>/<feature>_page.dart`; decompose UI into
  `<Feature><Section>Widget` classes under `widgets/` (see
  [split-presentation-widgets.md](../tasks/split-presentation-widgets.md)).
- Sealed `*State` in the controller.
- Exhaustive `switch` in the page widget.
- `AppSize` constants and theme extensions (see [styling.md](./styling.md)).
- All copy via `context.l10n.*` (see [localization.md](./localization.md)).

## Step 7 — Routes

- Extend the relevant `*Routes` class in `lib/core/router/app_router.dart`.
- Register the `GoRoute` in `app_router.dart`.
- If deep-linkable, add to the whitelist — see [deep-links.md](./deep-links.md).

## Step 8 — Tests

Mirror the layer layout under `test/`:

- `test/data/<feature>/` — repository + mapper tests.
- `test/domain/<feature>/` — use case tests.
- `test/presentation/<feature>/` — controller + widget smoke tests.

See [testing.md](./testing.md) for patterns.

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
