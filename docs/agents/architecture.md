# Architecture

> Feature-first **Clean Architecture** with a shared `core/` layer and
> `data` / `domain` / `presentation` subfolders inside each feature.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## Overview

```
features/<x>/presentation/  ──►  features/<x>/domain/  ◄──  features/<x>/data/
        │                              │
        └────────────►  core/  ◄───────┘
```

- `features/<x>/presentation/` — pages, widgets, controllers (Riverpod notifiers).
- `features/<x>/domain/` — pure Dart: entities, repository contracts, use cases. **No Flutter, no Dio.**
- `features/<x>/data/` — DTOs, mappers, remote/local data sources, repository implementations.
- `core/` — cross-cutting infrastructure (network, storage, theme, l10n, etc.).

Cross-feature access **only** via Riverpod providers exposed in
`features/<x>/presentation/riverpod/<x>_providers.dart`.

## Layering rules (enforced)

| Layer                              | May import from                                                   |
|------------------------------------|-------------------------------------------------------------------|
| `features/<x>/presentation/`       | `features/<x>/domain/`, `core/`                                   |
| `features/<x>/domain/`             | `core/` **only** (never other features, never `data/`)            |
| `features/<x>/data/`               | `features/<x>/domain/`, `core/`                                   |
| `core/`                            | Other `core/` submodules — **except** `core/network/dio_client.dart`, which is allowed to import `features/auth/domain/` |

## Repository layout

```
lib/
├── app.dart                          # MaterialApp.router root
├── bootstrap.dart                    # Flavor-aware DI
├── main.dart / main_dev.dart / main_staging.dart / main_prod.dart
├── core/                             # Cross-cutting infra
│   ├── config/   connectivity/  constants/  env/   error/
│   ├── entity_mappable_options.dart
│   ├── l10n/     logger/        network/     notifications/
│   ├── observability/            result/     router/
│   ├── storage/  theme/         utils/      widgets/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── splash/
│   │   └── presentation/           # no domain/data
│   └── todo/
│       ├── data/
│       ├── domain/
│       └── presentation/
│           ├── todo_list/          # screen subfolder
│           └── todo_detail/
└── l10n/         # ARB sources

test/
├── core/   features/   helpers/

assets/branding/
```

## Adding a new feature

Create one feature folder with three layer slices (presentation-only features
like `splash` may omit `domain/` and `data/`):

```
lib/features/<feature>/
  domain/
    entities/<feature>.dart
    repositories/<feature>_repository.dart
    usecases/<verb>_<feature>_use_case.dart
  data/
    api/<feature>_api.dart
    remote/<feature>_remote_source.dart
    data_source/<feature>_data_source.dart
    data_source/<feature>_data_source_impl.dart
    mock/<feature>_mock_source.dart              # only if needed
    local/<feature>_local_source.dart            # only if needed
    mapper/<feature>_mapper.dart
    model/<feature>_dto.dart
    repository_impl/<feature>_repository_impl.dart
  presentation/
    riverpod/<feature>_providers.dart
    <feature>_page.dart
    widgets/<section>_widget.dart
```

Then follow the steps in [feature-recipe.md](./feature-recipe.md).

## Related

- [layering-rules.md](./layering-rules.md) — full import-direction table and rationale.
- [feature-recipe.md](./feature-recipe.md) — the step-by-step "add a feature" checklist.
- [../../AGENTS.md](../../AGENTS.md) — index.
