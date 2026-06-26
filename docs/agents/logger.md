# Logging (AppLogger)

> All logging goes through `AppLogger`. No `print` / `debugPrint` outside tests.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## Where it lives

`lib/core/logger/app_logger.dart` — a thin wrapper around the `logger` package.

## Usage

```dart
AppLogger.info('Loaded todos', tag: 'TodoController');
AppLogger.warn('Unknown deep link path', tag: 'DeepLink', data: {'path': path});
AppLogger.error('Refresh failed', tag: 'AuthInterceptor', error: e);
```

## Rules

- No `print(...)` or `debugPrint(...)` in production code.
- Tests may use `print` (asserts/log diagnostics).
- Don't log tokens, refresh responses, or anything sensitive — log token **presence** only.
- Tag every log with the producing class/feature for grep-ability.

## Related

- [deep-links.md](./deep-links.md) — unknown paths land here.
- [auth-refresh.md](./auth-refresh.md) — refresh failures land here.
- [../../AGENTS.md](../../AGENTS.md) — index.
