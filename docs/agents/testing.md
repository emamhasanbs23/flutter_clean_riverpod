# Testing

> `mocktail` + `EitherAssertions`. No codegen.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## Stack

- **mocktail** for mocks (no `build_runner`, no `mockito`).
- **Manual `Mock` classes** — explicit, no annotations.
- **`EitherAssertions`** in `test/helpers/` for asserting on `Either` values.

## Command

```bash
fvm flutter test
```

Or a single file:

```bash
fvm flutter test test/features/todo/todo_repository_impl_test.dart
```

## EitherAssertions

```dart
expectRight(result, predicate: (todo) => todo.id == 'abc');
expectLeft(result, failureOfType: NetworkFailure);
expectFailureOfType<AuthFailure>(result);
```

See `test/helpers/either_assertions.dart` for the full surface.

## Repository tests

Cover the success path **and** every `Failure` subclass the repository can emit:

```dart
test('returns Right(Todo) on 200', () async { ... });
test('returns Left(NetworkFailure) on timeout', () async { ... });
test('returns Left(ServerFailure(401)) on auth', () async { ... });
```

## Mapper tests

- DTO → entity (happy path).
- Entity → DTO.
- Missing-field / null-field edge cases.

## Controller tests (Riverpod notifiers)

One test per sealed-state transition:

```dart
test('emits FeatureLoading then FeatureLoaded on success', () async { ... });
test('emits FeatureError(NetworkFailure) on failure', () async { ... });
```

## Widget tests

Per page, smoke-test the three shapes:

- Loading state renders.
- Error state renders.
- At least one data state renders.

```dart
await tester.pumpWidget(
  ProviderScope(
    overrides: [
      repositoryProvider.overrideWithValue(mockRepo),
    ],
    child: const MyApp(),
  ),
);
```

No golden tests — keep the suite fast and stable.

## Coverage targets (informal)

- Repositories: success + every Failure subclass.
- Mappers: DTO ↔ entity + edge cases.
- Controllers: every sealed-state transition.
- Widgets: smoke per page.

## Related

- [state-management.md](./state-management.md) — provider overrides.
- [error-handling.md](./error-handling.md) — `Failure` types you'll assert against.
- [commands.md](./commands.md) — quality gates.
- [../../AGENTS.md](../../AGENTS.md) — index.
