# Task: Add a new API endpoint

> Goal: add a method to an existing data source without breaking the
> repository contract.

## Preconditions

- Endpoint spec (path, method, request body, response shape).
- Failure modes identified (network, server, auth, validation).

## Steps

1. **DTO**: extend `lib/data/<feature>/model/<feature>_dto.dart`
   or add a sibling DTO file. Hand-written `fromJson` / `toJson`. No
   `json_serializable`.
2. **Mapper**: extend `<feature>_mapper.dart` with the new
   `fromDto` / `toDto`. Pure functions only.
3. **Remote data source**: add the method to `*_remote_data_source.dart`.
   Use the shared `dioClientProvider`. Map `DioException` → `Failure`
   via `dio_failure_mapper.dart`. See [error-handling.md](../agents/error-handling.md).
4. **Repository contract**: add the method to the abstract
   `*_repository.dart` returning `Future<Either<Failure, T>>`.
5. **Repository impl**: implement in `*_repository_impl.dart`.
6. **Use case** (if needed): one-method class named `<verb><Noun>`.
7. **Tests**:
   - Mapper: DTO → entity + missing-field edges.
   - Repository: success + every `Failure` subclass it can emit. See
     [testing.md](../agents/testing.md).

## What you may NOT do

- ❌ Throw from repository / data source / use case.
- ❌ Import a DTO from `domain/`.
- ❌ Add `build_runner` / `json_serializable`.
- ❌ Catch `DioException` outside `dio_failure_mapper.dart` and the
  interceptor (see [networking.md](../agents/networking.md)).

## Done criteria

- [ ] Domain layer has no Dart-IO / Dio / Flutter imports.
- [ ] Repository returns `Either<Failure, T>`.
- [ ] All mappers covered by tests.

## Related

- [networking.md](../agents/networking.md) — Dio + interceptor.
- [error-handling.md](../agents/error-handling.md) — `Failure` types.
- [testing.md](../agents/testing.md) — repository test patterns.
