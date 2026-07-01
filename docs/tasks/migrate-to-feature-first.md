# Migrate to Feature-First Architecture

> Decision record + step-by-step migration plan for moving the repo from
> **layer-first** (`lib/{data,domain,presentation}/<x>`) to
> **feature-first** (`lib/features/<x>/{data,domain,presentation}` + shared `lib/core/`).
>
> Status: **completed** — migrated on branch `refactor/feature-first`.
> Supersedes [migrate-to-layer-first.md](./migrate-to-layer-first.md).

---

## 1. The two structures

### Previous — layer-first (package by layer)

```
lib/
├── core/
├── domain/
│   ├── auth/   todo/
├── data/
│   ├── auth/   todo/
└── presentation/
    ├── auth/   splash/   todo_list/   todo_detail/
```

### Current — feature-first (package by feature)

```
lib/
├── core/                      # cross-cutting infra (unchanged)
└── features/
    ├── auth/
    │   ├── data/   domain/   presentation/
    ├── splash/
    │   └── presentation/     # page only — no domain/data
    └── todo/
        ├── data/   domain/
        └── presentation/
            ├── todo_list/    # screen subfolder + providers
            └── todo_detail/
```

The layer **import direction is identical** in both layouts:
`presentation → domain ← data`, and all three → `core`. Only the *folder
grouping* changes.

**Shared utility:** `entity_mappable_options.dart` moved from `lib/domain/` to
`lib/core/` (used by all mappable domain entities).

---

## 2. Path mapping (deterministic rule)

Every file move follows one rule:

```
lib/<layer>/<feature>/<rest>   →   lib/features/<feature>/<layer>/<rest>
```

Special cases:

| From | To |
|------|----|
| `lib/presentation/todo_list/<rest>` | `lib/features/todo/presentation/todo_list/<rest>` |
| `lib/presentation/todo_detail/<rest>` | `lib/features/todo/presentation/todo_detail/<rest>` |
| `lib/presentation/splash/splash_page.dart` | `lib/features/splash/presentation/splash_page.dart` |
| `lib/domain/entity_mappable_options.dart` | `lib/core/entity_mappable_options.dart` |

Import rewrite (package form):

```
package:flutter_clean_riverpod_boilerplate/<layer>/<feature>/<rest>
→ package:flutter_clean_riverpod_boilerplate/features/<feature>/<layer>/<rest>
```

Presentation screen slices:

```
package:.../presentation/todo_list/...  →  package:.../features/todo/presentation/todo_list/...
package:.../presentation/auth/...       →  package:.../features/auth/presentation/...
```

Test mirror:

```
test/<layer>/<feature>/...  →  test/features/<feature>/<layer>/...
test/presentation/todo_list/...  →  test/features/todo/presentation/todo_list/...
```

---

## 3. Scope of the change

| Area | Impact |
|------|--------|
| `lib/{domain,data,presentation}/**` | Moved to `lib/features/<feature>/` |
| `test/{domain,data,presentation}/**` | Mirror move to `test/features/<feature>/` |
| Imports | All `package:.../<layer>/<feature>/` rewrites |
| Generated files | `*.g.dart`, `*.freezed.dart`, `*.mapper.dart` — regenerate |
| `core/network/dio_client.dart` | `domain/auth/` → `features/auth/domain/` |
| `core/router/app_router.dart` | Feature page/provider imports updated |
| `lib/bootstrap.dart` | Auth provider import updated |
| Docs | `AGENTS.md`, `docs/agents/*`, `docs/tasks/*`, `CODEOWNERS` |
| `entity_mappable_options.dart` | `lib/domain/` → `lib/core/` |

> **Code-owner gate:** touches `core/network/`, `features/auth/`, and
> `.github/` (CODEOWNERS). Per `docs/agents/code-ownership.md` these require
> code-owner review.

---

## 4. Execution summary (what was done)

1. Pre-flight: `flutter analyze` + `flutter test` clean on `okmain`.
2. Branch: `refactor/feature-first`.
3. `git mv` all feature slices into `lib/features/<feature>/`.
4. Regex rewrite of package imports across `lib/` and `test/`.
5. `fvm dart run build_runner build --delete-conflicting-outputs`.
6. Docs + `CODEOWNERS` updated to feature-first paths.
7. Pre-PR gate: format, analyze, test — all clean.

---

## 5. New "add a feature" shape

After migrating, a new feature `foo` is created as one folder:

```
lib/features/foo/
  domain/{entities,repositories,usecases}/
  data/{api,data_source,mapper,model,remote,repository_impl}/
  presentation/{riverpod,widgets}/, foo_page.dart
```

Cross-feature access rule is unchanged: only via
`features/<x>/presentation/riverpod/<x>_providers.dart`.

---

## 6. Rollback

Pure move + import rewrite with regenerated codegen. Discard the branch:

```bash
git switch main && git branch -D refactor/feature-first
```

No data, API, or behavior changed.
