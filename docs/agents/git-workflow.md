# Git Workflow

> Conventional Commits, short-lived branches, pre-PR gates, CODEOWNERS auto-assignment.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## Branches

```
feature/<short-desc>
fix/<short-desc>
chore/<short-desc>
```

No long-lived personal branches. Rebase onto `main` before opening a PR.

## Commits — Conventional Commits

```
feat: add todo assignment notification
fix: handle 401 burst in AuthInterceptor
refactor: extract RouteDescriptor whitelist
test: cover mapper missing-field cases
docs: add AGENTS.md
chore: bump flutter_launcher_icons
```

Subject ≤ 72 chars, imperative mood, no trailing period.

## Pre-PR checklist (must pass locally)

```bash
fvm dart format --set-exit-if-changed .
fvm flutter analyze
fvm flutter test
```

CI runs the same gates — see [ci.md](./ci.md).

## PRs

- Target `main`.
- CODEOWNERS auto-assigns reviewers for sensitive paths — see [code-ownership.md](./code-ownership.md).
- Reference the issue in the description (`Closes #123`).
- One logical change per PR.

## Releases

Only `release*` tag pushes trigger CI builds (format, analyze, unit tests, Android dev smoke). See [ci.md](./ci.md).

## Related

- [commands.md](./commands.md) — exact CLI invocations.
- [ci.md](./ci.md) — what the pipeline runs.
- [code-ownership.md](./code-ownership.md) — sensitive paths.
- [../../AGENTS.md](../../AGENTS.md) — index.
