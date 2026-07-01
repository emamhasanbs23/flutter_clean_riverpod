# Refactor Data Source Layer Structure

> Implementation plan for standardizing `lib/features/<feature>/data/` data access:
> a **feature-level facade** in `data_source/` that constructor-injects a
> **remote** dependency from a sibling `remote/` folder.
>
> Status: **completed** — applied on branch implementing feature-first data sources.

---

## 1. Goal

Repositories depend on a **single feature data-source contract**
(`AuthDataSource`, `TodoDataSource`), not on remote, mock, or local types
directly. Remote networking lives in `remote/`; mocks in `mock/`; cache in
`local/` — each injected into `<feature>_data_source_impl.dart` when needed.

This gives us:

- One stable dependency for `*RepositoryImpl` and tests.
- Remote / mock / local concerns in dedicated sibling folders.
- Room to add `local/` without changing the repository constructor.
- Consistent naming across features (auth and todo today are inconsistent).

---

## 2. Target folder layout

```
lib/features/<feature>/data/
├── mock/
│   └── <feature>_mock_source.dart
├── local/
│   └── <feature>_local_source.dart
├── remote/
│   └── <feature>_remote_source.dart          # Retrofit + guard
├── data_source/
│   ├── <feature>_data_source.dart            # aggregate contract (repo depends on this)
│   └── <feature>_data_source_impl.dart       # facade; holds _remoteSource
├── api/                                      # Retrofit codegen contracts (keep as-is)
│   └── <feature>_api.dart
├── mapper/
├── model/
└── repository_impl/
    └── <feature>_repository_impl.dart
```

**Which folders to create per feature:**

| Folder | When |
|--------|------|
| `remote/` | Always (real network access). |
| `data_source/` | Always (aggregate contract + impl). |
| `mock/` | When tests or dev need an in-memory / fake backend (todo today). |
| `local/` | When offline cache or on-device persistence is needed (not auth tokens — those stay in the repository). |
| `api/` | When using Retrofit `@RestApi` codegen. |

---

## 3. Naming conventions

| Layer | File | Class / interface |
|-------|------|-------------------|
| Aggregate | `data_source/<feature>_data_source.dart` | `<Feature>DataSource` |
| Aggregate impl | `data_source/<feature>_data_source_impl.dart` | `<Feature>DataSourceImpl` |
| Remote | `remote/<feature>_remote_source.dart` | `<Feature>RemoteSource` |
| Mock (optional) | `mock/<feature>_mock_source.dart` | `<Feature>MockSource` |
| Local (optional) | `local/<feature>_local_source.dart` | `<Feature>LocalSource` |

Each `*_source.dart` file is **self-contained** — contract + implementation live
in the same file (no separate `_impl` sibling for remote / mock / local).

**Dependency direction:**

```
RepositoryImpl  →  FeatureDataSource
                        ↑
              FeatureDataSourceImpl(_remoteSource [, _localSource])
                        ↑
              FeatureRemoteSource(_api)        # in remote/<feature>_remote_source.dart
```

---

## 4. Responsibility split

| Type | Location | Role |
|------|----------|------|
| Aggregate contract | `data_source/<feature>_data_source.dart` | Methods the repository calls. Returns DTOs. No Retrofit / Dio wiring. |
| Aggregate impl | `data_source/<feature>_data_source_impl.dart` | Implements aggregate contract. **Constructor-injects** `_remoteSource`. Delegates network calls; may orchestrate remote + local later. |
| Remote | `remote/<feature>_remote_source.dart` | Network-only surface. Retrofit via `api/`, `guard`, `CancelToken`. Constructor-injects `_api`. |
| Mock (optional) | `mock/<feature>_mock_source.dart` | In-memory / fake backend. Implements `<Feature>DataSource` directly — swapped via provider override. |
| Local (optional) | `local/<feature>_local_source.dart` | On-device cache reads/writes. Injected into aggregate impl when needed. |

---

## 5. Constructor & field conventions

### `data_source/<feature>_data_source_impl.dart`

```dart
class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl(this._remoteSource);

  final AuthRemoteSource _remoteSource;

  @override
  Future<LoginResponse> login({required LoginRequest request}) =>
      _remoteSource.login(request: request);
}
```

Rules:

- Use **`_<feature>RemoteSource`** (or `_remoteSource` when unambiguous) as the
  **sole constructor dependency** for a remote-only feature.
- Named constructor params only when there are **2+** dependencies (e.g. remote + local).
- No `Ref`, no `BuildContext`, no secure storage in data-source impls.

### `remote/<feature>_remote_source.dart`

Single file — interface + impl together:

```dart
abstract interface class AuthRemoteSource {
  Future<LoginResponse> login({required LoginRequest request});
  // ...
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  AuthRemoteSourceImpl(this._api);

  final AuthApi _api;

  @override
  Future<LoginResponse> login({required LoginRequest request}) => guard(
        'AuthRemoteSource.login',
        () => _api.login(request),
      );
}
```

### `mock/<feature>_mock_source.dart`

Implements the **aggregate** contract (not remote):

```dart
class TodoMockSource implements TodoDataSource {
  // in-memory list, artificial latency, etc.
}
```

---

## 6. Current state vs target

### Auth (`lib/features/auth/data/`)

| Today | Target |
|-------|--------|
| `data_source/auth_remote_data_source.dart` | merged into `remote/auth_remote_source.dart` |
| `data_source/auth_remote_data_source_impl.dart` | merged into `remote/auth_remote_source.dart` |
| *(missing)* | `data_source/auth_data_source.dart` |
| *(missing)* | `data_source/auth_data_source_impl.dart` |
| `AuthRepositoryImpl` takes `AuthRemoteDataSource` | `AuthRepositoryImpl` takes `AuthDataSource` |

### Todo (`lib/features/todo/data/`)

| Today | Target |
|-------|--------|
| `data_source/todo_remote_data_source.dart` defines **`TodoDataSource`** (misnamed) | `data_source/todo_data_source.dart` |
| `data_source/todo_remote_data_source_impl.dart` | merged into `remote/todo_remote_source.dart` |
| *(missing)* | `data_source/todo_data_source_impl.dart` delegates to `_remoteSource` |
| `data_source/todo_mock_data_source.dart` | `mock/todo_mock_source.dart` implements `TodoDataSource` |

---

## 7. Migration steps (ordered)

### Phase 0 — Docs & recipe (before code moves)

1. Update [feature-recipe.md](../agents/feature-recipe.md) Step 1 tree to match §2.
2. Update [architecture.md](../agents/architecture.md) repository layout snippet.
3. Link this task from [AGENTS.md](../../AGENTS.md) “Where to look when…” table.

### Phase 1 — Auth (CODEOWNERS-gated)

> Touching `features/auth/data/` may need code-owner review — see
> [code-ownership.md](../agents/code-ownership.md).

1. **Add aggregate contract** — `data_source/auth_data_source.dart`
   - Copy method signatures from current `AuthRemoteDataSource`.
2. **Create `remote/auth_remote_source.dart`**
   - Merge `auth_remote_data_source.dart` + `auth_remote_data_source_impl.dart`.
   - Rename types: `AuthRemoteDataSource` → `AuthRemoteSource`.
   - Delete the two old files under `data_source/`.
3. **Add facade** — `data_source/auth_data_source_impl.dart`
   - `AuthDataSourceImpl(this._remoteSource)` delegating to `_remoteSource`.
4. **Update repository** — `repository_impl/auth_repository_impl.dart`
   - `AuthDataSource dataSource` (field `_dataSource`); replace `_remote` calls.
5. **Update providers** — `features/auth/presentation/riverpod/auth_providers.dart`
   - `authRemoteSourceProvider` → `AuthRemoteSourceImpl`
   - `authDataSourceProvider` → `AuthDataSourceImpl(ref.watch(authRemoteSourceProvider))`
   - `authRepositoryProvider` → uses `authDataSourceProvider`
6. **Regenerate** — `fvm dart run build_runner build --delete-conflicting-outputs`
7. **Fix tests** — `test/features/auth/data/auth_repository_impl_test.dart` mocks `AuthDataSource`.

### Phase 2 — Todo

1. **Extract aggregate contract** — `data_source/todo_data_source.dart`
   (content from misnamed `todo_remote_data_source.dart`).
2. **Create `remote/todo_remote_source.dart`**
   - Merge `todo_remote_data_source_impl.dart` into this file.
   - Types: `TodoRemoteSource` / `TodoRemoteSourceImpl`.
3. **Add facade** — `data_source/todo_data_source_impl.dart`
   (`TodoDataSourceImpl(this._remoteSource)`).
4. **Move mock** — `data_source/todo_mock_data_source.dart` →
   `mock/todo_mock_source.dart`, rename class to `TodoMockSource`.
5. **Delete** old `data_source/todo_remote_data_source.dart` and
   `data_source/todo_remote_data_source_impl.dart`.
6. **Update providers** — `presentation/todo/riverpod/todo_providers.dart`
7. **Fix tests** — `test/features/todo/data/`

### Phase 3 — Cleanup legacy `lib/features/` duplicates

Delete or align any stale copies under `lib/features/*/data/`.

### Phase 4 — Verify

```bash
fvm dart format --set-exit-if-changed .
fvm flutter analyze
fvm flutter test
```

---

## 8. Provider wiring (target)

### Auth

```dart
@Riverpod(keepAlive: true)
AuthApi authApi(Ref ref) => AuthApi(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
AuthRemoteSource authRemoteSource(Ref ref) {
  return AuthRemoteSourceImpl(ref.watch(authApiProvider));
}

@Riverpod(keepAlive: true)
AuthDataSource authDataSource(Ref ref) {
  return AuthDataSourceImpl(ref.watch(authRemoteSourceProvider));
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    dataSource: ref.watch(authDataSourceProvider),
    storage: ref.watch(secureStorageServiceProvider),
  );
}
```

### Todo

```dart
@Riverpod(keepAlive: true)
TodoRemoteSource todoRemoteSource(Ref ref) {
  return TodoRemoteSourceImpl(ref.watch(todoApiProvider));
}

@Riverpod(keepAlive: true)
TodoDataSource todoDataSource(Ref ref) {
  return TodoDataSourceImpl(ref.watch(todoRemoteSourceProvider));
}

@Riverpod(keepAlive: true)
TodoDataSource todoMockSource(Ref ref) => TodoMockSource();

@Riverpod(keepAlive: true)
TodoRepository todoRepository(Ref ref) {
  return TodoRepositoryImpl(dataSource: ref.watch(todoDataSourceProvider));
}
```

Tests override **`authDataSourceProvider`** / **`todoDataSourceProvider`**
(not the remote provider) unless specifically testing remote `guard` behavior.
For todo dev without network, override with **`todoMockSourceProvider`**.

---

## 9. When to add `local/`

Add `local/<feature>_local_source.dart` when a feature needs:

- SQLite / Hive cache,
- offline-first reads,
- or persisted reads that are **not** repository orchestration (auth keeps
  token persistence in `AuthRepositoryImpl` — that stays).

Then extend the aggregate impl:

```dart
class TodoDataSourceImpl implements TodoDataSource {
  TodoDataSourceImpl({
    required TodoRemoteSource remoteSource,
    TodoLocalSource? localSource,
  })  : _remoteSource = remoteSource,
        _localSource = localSource;

  final TodoRemoteSource _remoteSource;
  final TodoLocalSource? _localSource;
}
```

---

## 10. Done criteria

- [x] Every feature under `lib/features/<feature>/data/` follows the §2 tree.
- [x] Every `*RepositoryImpl` depends on `<Feature>DataSource`, not `<Feature>RemoteSource`.
- [x] Every `<feature>_data_source_impl.dart` injects `_remoteSource` via constructor.
- [x] Remote logic lives in a single `remote/<feature>_remote_source.dart`.
- [x] Mocks live in `mock/<feature>_mock_source.dart` (not under `data_source/`).
- [x] [feature-recipe.md](../agents/feature-recipe.md) and
      [architecture.md](../agents/architecture.md) updated.
- [x] Pre-PR gates clean (format, analyze, test).

---

## 11. Related

- [feature-recipe.md](../agents/feature-recipe.md) — new feature checklist (to update).
- [architecture.md](../agents/architecture.md) — layer layout (to update).
- [networking.md](../agents/networking.md) — `guard`, Dio, Retrofit in remote sources.
- [testing.md](../agents/testing.md) — mock the aggregate data source in repo tests.
- [migrate-to-layer-first.md](./migrate-to-layer-first.md) — prior structural migration.
