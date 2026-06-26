# Networking (Dio + AuthInterceptor)

> Centralized Dio with refresh-token dedup. **Code-owner gated.**
> Part of the [AGENTS.md](../../AGENTS.md) index.

## Files

```
lib/core/network/
├── dio_client.dart            # builds the Dio instance, attaches interceptors
└── auth_interceptor.dart      # 401 → dedup → retry once → onSessionExpired
```

Both files are sensitive — see [code-ownership.md](./code-ownership.md).

## AuthInterceptor — 401 flow

1. `AuthInterceptor` catches the `DioException` (status 401).
2. If a refresh is already in flight, the request **queues** and waits on the same `Completer`.
3. Otherwise it calls the refresh endpoint, **exactly once** per 401 burst.
4. On refresh success → original request is retried with the new token.
5. On refresh failure → `onSessionExpired` callback fires (set in `bootstrap.dart`):
   - Clears secure storage.
   - Notifies the auth Riverpod provider.
   - Router redirects to `AuthRoutes.login` via the existing redirect logic (see [navigation.md](./navigation.md)).

## Why dedup matters

Without dedup, N concurrent 401s trigger N refresh calls — token rotation races, and the user can end up with a token the server no longer accepts. The interceptor enforces a single refresh per burst.

## Extending the interceptor

- Keep the dedup logic intact.
- Don't add per-call refresh attempts.
- All callers still see a single, consistent `Either<Failure, T>` from their repository call.
- Don't log full tokens; log token presence + request id only.

## Error mapping

`DioException` → `Failure` happens in `lib/core/error/dio_failure_mapper.dart`. The interceptor doesn't fabricate failures — it lets the mapper produce the typed `Failure` on the original response (after retry).

## Related

- [auth-refresh.md](./auth-refresh.md) — the dedicated deep-dive on the 401 flow.
- [error-handling.md](./error-handling.md) — `Failure` hierarchy and Dio mapper.
- [code-ownership.md](./code-ownership.md) — who reviews changes here.
- [../../AGENTS.md](../../AGENTS.md) — index.
