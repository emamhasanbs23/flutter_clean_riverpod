# Error Handling

> Errors are values, not exceptions. Domain/data return `Either<Failure, T>`.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## Why values, not exceptions

Throwing crosses architectural boundaries invisibly. Returning `Either` makes the failure path explicit at every call site and is checked by the type system.

## The `Failure` hierarchy

A sealed hierarchy lives in `lib/core/error/failures.dart`:

```dart
sealed class Failure { const Failure(this.message); final String message; }
class NetworkFailure    extends Failure { ... }
class ServerFailure     extends Failure { ... }
class AuthFailure       extends Failure { ... }
class ValidationFailure extends Failure { ... }
class CacheFailure      extends Failure { ... }
class UnknownFailure    extends Failure { ... }
```

Add new failure types as new sealed subclasses; consumers' `switch` will tell you where to handle them.

## Where it's used

- **Repository contracts** return `Future<Either<Failure, T>>`.
- **Use cases** pass through (no extra try/catch unless transforming).
- **Controllers** (`Notifier`) map `Failure` → a sealed UI state (e.g. `FeatureError(f)`).
- **Widgets** read the UI state and call `context.l10n.failureMessage(f)` for copy.

## Dio → Failure mapping

`lib/core/error/dio_failure_mapper.dart` converts `DioException` → `Failure`. The mapper lives next to the failure hierarchy because the mapping is a pure function.

```dart
Failure mapDioToFailure(DioException e) => switch (e.type) {
  DioExceptionType.connectionTimeout => const NetworkFailure('timeout'),
  DioExceptionType.badResponse        => ServerFailure(statusCode: e.response?.statusCode ?? 0),
  // ...
  _                                   => UnknownFailure(e.message ?? 'unknown'),
};
```

## What may throw

- Programmer errors (asserts, state misuse).
- `bootstrap.dart` during startup (DI failures should crash visibly).
- Test files (asserts/expectations are fine).

UI catches **nothing** — by the time a value reaches the widget, it's already a `FeatureLoaded` or a `FeatureError`.

## Related

- [networking.md](./networking.md) — Dio + interceptor where failures originate.
- [state-management.md](./state-management.md) — sealed UI states consuming `Failure`.
- [testing.md](./testing.md) — `EitherAssertions` for asserting on Left values.
- [../../AGENTS.md](../../AGENTS.md) — index.
