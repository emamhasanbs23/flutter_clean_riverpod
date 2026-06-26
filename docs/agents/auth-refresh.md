# Auth Refresh Flow

> The 401 → dedup → retry once → `onSessionExpired` pipeline.
> Code-owner gated. Part of the [AGENTS.md](../../AGENTS.md) index.

## End-to-end flow

```
request ──► Dio ──► AuthInterceptor ──► remote
                  ▲
                  └── 401?

on 401:
  ├─ refresh in flight? ──► queue, wait on shared Completer
  └─ otherwise ──► call refresh endpoint (exactly once)

on refresh success:
  └─ retry original request with new token

on refresh failure:
  └─ onSessionExpired()
       ├─ clear secure storage
       ├─ notify auth Riverpod provider
       └─ router redirects to AuthRoutes.login
```

## Code-owner gating

`lib/core/network/dio_client.dart` and `lib/core/network/auth_interceptor.dart` are listed in `CODEOWNERS`. Any change must be reviewed by the security/networking owner — see [code-ownership.md](./code-ownership.md).

## Why the dedup is non-negotiable

Multiple in-flight 401s would otherwise trigger parallel refresh calls, racing the token rotation. The single-Completer pattern guarantees:

- Exactly **one** refresh call per 401 burst.
- All queued requests resume against the **same** rotated token.
- A single failure path (no "some requests succeeded, some didn't").

## onSessionExpired wiring

`bootstrap.dart` registers the callback. It must:

1. Clear `SecureStorageService` keys.
2. Notify the auth Riverpod provider (sets `unauthenticated`).
3. Let the existing router redirect handle navigation to `AuthRoutes.login` (see [navigation.md](./navigation.md)).

The interceptor itself does **not** navigate — single-funnel rule applies.

## Rules when extending

- Keep the dedup logic intact.
- Do not add per-call refresh attempts.
- Don't catch the 401 inside the interceptor and silently succeed — surface it.
- Don't log tokens; log presence + request id only.
- Tests for the interceptor must cover: no-401 pass-through, single-refresh-on-burst, queue-await, onSessionExpired on refresh failure.

## Related

- [networking.md](./networking.md) — Dio + interceptor overview.
- [navigation.md](./navigation.md) — where the redirect lands.
- [code-ownership.md](./code-ownership.md) — review requirements.
- [../../AGENTS.md](../../AGENTS.md) — index.
