// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_notification_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that wires the FCM-backed service. Bootstrap overrides
/// `notificationServiceProvider` with this in flavors where Firebase has
/// been configured.

@ProviderFor(fcmNotificationService)
final fcmNotificationServiceProvider = FcmNotificationServiceProvider._();

/// Provider that wires the FCM-backed service. Bootstrap overrides
/// `notificationServiceProvider` with this in flavors where Firebase has
/// been configured.

final class FcmNotificationServiceProvider
    extends
        $FunctionalProvider<
          NotificationService,
          NotificationService,
          NotificationService
        >
    with $Provider<NotificationService> {
  /// Provider that wires the FCM-backed service. Bootstrap overrides
  /// `notificationServiceProvider` with this in flavors where Firebase has
  /// been configured.
  FcmNotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fcmNotificationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fcmNotificationServiceHash();

  @$internal
  @override
  $ProviderElement<NotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationService create(Ref ref) {
    return fcmNotificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationService>(value),
    );
  }
}

String _$fcmNotificationServiceHash() =>
    r'6322adbacf740631b7d08667f57b1308c7306017';
