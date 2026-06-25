import 'dart:async';

import 'package:flutter_clean_riverpod_boilerplate/core/notifications/route_descriptor.dart';

/// Cross-platform abstraction over push notifications.
///
/// The boilerplate wires FCM through this interface; tests use the
/// `NoOpNotificationService` (in
/// `core/notifications/no_op_notification_service.dart`) so widget tests
/// don't need a Firebase project.
///
/// The service emits parsed [RouteDescriptor]s on [onTap] so the rest of
/// the app stays platform-agnostic — the FCM impl translates `data`
/// payloads into descriptors before they leave the service.
abstract interface class NotificationService {
  /// Fires whenever the user taps a notification. Includes cold-start
  /// taps (i.e. the app was launched by a tap): those are replayed once
  /// when `initialize` is called.
  Stream<RouteDescriptor> get onTap;

  /// Asks the OS for permission to display notifications. Returns the
  /// granted permission string (`'granted'`, `'denied'`, ...) or `null`
  /// if the platform doesn't support the concept (e.g. Android < 13).
  Future<String?> requestPermission();

  /// One-time setup: requests permission, subscribes to tap events, and
  /// registers the token with the backend. The default no-op
  /// implementation does nothing.
  Future<void> initialize();
}
