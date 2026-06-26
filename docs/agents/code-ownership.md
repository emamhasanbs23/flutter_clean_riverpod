# Code Ownership (CODEOWNERS)

> Sensitive paths require a code-owner review.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## Gated paths

```
/lib/core/network/        @security-owner @networking-owner
/lib/core/storage/        @security-owner
/lib/features/auth/       @security-owner
/android/app/build.gradle.kts  @mobile-owner
/.github/                 @platform-owner
```

(Verify the exact owners in `CODEOWNERS` — the list above is the canonical pattern.)

## Why these are gated

| Path                          | Why it's sensitive                                               |
|-------------------------------|------------------------------------------------------------------|
| `lib/core/network/`           | Auth refresh, token rotation, dedup logic. One bug = lockouts.   |
| `lib/core/storage/`           | Secure-storage keys, token persistence.                          |
| `lib/features/auth/`          | Login flows, session lifecycle.                                  |
| `android/app/build.gradle.kts`| Signing config, flavors, SDK versions.                           |
| `.github/`                    | CI pipeline — a bad change ships a broken release.              |

## What "code-owner gated" means in practice

- PRs touching these paths auto-assign the owner(s).
- The owner must approve before merge.
- Trivial changes (typo, comment) still need owner approval — keep the gating uniform.

## When you need to touch these paths

1. Open the PR with a clear description of the security/infra impact.
2. Reference any related issue or design doc.
3. Wait for owner review. Don't self-merge even with green CI.

## Related

- [auth-refresh.md](./auth-refresh.md) — what's gated in `core/network/`.
- [networking.md](./networking.md) — Dio + interceptor overview.
- [ci.md](./ci.md) — CI pipeline that the owner maintains.
- [../../AGENTS.md](../../AGENTS.md) — index.
