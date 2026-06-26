# Navigation

> GoRouter with typed route-name constants. No raw paths outside `app_router.dart`.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## Typed route names

Each feature owns a `*Routes` class in `lib/core/router/route_descriptor.dart`:

```dart
abstract final class AuthRoutes {
  static const login = 'auth/login';
}
abstract final class TodoRoutes {
  static const list   = 'todo/list';
  static const detail = 'todo/detail';
}
abstract final class HomeRoutes { ... }
```

Widgets and controllers **only** navigate via these constants:

```dart
context.goNamed(TodoRoutes.detail, pathParameters: {'id': id});
```

## Why typed names

- Single grep target when renaming.
- Compile-time check that the route exists.
- Whitelist for deep-link validation (see [deep-links.md](./deep-links.md)).

## Router file

`lib/core/router/app_router.dart` is the only place that calls `GoRoute(path: ...)`. It maps every typed name to a concrete path and wires auth gating.

## Auth gating

`app_router.dart` `redirect` callback enforces the auth rule:

1. If unauthenticated and route requires auth → redirect to `AuthRoutes.login`.
2. If authenticated and on `AuthRoutes.login` → redirect to `TodoRoutes.list`.
3. Otherwise → allow.

This runs **after** the deep-link redirect from `pendingNavigationProvider`.

## Adding a new route

1. Add a typed constant to the relevant `*Routes` class.
2. Register the `GoRoute` in `app_router.dart`.
3. If it needs auth gating, decide whether it should sit in the public or protected branch.
4. If it's deep-linkable, also update `route_descriptor.dart`'s whitelist (see [deep-links.md](./deep-links.md)).
5. Add ARB strings for any landing-screen copy.

## Related

- [deep-links.md](./deep-links.md) — the single-funnel flow that ends at this router.
- [auth-refresh.md](./auth-refresh.md) — how a 401 turns into a redirect to login.
- [../../AGENTS.md](../../AGENTS.md) — index.
