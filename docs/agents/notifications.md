# Notifications (FCM)

> Firebase Cloud Messaging routed through `FcmNotificationService`.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## Single-funnel rule

Notification handlers **must not** call `Navigator` or `context.go` directly. They emit a `RouteDescriptor`; the router consumes it (see [deep-links.md](./deep-links.md)).

## FcmNotificationService

`lib/core/notifications/fcm_notification_service.dart` is the only place that knows about FCM primitives (`RemoteMessage`, `onMessage`, `onMessageOpenedApp`). It maps a payload to a `RouteDescriptor`.

```dart
abstract interface class FcmNotificationService {
  Future<void> initialize();
  Stream<RouteDescriptor> get onTap;  // user tapped a notification
}
```

## Payload shape

Keep payload schemas small and stable. Recommended:

```json
{
  "type": "todo_assigned",
  "todoId": "abc123"
}
```

`type` maps to a known `*Routes` constant. Unknown types are logged via `AppLogger` and dropped.

## Initialization

`FcmNotificationService.initialize()` is called from `bootstrap.dart` (Flavor-aware — dev/staging can point at a sandbox project). It requests permission and subscribes to topics.

## Background messages

Top-level `firebase_messaging` background handler runs **outside** Riverpod — it should post a `RouteDescriptor` via a top-level `AppRouter.handleDeepLink` or a static handler, never via `context.go`.

## Related

- [deep-links.md](./deep-links.md) — the funnel that consumes `RouteDescriptor`s.
- [logger.md](./logger.md) — AppLogger is where unknown types are logged.
- [../../AGENTS.md](../../AGENTS.md) — index.
