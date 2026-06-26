# Architecture

> Feature-first **Clean Architecture** with a shared `core/` layer.
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

Cross-feature access **only** via Riverpod providers exposed in `features/<x>/<x>_providers.dart`.

## Layering rules (enforced)

| Layer           | May import from                                                   |
|-----------------|-------------------------------------------------------------------|
| `presentation/` | `domain/`, `core/`                                                |
| `domain/`       | `core/` **only** (never other features, never `data/`)            |
| `data/`         | `domain/`, `core/`                                                |
| `core/`         | Other `core/` submodules — **except** `core/network/dio_client.dart`, which is allowed to import `features/auth/domain/` |

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
├── features/
│   ├── auth/    # reference feature
│   └── todo/    # reference feature
└── l10n/         # ARB sources

test/
├── core/   features/   helpers/

assets/branding/
```

## Adding a new feature

Create `lib/features/<feature>/` with this exact tree:

```
data/
  datasources/<feature>_remote_data_source.dart
  datasources/<feature>_local_data_source.dart   # if needed
  models/<feature>_dto.dart
  models/<feature>_mapper.dart
  repositories/<feature>_repository_impl.dart
domain/
  entities/<feature>.dart
  repositories/<feature>_repository.dart
  usecases/<verb>_<feature>.dart
presentation/
  pages/<feature>_page.dart
  widgets/
  controllers/<feature>_controller.dart         # Notifier
<feature>_providers.dart                         # Provider/NotifierProvider exports
```

Then follow the steps in [feature-recipe.md](./feature-recipe.md).

## Related

- [layering-rules.md](./layering-rules.md) — full import-direction table and rationale.
- [feature-recipe.md](./feature-recipe.md) — the step-by-step "add a feature" checklist.
- [../../AGENTS.md](../../AGENTS.md) — index.
