# Task: Investigate a 401 storm / auth outage

> Goal: triage when users are being logged out unexpectedly or auth
> refresh appears broken.

> ⚠️ Code in `lib/core/network/` and `lib/features/auth/` is
> **code-owner gated** — see
> [code-ownership.md](../agents/code-ownership.md). Open a PR; don't
> hot-fix.

## Preconditions

- Repro or clear log evidence of the issue.
- Reproduce locally against dev flavor.

## Triage steps

1. **Logs**: pull `AppLogger` output filtered by tag `AuthInterceptor`.
   Look for:
   - Repeated refresh attempts in a single burst (dedup broken).
   - Refresh failures followed by `onSessionExpired` (expected path).
   - 401 after refresh success (token not applied to retry).
2. **Network**: confirm the refresh endpoint is reachable in the
   targeted flavor (env var / baseUrl). See
   [flavors.md](../agents/flavors.md).
3. **Storage**: verify `SecureStorageService` returns the latest token
   after refresh. Don't log the token; log presence only — see
   [logger.md](../agents/logger.md).
4. **Dedup**: confirm the interceptor's `Completer` is shared across
   concurrent 401s. See
   [auth-refresh.md](../agents/auth-refresh.md).

## Fix candidates

| Symptom                                | Likely cause                                |
|----------------------------------------|---------------------------------------------|
| N refreshes per 401 burst              | Dedup `Completer` was removed/bypassed.     |
| 401 after successful refresh           | Retry didn't apply the new token header.    |
| Random `onSessionExpired` for some users only | Server-side rotation; check refresh response shape. |
| All users logged out                   | Bad refresh-token deployment; check env.    |

## Escalation

- If `core/network/` change is required: open PR, request
  `@security-owner` / `@networking-owner` review.
- If `features/auth/` change is required: same.
- If env-only: see [add-env-var.md](./add-env-var.md).

## Done criteria

- [ ] Root cause identified.
- [ ] Test added (or updated) for the regression.
- [ ] PR opened with code-owner review.

## Related

- [auth-refresh.md](../agents/auth-refresh.md) — flow + invariants.
- [networking.md](../agents/networking.md) — interceptor overview.
- [code-ownership.md](../agents/code-ownership.md) — review gate.
- [logger.md](../agents/logger.md) — what to log, what not to.
