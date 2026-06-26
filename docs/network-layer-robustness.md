# Robust Network Layer with Retrofit — Blueprint & Current-State Audit

> Planning / analysis doc. Part 1 is a reusable blueprint for a robust
> Retrofit-based network layer in **any** Flutter project. Part 2 audits
> **this** repo against that blueprint and lists concrete gaps. No code is
> changed by this document — it is the spec we execute against next.

---

## Part 0 — TL;DR

- A robust network layer is **5 concerns, cleanly separated**: transport
  (Dio), cross-cutting interceptors (auth / retry / logging / connectivity),
  typed endpoint contracts (Retrofit `@RestApi`), wire models
  (DTO / response envelope), and translation (`DioException → Failure`,
  `DTO → entity`).
- The three things the user asked about map to:
  1. **Error handling** → one central `DioException → Failure` mapper +
     a richer `Failure` hierarchy + a `guard()` boundary helper.
  2. **Token refresh** → a single-flight (deduplicated) refresh inside one
     interceptor: `401 → dedup → refresh → retry once → session-expired`.
  3. **Response model** → typed DTOs (json_serializable/freezed) behind a
     generic `ApiResponse<T>` envelope + pagination, never leaked past
     `data/`.
- **This repo has already migrated to Retrofit/freezed/json_serializable
  in the working tree (uncommitted)** but the governing docs
  (`AGENTS.md`, `docs/agents/networking.md`) still mandate the opposite
  ("no codegen, hand-written DTOs"). That doctrine drift is itself a
  top-priority gap.

---

## Part 1 — Blueprint: a robust Retrofit network layer (any project)

### 1.1 The layered shape

```
┌──────────────────────────────────────────────────────────────┐
│ presentation (controller) → use case → repository            │  Either<Failure,T>
├──────────────────────────────────────────────────────────────┤
│ repository_impl  → maps DTO → entity, Failure → Either        │
│ data source      → guard(() => api.call())                    │  throws Failure
│ Retrofit @RestApi (typed contracts, fromJson per response)    │
│ DTO / ApiResponse<T> (json_serializable / freezed)            │
├──────────────────────────────────────────────────────────────┤
│ Dio (transport) + Interceptors:                               │
│   auth → retry → connectivity → logging                       │
└──────────────────────────────────────────────────────────────┘
```

**Rule of thumb:** every layer below the repository may *throw*; the
repository is the single place that converts throws into
`Either<Failure, T>`. Widgets never see a `DioException`.

### 1.2 Transport (Dio) — sane defaults

```dart
final dio = Dio(BaseOptions(
  baseUrl: config.baseUrl,
  connectTimeout: const Duration(seconds: 15),
  receiveTimeout: const Duration(seconds: 15),
  sendTimeout: const Duration(seconds: 15),
  // Let our own mapper decide what is an error, so 4xx bodies are parseable.
  validateStatus: (code) => code != null && code < 500,
  headers: const {'Accept': 'application/json'},
));
```

Interceptor **order matters**: `auth` first (attach/refresh token) → `retry`
(transient 5xx / timeout) → `connectivity` (fail fast offline) → `logging`
last (so it sees the final request). Logging must **redact** `Authorization`.

### 1.3 Typed contracts (Retrofit)

```dart
@RestApi()
abstract class TodoApi {
  factory TodoApi(Dio dio, {String baseUrl}) = _TodoApi;

  @GET('/todos')
  Future<ApiResponse<List<TodoDto>>> getTodos({
    @Query('page') int page = 1,
    CancelToken? cancelToken,
  });
}
```

- Every method takes an optional `CancelToken` so a disposed widget can
  abort in-flight work.
- The refresh endpoint must be **explicitly auth-exempt** (see 1.5).

### 1.4 Response model (the "response model" concern)

Most real backends wrap payloads. Model that once:

```dart
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  ApiResponse({required this.data, this.message, this.meta, this.error});
  final T? data;
  final String? message;
  final ApiMeta? meta;        // pagination, request id, etc.
  final ApiError? error;      // {code, message, fieldErrors}
  factory ApiResponse.fromJson(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$ApiResponseFromJson(json, fromJsonT);
}
```

- DTOs stay **private to `data/`**; mappers translate to domain entities.
- A `PaginatedResponse<T>` (items + `page`/`hasNext`/`total`) covers lists.
- If the backend returns bare arrays/objects (e.g. jsonplaceholder), keep
  the envelope optional — the API method type decides.

### 1.5 Token refresh (single-flight)

The non-negotiable invariant: **N concurrent 401s ⇒ exactly one refresh
call**, and the refresh request itself must **not** carry the expired
access token.

```dart
class AuthInterceptor extends Interceptor {
  Future<String?>? _refreshFuture;

  @override
  Future<void> onRequest(o, h) async {
    // Skip auth for explicitly-exempt endpoints (login, refresh).
    if (o.extra[_skipAuth] != true && o.headers['Authorization'] == null) {
      final t = await _storage.read(_accessTokenKey);
      if (t != null && t.isNotEmpty) o.headers['Authorization'] = 'Bearer $t';
    }
    h.next(o);
  }

  @override
  Future<void> onError(err, h) async {
    final retried = err.requestOptions.extra[_retryFlag] == true;
    if (err.response?.statusCode != 401 || retried) return h.next(err);

    final token = await (_refreshFuture ??= _doRefresh()
        .whenComplete(() => _refreshFuture = null));
    if (token == null) { await _clear(); _onSessionExpired?.call(); return h.next(err); }

    final req = err.requestOptions
      ..headers['Authorization'] = 'Bearer $token'
      ..extra[_retryFlag] = true;
    try { h.resolve(await _dio.fetch(req)); }
    on DioException catch (e) {
      // Persistent 401 even after refresh ⇒ give up + sign out.
      if (e.response?.statusCode == 401) { await _clear(); _onSessionExpired?.call(); }
      h.next(e);
    }
  }
}
```

Key points often missed:
- The **refresh endpoint must be auth-exempt** (`extra[_skipAuth] = true`),
  otherwise `onRequest` re-attaches the dead token and the backend may loop.
- A **persistent 401 after a successful refresh** must still trigger
  sign-out — not be silently forwarded.
- Refresh failures **clear tokens** so guards/redirects see logged-out.
- Never log token values — log presence only.

### 1.6 Error handling (the "error handling" concern)

A richer typed hierarchy so the UI can react differently:

```dart
sealed class Failure { const Failure(this.message); final String message; }
final class NoConnectionFailure   extends Failure { ... } // offline
final class TimeoutFailure        extends Failure { ... } // connect/recv timeout
final class ServerFailure         extends Failure { ... } // 5xx
final class UnauthorizedFailure   extends Failure { ... } // 401/403
final class NotFoundFailure       extends Failure { ... } // 404
final class ValidationFailure     extends Failure { ... } // 400/422 (+fieldErrors)
final class RateLimitFailure      extends Failure { ... } // 429 (+retryAfter)
final class CancelledFailure      extends Failure { ... } // DioException.cancel
final class SerializationFailure  extends Failure { ... } // fromJson threw
final class UnexpectedFailure     extends Failure { ... } // catch-all
```

Central mapper (the only place HTTP semantics live):

```dart
Failure mapDioException(DioException e) => switch (e.type) {
  DioExceptionType.cancel            => const CancelledFailure(),
  DioExceptionType.connectionError   => const NoConnectionFailure(),
  DioExceptionType.connectionTimeout ||
  DioExceptionType.sendTimeout ||
  DioExceptionType.receiveTimeout    => const TimeoutFailure(),
  _ => _mapStatus(e.response?.statusCode, e.response?.data),
};
```

`_mapStatus` parses the server error envelope (`{code, message,
fieldErrors}`) so `ValidationFailure` can carry field-level errors to the
form. The `guard()` boundary helper logs + maps once:

```dart
Future<T> guard<T>(String tag, Future<T> Function() call) async {
  try { return await call(); }
  on DioException catch (e, s) { log(tag, e, s); throw mapDioException(e); }
  on Object catch (e, s)       { log(tag, e, s); throw SerializationFailure('$tag'); }
}
```

### 1.7 Retry, connectivity, cancellation (robustness extras)

- **Retry interceptor** with exponential backoff for *idempotent* requests
  (GET) on `5xx` / timeouts, capped (e.g. 3 tries). Never auto-retry
  non-idempotent writes unless the backend exposes idempotency keys.
- **Connectivity guard**: short-circuit to `NoConnectionFailure` when
  offline instead of waiting for a timeout.
- **Cancellation**: one `CancelToken` per controller, cancelled in
  `onDispose`; mapped to `CancelledFailure` and swallowed by the controller.
- **Security**: TLS cert pinning for prod, correlation/request-id header,
  never persist tokens outside secure storage.

### 1.8 Testing the network layer

- Mapper unit tests: one case per `DioExceptionType` + per status bucket.
- Interceptor tests with `DioAdapter`/mock: single-flight refresh, retry
  once, persistent-401 sign-out, refresh endpoint sends no bearer.
- Repository tests: success + **every** `Failure` subtype → `Either`.
- DTO/envelope tests: missing/null fields, snake_case keys, generic
  `ApiResponse<T>` round-trip.

---

## Part 2 — Current state of THIS repo

### 2.1 What exists today (working tree)

| Concern | File | Status |
|---|---|---|
| Transport | `lib/core/network/dio_client.dart` | Dio + 15s timeouts, `AuthInterceptor`, `PrettyDioLogger`. Deferred auth-repo builder to avoid import cycle. |
| Token refresh | `lib/core/network/auth_interceptor.dart` | Single-flight `_refreshFuture` dedup, retry once, `onSessionExpired`. |
| Error map | `lib/core/error/dio_failure_mapper.dart` | Maps timeouts/connection→`NetworkFailure`, 401/403→`Unauthorized`, 404→`NotFound`, else `Unexpected`. |
| Boundary | `lib/core/network/network_guard.dart` | `guard()` logs + maps `DioException`, rethrows non-Dio. |
| Failures | `lib/core/error/failures.dart` | `Network`, `Unauthorized`, `NotFound`, `Unexpected`, `InvalidCredentials`. |
| Contracts | `features/*/data/api/*_api.dart` (+`.g.dart`) | **Retrofit** `@RestApi` for `AuthApi`, `TodoApi`. |
| Models | `features/*/data/model/*` | **freezed + json_serializable** DTOs/requests/responses. |
| Wiring | `*_providers.dart`, `bootstrap.dart` | `*ApiProvider` → `dioProvider`; interceptor refresh wired via `dioAuthRepositoryBuilderProvider`; `sessionExpiredSignalProvider → sessionExpiredProvider`. |

So: **the migration to Retrofit + codegen is already done in code** and is
wired end-to-end through Riverpod. The 401 funnel works and is deduped.

### 2.2 Gaps & risks (ranked)

**P0 — Doctrine / governance drift**
- `AGENTS.md` and `docs/agents/networking.md` still say "no codegen, no
  `freezed`, no `json_serializable`, no `retrofit`, no `build_runner`,
  hand-written DTOs". The code now does the exact opposite. Anyone
  following the docs will fight the codebase. `pubspec.yaml` already
  carries `retrofit`, `retrofit_generator`, `freezed`, `json_serializable`,
  `build_runner`. **Decision needed:** ratify the migration (update docs +
  rules + code-ownership) or revert it. Until resolved, every network task
  is ambiguous. `core/network/` and `features/auth/` are CODEOWNERS-gated,
  so this needs owner sign-off either way.

**P1 — Refresh request still carries the expired token**
- `AuthApi.refresh` exposes `@Header('Authorization') String? authorization`
  (defaults null → header dropped by Retrofit). But
  `AuthRemoteDataSourceImpl.refresh` calls `_api.refresh(request, ...)`
  **without** passing `authorization`, so the header is null when it leaves
  Retrofit — then `AuthInterceptor.onRequest` sees `Authorization == null`
  and **re-attaches the (expired) access token**. This defeats the
  documented intent ("refresh intentionally drops the Authorization
  header") and can cause backends to loop on 401 / reject refresh.
  **Fix:** mark the refresh request auth-exempt (e.g. `Options.extra` flag
  that `onRequest` honours), not just a nullable header.

**P1 — Persistent 401 after refresh does not sign out**
- In `auth_interceptor.dart onError`, when the retried request still
  returns 401, the code `return handler.next(retryError)` without calling
  `_clearAuthState()` / `_notifySessionExpired()`. A revoked session that
  refreshes "successfully" once but is still rejected leaves the user in a
  zombie logged-in state. **Fix:** on retry 401, clear + notify.

**P2 — Coarse error mapping; no server-error parsing**
- `dio_failure_mapper.dart` collapses everything non-401/403/404/timeout
  into `UnexpectedFailure`. No distinct handling for **5xx (server)**,
  **400/422 (validation + field errors)**, **429 (rate limit)**, or
  **`DioExceptionType.cancel`** (cancel currently → `UnexpectedFailure`).
  The server error body is never parsed, so the UI can't show real
  messages or field-level validation. **Fix:** richer `Failure` hierarchy
  (see 1.6) + envelope parsing.

**P2 — Comment/behaviour mismatch on cancellation**
- `todo_repository_impl.dart` claims "a `DioExceptionType.cancel` surfaces
  as a `NetworkFailure`", but the mapper actually returns
  `UnexpectedFailure` for cancel. The controller relies on
  `_cancelToken.isCancelled` to swallow it, so it "works", but the comment
  is wrong and there's no `CancelledFailure`. **Fix:** add `CancelledFailure`
  and align comments.

**P2 — No standardized response envelope / pagination**
- Endpoints return bare DTOs (`List<TodoDto>`, `LoginResponse`). Fine for
  jsonplaceholder, but there's no `ApiResponse<T>` / `PaginatedResponse<T>`
  for a real backend that wraps payloads or paginates. **Fix:** introduce
  optional generic envelope + pagination model (see 1.4).

**P3 — No retry / no connectivity short-circuit**
- No retry-with-backoff interceptor for transient 5xx/timeouts on
  idempotent GETs. `connectivity_service` exists but isn't wired into the
  request path, so offline requests wait for a full timeout instead of
  failing fast as `NoConnectionFailure`.

**P3 — `validateStatus` not customized**
- Default Dio treats all non-2xx as errors, so 4xx bodies are only
  reachable via `DioException.response`. If we want to parse error
  envelopes uniformly, consider `validateStatus` + explicit handling.

**P3 — Dynamic dispatch in the interceptor**
- `auth_interceptor.dart` calls `refreshAccessToken()` via `dynamic` to
  avoid importing `features/auth/data`. It works and is deliberate (keeps
  `core/network` decoupled), but it's compile-time-unsafe and leans on the
  disabled `avoid_dynamic_calls` rule. A small typed contract in `core`
  (e.g. `TokenRefresher` interface) would remove the `dynamic` while
  preserving decoupling.

**P3 — Stale-token race during refresh window**
- `onRequest` reads the access token from storage per request. A request
  that starts after a 401 is detected but before refresh writes the new
  token can still attach the old token (then 401 → dedup → retry). Correct
  but wasteful. A "pause requests while refreshing" gate would be tighter.

### 2.3 Quick wins vs. larger efforts

- **Quick (low risk, high value):** P1 refresh auth-exempt flag; P1
  persistent-401 sign-out; P2 add `CancelledFailure` + fix comment.
- **Medium:** P2 richer `Failure` hierarchy + server-envelope parsing;
  update mapper + UI messages + localization keys.
- **Larger / decision-first:** P0 doctrine reconciliation (docs + rules +
  CODEOWNERS); P2 `ApiResponse<T>`/pagination; P3 retry + connectivity
  interceptors; P3 typed `TokenRefresher` to drop `dynamic`.

---

## Part 3 — Proposed execution order (after sign-off)

1. **P0 decision** — ratify or revert the Retrofit/codegen migration;
   update `AGENTS.md`, `docs/agents/networking.md`, and code-ownership
   notes to match reality. (Blocks everything else conceptually.)
2. **P1 auth correctness** — refresh auth-exempt marker + persistent-401
   sign-out, with interceptor tests.
3. **P2 error model** — expand `Failure`, rewrite `dio_failure_mapper`,
   add server-envelope parsing, wire localized messages.
4. **P2 response model** — optional `ApiResponse<T>` + `PaginatedResponse<T>`.
5. **P3 resilience** — retry-with-backoff + connectivity interceptors;
   typed `TokenRefresher`; refresh-window request gating.

Each step ships with the pre-PR gate green: `fvm dart format
--set-exit-if-changed .`, `fvm flutter analyze`, `fvm flutter test`, and a
`fvm dart run build_runner build --delete-conflicting-outputs` for codegen.
