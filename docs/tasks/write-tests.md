# Task: Write tests for a feature / controller / mapper

> Goal: cover the right surfaces with the right depth using the project's
> standard stack.

## Stack

- **mocktail** for mocks (no `mockito`, no `build_runner`).
- **`EitherAssertions`** in `test/helpers/` for `Either` values.
- **`ProviderScope.overrides`** to inject mocked providers. See
  [state-management.md](../agents/state-management.md).

## Per-surface checklist

### Repository

- [ ] Success path returns `Right(T)`.
- [ ] Each `Failure` subclass the repo can emit returns `Left(...)`.

### Mapper

- [ ] DTO → entity (happy path).
- [ ] Entity → DTO.
- [ ] Missing / null / wrong-type field edges.

### Controller (Riverpod `Notifier`)

- [ ] Initial state.
- [ ] One test per sealed-state transition (loading → loaded, loading → error).

### Widget

- [ ] Smoke test per page: loading renders, error renders, one data state
  renders.
- [ ] No golden tests.

## Done criteria

- [ ] All tests pass: `fvm flutter test`.
- [ ] No new dev_dependency added.
- [ ] No `build_runner` introduced.

## Related

- [testing.md](../agents/testing.md) — full conventions.
- [state-management.md](../agents/state-management.md) — provider overrides.
- [error-handling.md](../agents/error-handling.md) — `Failure` hierarchy.
