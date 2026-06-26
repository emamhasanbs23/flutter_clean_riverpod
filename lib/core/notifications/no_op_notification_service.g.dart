// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'no_op_notification_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider entry point for [NotificationService]. Default is the
/// [NoOpNotificationService]; the FCM-backed implementation overrides
/// this in production.

@ProviderFor(notificationService)
final notificationServiceProvider = NotificationServiceProvider._();

/// Provider entry point for [NotificationService]. Default is the
/// [NoOpNotificationService]; the FCM-backed implementation overrides
/// this in production.

final class NotificationServiceProvider
    extends
        $FunctionalProvider<
          NotificationService,
          NotificationService,
          NotificationService
        >
    with $Provider<NotificationService> {
  /// Provider entry point for [NotificationService]. Default is the
  /// [NoOpNotificationService]; the FCM-backed implementation overrides
  /// this in production.
  NotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationServiceHash();

  @$internal
  @override
  $ProviderElement<NotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationService create(Ref ref) {
    return notificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationService>(value),
    );
  }
}

String _$notificationServiceHash() =>
    r'b65bbde8f33e881455df7b2759a187a09c48ee67';
