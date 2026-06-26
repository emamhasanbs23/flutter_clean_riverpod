// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_notification_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fcmNotificationServiceHash() =>
    r'6322adbacf740631b7d08667f57b1308c7306017';

/// Provider that wires the FCM-backed service. Bootstrap overrides
/// `notificationServiceProvider` with this in flavors where Firebase has
/// been configured.
///
/// Copied from [fcmNotificationService].
@ProviderFor(fcmNotificationService)
final fcmNotificationServiceProvider = Provider<NotificationService>.internal(
  fcmNotificationService,
  name: r'fcmNotificationServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fcmNotificationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FcmNotificationServiceRef = ProviderRef<NotificationService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
