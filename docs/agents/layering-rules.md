# Layering Rules

> Strict Clean Architecture import directions.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## Import direction

```
presentation/  ──►  domain/  ◄──  data/
        │                │
        └────►  core/  ◄──┘
```

| Layer           | Allowed imports                                                              |
|-----------------|------------------------------------------------------------------------------|
| `presentation/` | `domain/`, `core/`                                                           |
| `domain/`       | `core/` **only** (never other features, never `data/`)                       |
| `data/`         | `domain/`, `core/`                                                           |
| `core/`         | Other `core/` submodules — **except** `core/network/dio_client.dart`, which is allowed to import `features/auth/domain/` |

## Why this matters

- The domain layer is the business-core; it must not depend on Flutter or Dio.
- The data layer can change (new endpoints, new caches) without touching the domain or presentation.
- The presentation layer can be rebuilt (e.g. for a web target) without changing business rules.

## What "domain may import core" really means

The domain layer is allowed to use shared utilities — `Either`, `Failure`, primitives — but **not** the concrete `Dio` instance or any `flutter_secure_storage`. If you find yourself wanting to import `core/network/` from `domain/`, you have a layering bug.

## The one exception

`core/network/dio_client.dart` (and the `AuthInterceptor`) is allowed to import `features/auth/domain/` because the interceptor needs the auth domain types to perform refresh. **This file is code-owner gated** — see [code-ownership.md](./code-ownership.md).

## Tests

Test files follow the same rules. Cross-cutting test helpers in `test/helpers/` may be imported anywhere.

## Related

- [architecture.md](./architecture.md) — the high-level picture.
- [feature-recipe.md](./feature-recipe.md) — concrete file layout for new features.
- [../../AGENTS.md](../../AGENTS.md) — index.
