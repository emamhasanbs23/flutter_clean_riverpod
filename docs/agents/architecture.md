# Architecture

> Layer-first **Clean Architecture** with a shared `core/` layer and
> feature subfolders inside each layer.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## Overview

```
presentation/  ──►  domain/  ◄──  data/
        │                │
        └────►  core/  ◄──┘
```

- `presentation/` — pages, widgets, controllers (Riverpod notifiers).
- `domain/` — pure Dart: entities, repository contracts, use cases. **No Flutter, no Dio.**
- `data/` — DTOs, mappers, remote/local data sources, repository implementations.
- `core/` — cross-cutting infrastructure (network, storage, theme, l10n, etc.).

Each layer groups code by feature: `domain/auth/`, `data/todo/`, etc.

Cross-feature access **only** via Riverpod providers exposed in
`presentation/<x>/riverpod/<x>_providers.dart`.

## Layering rules (enforced)

| Layer           | May import from                                                   |
|-----------------|-------------------------------------------------------------------|
| `presentation/` | `domain/`, `core/`                                                |
| `domain/`       | `core/` **only** (never other features, never `data/`)            |
| `data/`         | `domain/`, `core/`                                                |
| `core/`         | Other `core/` submodules — **except** `core/network/dio_client.dart`, which is allowed to import `domain/auth/` |

## Repository layout

```
lib/
├── app.dart                          # MaterialApp.router root
├── bootstrap.dart                    # Flavor-aware DI
├── main.dart / main_dev.dart / main_staging.dart / main_prod.dart
├── core/                             # Cross-cutting infra
│   ├── config/   connectivity/  constants/  env/   error/
│   ├── l10n/     logger/        network/     notifications/
│   ├── observability/            result/     router/
│   ├── storage/  theme/         utils/      widgets/
├── domain/                           # Pure business logic, by feature
│   ├── auth/
│   └── todo/
├── data/                             # DTOs, APIs, repos, by feature
│   ├── auth/
│   └── todo/
├── presentation/                     # UI + Riverpod, by feature
│   ├── auth/
│   └── todo/
└── l10n/         # ARB sources

test/
├── core/   domain/   data/   presentation/   helpers/

assets/branding/
```

## Adding a new feature

Create three feature slices under each layer:

```
lib/domain/<feature>/
  entities/<feature>.dart
  repositories/<feature>_repository.dart
  usecases/<verb>_<feature>_use_case.dart
lib/data/<feature>/
├── api/<feature>_api.dart
├── remote/<feature>_remote_source.dart
├── data_source/<feature>_data_source.dart
├── data_source/<feature>_data_source_impl.dart
├── mock/<feature>_mock_source.dart              # only if needed
├── local/<feature>_local_source.dart            # only if needed
├── mapper/<feature>_mapper.dart
├── model/<feature>_dto.dart
└── repository_impl/<feature>_repository_impl.dart
lib/presentation/<feature>/
  riverpod/<feature>_providers.dart
  <feature>_page.dart
  widgets/<section>_widget.dart
```

Then follow the steps in [feature-recipe.md](./feature-recipe.md).

## Related

- [layering-rules.md](./layering-rules.md) — full import-direction table and rationale.
- [feature-recipe.md](./feature-recipe.md) — the step-by-step "add a feature" checklist.
- [../../AGENTS.md](../../AGENTS.md) — index.
