import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/notifications/notification_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/route_descriptor.dart';

/// Default no-op [NotificationService] used by unit tests and any flavor
/// that hasn't wired FCM yet.
///
/// `onTap` is an empty broadcast stream; `initialize` and
/// `requestPermission` are no-ops.
class NoOpNotificationService implements NotificationService {
  const NoOpNotificationService();

  @override
  Stream<RouteDescriptor> get onTap => const Stream<RouteDescriptor>.empty();

  @override
  Future<String?> requestPermission() async => null;

  @override
  Future<void> initialize() async {}
}

/// Provider entry point for [NotificationService]. Default is the
/// [NoOpNotificationService]; the FCM-backed implementation overrides
/// this in production.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return const NoOpNotificationService();
});
