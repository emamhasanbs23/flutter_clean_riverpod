# Deep Links & Push Notifications

> Single funnel: producers emit `RouteDescriptor`; `pendingNavigationProvider` holds the latest; `AppRouter` consumes via its `redirect`.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## The funnel

```
FcmNotificationService ─┐
                         ├─► pendingNavigationProvider ─► AppRouter redirect
AppLinksDeepLinkService ─┘
```

- Producers (`FcmNotificationService`, `AppLinksDeepLinkService`) emit a `RouteDescriptor` (path + optional params + source tag).
- `pendingNavigationProvider` exposes the latest pending route.
- `AppRouter` consumes it via its `redirect` callback, after applying the **whitelist rule**: only paths that match an entry in `lib/core/router/route_descriptor.dart` are accepted. Unknown paths are dropped and logged via `AppLogger`.

## Why single funnel

Multiple navigation entrypoints (notification handler calls `context.go`, deep-link service calls `context.go`) race and bypass auth gating. A single funnel keeps auth redirect logic in **one** place.

## Whitelist rule

A path is accepted **only** if it's declared in `route_descriptor.dart`. Example:

```dart
// in route_descriptor.dart
bool isWhitelistedDeepLink(String path) =>
    path.startsWith(AuthRoutes.login) ||
    path.startsWith(TodoRoutes.list) ||
    path.startsWith(TodoRoutes.detail);
```

## Producers — do's and don'ts

| Do                                                       | Don't                                |
|----------------------------------------------------------|--------------------------------------|
| Emit a `RouteDescriptor` and stop.                       | Call `context.go` / `Navigator.push`. |
| Validate the path against the whitelist before emitting. | Emit arbitrary paths from a payload. |
| Log unknown paths via `AppLogger`.                       | Silently drop.                       |

## Adding a new deep-linkable route

1. Add a typed constant in the relevant `*Routes` class (see [navigation.md](./navigation.md)).
2. Add the whitelist entry in `route_descriptor.dart`.
3. If the route needs auth gating, the existing `redirect` logic handles it once it's a known path.
4. Add ARB strings for any landing-screen copy (see [localization.md](./localization.md)).

## Related

- [notifications.md](./notifications.md) — FCM payload mapping.
- [navigation.md](./navigation.md) — the consumer of the funnel.
- [auth-refresh.md](./auth-refresh.md) — session-expired redirect runs in the same `redirect` callback.
- [logger.md](./logger.md) — where unknown paths are logged.
- [../../AGENTS.md](../../AGENTS.md) — index.
