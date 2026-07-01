# Migrate to Layer-First Architecture

> Decision record + step-by-step migration plan for moving the repo from
> **feature-first** (`lib/features/<x>/{data,domain,presentation}`) to
> **layer-first** (`lib/{data,domain,presentation}/<x>` + shared `lib/core/`).
>
> Status: **superseded** — migrated on branch `feat/layer-first-architecture`.
> Reversed by [migrate-to-feature-first.md](./migrate-to-feature-first.md).

---

## 1. The two structures

### Current — feature-first (package by feature)

```
lib/
├── core/                      # cross-cutting infra (unchanged)
└── features/
    ├── auth/
    │   ├── data/   domain/   presentation/
    └── todo/
        ├── data/   domain/   presentation/
```

### Target — layer-first (package by layer, feature subfolders)

```
lib/
├── core/                      # cross-cutting infra (unchanged)
├── domain/
│   ├── auth/   { entities/ repositories/ usecases/ }
│   └── todo/   { entities/ repositories/ usecases/ }
├── data/
│   ├── auth/   { api/ data_source/ mapper/ model/ repository_impl/ }
│   └── todo/   { api/ data_source/ mapper/ model/ repository_impl/ }
└── presentation/
    ├── auth/   { riverpod/ widgets/ }
    └── todo/   { riverpod/ widgets/ }
```

The layer **import direction is identical** in both layouts:
`presentation → domain ← data`, and all three → `core`. Only the *folder
grouping* changes.

---

## 2. Pros & cons of this decision (layer-first)

### Pros
- **Layer boundaries are visible at the top level.** A newcomer sees
  `domain/ data/ presentation/` immediately and the Clean Architecture
  intent is obvious from the tree.
- **Per-layer tooling is easy.** "Lint/own/codegen everything in `domain/`"
  is a single path glob.
- **Feature subfolders avoid the worst layer-first problem** (one giant
  flat `presentation/` folder). Each layer still groups by feature.
- **Matches mental model of "I'm working on the data layer right now."**

### Cons
- **A single feature is scattered across 3 top-level folders.** Touching
  `todo` means jumping between `domain/todo`, `data/todo`,
  `presentation/todo`. This is slower day-to-day navigation.
- **Scales worse as features grow.** At N features every layer folder holds
  N subfolders; you constantly cross-navigate instead of staying in one
  feature folder.
- **Weaker feature isolation.** Cross-feature imports (e.g.
  `domain/todo` → `domain/auth`) look "local" and are easy to add by
  accident, eroding the `<x>_providers.dart` boundary rule.
- **Harder to delete or extract a feature.** Feature-first = delete/lift one
  folder. Layer-first = surgery in 3 places.
- **Fights the whole repo.** `AGENTS.md`, `docs/agents/*`, `docs/tasks/*`,
  CODEOWNERS (`features/auth/`), and ~190 imports assume `features/<x>/`.
- **Community convention is feature-first** for Flutter Clean Architecture
  (Very Good Ventures — the `very_good_analysis` authors — Code With Andrea,
  Resocoder). Moving away increases onboarding friction for contributors.

### Recommendation
Feature-first already gives you a deterministic, identical `data/domain/
presentation` shape *inside every feature*. Layer-first trades co-location
for top-level visibility you already get from the documented import table.
**Proceed only if top-level layer visibility is a hard requirement for your
team.** Otherwise the migration cost is high for low ergonomic payoff.

---

## 3. Scope of the change

| Area | Impact |
|------|--------|
| `lib/features/**` | Moved to `lib/{domain,data,presentation}/<feature>/` |
| `test/features/**` | Mirror move to `test/{domain,data,presentation}/<feature>/` |
| Imports | ~190 `package:flutter_clean_riverpod_boilerplate/features/...` rewrites |
| Generated files | `*.g.dart`, `*.freezed.dart` — regenerate, don't hand-edit |
| `core/network/dio_client.dart` | Imports `features/auth/domain/...` → update path |
| `core/router/app_router.dart` | Imports feature pages/providers → update paths |
| `lib/bootstrap.dart` | Feature imports → update paths |
| Docs | `AGENTS.md` + `docs/agents/{architecture,layering-rules,feature-recipe}.md` + `docs/tasks/add-feature.md` |
| `CODEOWNERS` | `features/auth/` → new auth paths across 3 layers |
| `analysis_options.yaml` | Any path-scoped rules referencing `features/` |

> **Code-owner gate:** this touches `core/network/`, `features/auth/`, and
> `.github/` (CODEOWNERS). Per `docs/agents/code-ownership.md` these require
> code-owner review. Get sign-off before merging.

---

## 4. Path mapping (deterministic rule)

Every file move follows one rule:

```
lib/features/<feature>/<layer>/<rest>   →   lib/<layer>/<feature>/<rest>
test/features/<feature>/<rest>          →   test/<layer-or-feature>/<feature>/<rest>
```

Concrete examples:

| From | To |
|------|----|
| `lib/features/todo/domain/entities/todo.dart` | `lib/domain/todo/entities/todo.dart` |
| `lib/features/todo/data/model/todo_dto.dart` | `lib/data/todo/model/todo_dto.dart` |
| `lib/features/todo/presentation/widgets/todo_list_page.dart` | `lib/presentation/todo/widgets/todo_list_page.dart` |
| `lib/features/todo/presentation/riverpod/todo_providers.dart` | `lib/presentation/todo/riverpod/todo_providers.dart` |
| `lib/features/auth/data/repository_impl/auth_repository_impl.dart` | `lib/data/auth/repository_impl/auth_repository_impl.dart` |

Import rewrite (the same rule, in package form):

```
package:flutter_clean_riverpod_boilerplate/features/<feature>/<layer>/<rest>
→ package:flutter_clean_riverpod_boilerplate/<layer>/<feature>/<rest>
```

---

## 5. Execution plan (step by step)

Do this on a dedicated branch. Commit after each phase so you can bisect.

```bash
git switch -c refactor/layer-first
```

### Phase 0 — Pre-flight (clean baseline)
1. Ensure the working tree is clean and all gates pass first:
   ```bash
   fvm dart format --set-exit-if-changed .
   fvm flutter analyze
   fvm flutter test
   ```
2. Delete generated files so the move doesn't carry stale outputs; they get
   regenerated in Phase 3:
   ```bash
   find lib test -name '*.g.dart' -o -name '*.freezed.dart' | xargs rm -f
   ```

### Phase 1 — Create the new layer folders
```bash
mkdir -p lib/domain lib/data lib/presentation
mkdir -p test/domain test/data test/presentation
```

### Phase 2 — Move source files (use `git mv` to preserve history)
For each feature (`auth`, `todo`) and each layer, move the subtree.
Prefer `git mv` so blame/history survives.

```bash
for f in auth todo; do
  for layer in domain data presentation; do
    git mv "lib/features/$f/$layer" "lib/$layer/$f"
  done
done
# remove the now-empty features dir
rmdir lib/features 2>/dev/null || true
```

Mirror the test tree (tests are grouped by feature today; choose to mirror
by layer for consistency, or keep `test/<feature>/` — pick one and be
consistent). Layer-first mirror:

```bash
for f in auth todo; do
  for layer in domain data presentation; do
    [ -d "test/features/$f/$layer" ] && git mv "test/features/$f/$layer" "test/$layer/$f"
  done
done
```

> Note: current tests don't strictly mirror the `domain/data/presentation`
> subfolders (e.g. `test/features/todo/data/...`). Verify each path before
> moving; adjust the loop to the actual test layout.

### Phase 3 — Rewrite imports
Rewrite every `features/<f>/<layer>/` package import to `<layer>/<f>/`.
This is the single mechanical transform from §4. Run it across `lib/` and
`test/`:

```bash
# macOS/BSD sed
grep -rl 'package:flutter_clean_riverpod_boilerplate/features/' lib test \
  | xargs sed -i '' -E \
    's#(package:flutter_clean_riverpod_boilerplate/)features/([a-z_]+)/(domain|data|presentation)/#\1\3/\2/#g'
```

Then handle relative imports *within* a moved feature (if any exist) — these
usually keep working because the relative depth is unchanged, but verify.

### Phase 4 — Regenerate codegen
```bash
fvm flutter pub get
fvm dart run build_runner build --delete-conflicting-outputs
fvm flutter gen-l10n   # only if l10n touched; usually not needed here
```

### Phase 5 — Fix stragglers
Compile and fix what the analyzer flags (paths the regex missed,
barrel/export files, `part`/`part of` directives in generated files):
```bash
fvm flutter analyze
```
Likely manual touch points:
- `lib/bootstrap.dart`
- `lib/core/router/app_router.dart`
- `lib/core/network/dio_client.dart` (auth domain import — code-owner gated)

### Phase 6 — Update docs & ownership
- `AGENTS.md` — replace every `features/<x>/` reference and the import table.
- `docs/agents/architecture.md` — repo layout + "Adding a new feature" tree.
- `docs/agents/layering-rules.md` — path examples.
- `docs/agents/feature-recipe.md` — the 6-file template paths.
- `docs/tasks/add-feature.md` — new-feature folder shape.
- `docs/agents/code-ownership.md` + `CODEOWNERS` — `features/auth/` becomes
  `domain/auth/ data/auth/ presentation/auth/`.
- `.cursor/rules` / user rules referencing `lib/presentation/<screen>/` —
  reconcile with the new layout.

### Phase 7 — Verify (the pre-PR gate)
All three must be clean:
```bash
fvm dart format --set-exit-if-changed .
fvm flutter analyze
fvm flutter test
```
Then smoke-run each flavor:
```bash
fvm flutter run -t lib/main_dev.dart
```

### Phase 8 — PR
Single focused PR titled e.g. `refactor: migrate to layer-first structure`.
Call out in the description: no behavior change, pure move + import rewrite,
codegen regenerated. Request code-owner review (network/auth/.github).

---

## 6. New "add a feature" shape (post-migration)

After migrating, a new feature `foo` is created as three slices:

```
lib/domain/foo/
  entities/foo.dart
  repositories/foo_repository.dart
  usecases/<verb>_foo_use_case.dart
lib/data/foo/
  api/foo_api.dart
  data_source/foo_remote_data_source.dart
  mapper/foo_mapper.dart
  model/foo_dto.dart
  repository_impl/foo_repository_impl.dart
lib/presentation/foo/
  riverpod/foo_providers.dart
  widgets/foo_page.dart
```

Cross-feature access rule is unchanged: only via
`presentation/<x>/riverpod/<x>_providers.dart`.

---

## 7. Rollback

The migration is a pure move + import rewrite with regenerated codegen.
If anything breaks irrecoverably:
```bash
git switch main && git branch -D refactor/layer-first
```
No data, no API, no behavior changed — rollback is just discarding the branch.
