# Changelog

All notable changes to `flutter_clean_riverpod_boilerplate` are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the
project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Real Dio-backed `AuthRemoteDataSource` and `TodoRemoteDataSource` (jsonplaceholder).
- `AuthInterceptor` with single-flight refresh + retry + onSessionExpired callback.
- `Failure.toMessage(context)` localised failure rendering at the UI layer.
- `AppCustomTextStyles.strikeThrough` for completed list items (replaces inline
  `TextStyle`).
- Provider overrides for `crashReporter`, `analytics`, `dioAuthRepositoryBuilder`,
  and `sessionExpiredSignal` so tests / different deployments can swap them out.
- `runZonedGuarded` + global error pipeline in `bootstrap.dart` that dispatches to
  `crashReporter.reportError`.
- Per-flavor iOS build (Dev / Staging / Prod) with distinct bundle IDs, display names,
  and Xcode schemes.
- Android `signingConfigs.release` reading from `key.properties`; ProGuard rules for
  Dio, fpdart, Flutter.
- `Env` static fields reading from `--dart-define` (`BASE_URL`, `APP_NAME`,
  `DIO_LOGGING`).
- `env.{dev,staging,prod}.json` templates.
- Unit tests for `AuthInterceptor`, `AuthRepositoryImpl`, `TodoRepositoryImpl`,
  `GetTodosUseCase`, `CreateTodoUseCase`, `ToggleTodoUseCase`, `DeleteTodoUseCase`,
  `LoginController`, `TodoListController`, and the `authRedirect` decision function.

### Changed
- `LoginController` carries a typed `Failure` instead of a pre-localized string.
- `TodoListController.add` trims whitespace and re-uses the trimmed title with the
  use case.
- `DioClient` no longer imports `features/auth/data` — it gets the auth repository
  via a deferred `DioAuthRepositoryBuilder` callback to keep layers acyclic.

### Removed
- `riverpod_annotation`, `riverpod_generator`, `riverpod_lint`, `custom_lint`
  dependencies. Hand-written providers only.

## [0.1.0] — 2024-01-01

Initial scaffold: Clean Architecture (data / domain / presentation), Riverpod 2,
GoRouter with auth redirect, Dio with a stub `AuthInterceptor`, Material 3 theme
extensions, secure-storage-backed auth, todo CRUD against an in-memory data
source, `Failure` sealed hierarchy, ARB-based localisation (en + es), and the
base CI workflow.