import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/logger/app_logger.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/notification_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/route_descriptor.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/route_descriptor_parser.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fcm_notification_service.g.dart';

/// Firebase Cloud Messaging-backed [NotificationService].
///
/// Responsibilities:
/// - Initialize the [Firebase] app lazily. The boilerplate's bootstrap
///   guards this on the presence of platform config so unit tests +
///   contributors without `google-services.json` don't crash.
/// - Request notification permission on first launch (iOS / Android 13+).
/// - Forward `onMessageOpenedApp` events (user taps while app is in the
///   background) to [onTap].
/// - Replay the cold-start message (`getInitialMessage`) once on
///   [initialize] so a tap that launched the app from terminated state
///   lands correctly.
class FcmNotificationService implements NotificationService {
  FcmNotificationService({
    FirebaseMessaging? messaging,
    FirebaseOptions? options,
  }) : _messaging = messaging,
       _options = options;

  final FirebaseMessaging? _messaging;
  final FirebaseOptions? _options;

  StreamController<RouteDescriptor>? _tapController;
  StreamSubscription<RemoteMessage>? _onOpenedSub;

  @override
  Stream<RouteDescriptor> get onTap {
    _tapController ??= StreamController<RouteDescriptor>.broadcast(
      onListen: _ensureSubscriptions,
    );
    return _tapController!.stream;
  }

  @override
  Future<void> initialize() async {
    try {
      // Ensure Firebase is initialised. The platform options file
      // (google-services.json / GoogleService-Info.plist) is auto-loaded
      // when present; otherwise callers may pass [options] explicitly.
      if (Firebase.apps.isEmpty) {
        if (_options != null) {
          await Firebase.initializeApp(options: _options);
        } else {
          await Firebase.initializeApp();
        }
      }
    } on Object catch (error, stack) {
      AppLogger.w(
        'Firebase.initializeApp failed; push notifications disabled',
        error: error,
        stackTrace: stack,
      );
      return;
    }

    _ensureSubscriptions();

    // Cold-start tap: app was launched by the user tapping a notification
    // while the app was terminated.
    final initial = await _messagingInstance.getInitialMessage();
    if (initial != null) {
      _emitFor(initial);
    }
  }

  @override
  Future<String?> requestPermission() async {
    try {
      final settings = await _messagingInstance.requestPermission();
      return settings.authorizationStatus.name;
    } on Object catch (error, stack) {
      AppLogger.w('requestPermission failed', error: error, stackTrace: stack);
      return null;
    }
  }

  void _ensureSubscriptions() {
    if (_onOpenedSub != null) return;
    // `FirebaseMessaging.onMessageOpenedApp` is a static stream on the
    // platform class, so we don't need an instance to subscribe.
    _onOpenedSub = FirebaseMessaging.onMessageOpenedApp.listen(_emitFor);
  }

  void _emitFor(RemoteMessage message) {
    final data = <String, Object?>{
      ...message.data,
      // Fall back to notification title if the payload didn't carry a
      // `route` field. We only USE this as a hint — the parser still
      // requires `route` to be present and well-formed.
    };
    final descriptor = RouteDescriptorParser.parsePushPayload(data);
    if (descriptor == null) {
      AppLogger.i(
        'Ignoring notification with no route: '
        'id=${message.messageId} data=${message.data}',
      );
      return;
    }
    AppLogger.i('Notification tap routed to: $descriptor');
    _tapController?.add(descriptor);
  }

  FirebaseMessaging get _messagingInstance {
    final injected = _messaging;
    if (injected != null) return injected;
    return FirebaseMessaging.instance;
  }

  Future<void> dispose() async {
    await _onOpenedSub?.cancel();
    _onOpenedSub = null;
    await _tapController?.close();
    _tapController = null;
  }
}

/// Provider that wires the FCM-backed service. Bootstrap overrides
/// `notificationServiceProvider` with this in flavors where Firebase has
/// been configured.
@Riverpod(keepAlive: true)
NotificationService fcmNotificationService(Ref ref) {
  final service = FcmNotificationService();
  ref.onDispose(service.dispose);
  return service;
}
