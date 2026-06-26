# Task: Add a new deep-linkable route

> Goal: register a new typed route that opens from a notification or
> app-link, with auth + whitelist enforcement.

## Preconditions

- Route name decided (`<Feature>Routes.<name>`).
- Path is unique, alphanumeric + `/` only.
- Auth requirement decided (public vs protected).

## Steps

1. **Typed name**: extend the relevant `*Routes` class in
   `lib/core/router/route_descriptor.dart`.
   ```dart
   abstract final class TodoRoutes {
     static const list   = 'todo/list';
     static const detail = 'todo/detail';
   }
   ```
2. **Whitelist**: add the path matcher in `route_descriptor.dart`:
   ```dart
   bool isWhitelistedDeepLink(String path) =>
       path.startsWith(AuthRoutes.login) ||
       path.startsWith(TodoRoutes.list) ||
       path.startsWith(TodoRoutes.detail);
   ```
3. **Router**: register the `GoRoute` in `app_router.dart`. If protected,
   place it in the auth-gated branch — the existing `redirect` handles
   the gating.
4. **Producer mapping**: if the source is FCM, extend
   `FcmNotificationService` payload → `RouteDescriptor` mapping. If
   `AppLinks`, the service auto-routes via `pendingNavigationProvider`.
5. **Tests**:
   - Unknown path → dropped + logged (`AppLogger`).
   - Whitelisted path → consumed.
   - Auth-gated path while unauthenticated → redirect to login.

## What you may NOT do

- ❌ Navigate from notification/handler code directly (`context.go`).
- ❌ Add a path that's not in the whitelist.
- ❌ Bypass the existing `redirect` callback.

## Done criteria

- [ ] Typed route constant exists.
- [ ] Whitelist updated.
- [ ] Router registered.
- [ ] Tests cover whitelist + auth gating.

## Related

- [deep-links.md](../agents/deep-links.md) — the funnel.
- [navigation.md](../agents/navigation.md) — typed names + redirect.
- [notifications.md](../agents/notifications.md) — FCM payload mapping.
