// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_navigation_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the next [RouteDescriptor] the app should navigate to.
///
/// Two producers feed this:
/// 1. Incoming deep links at runtime (the deep-link service in
///    `core/notifications/deep_link_service.dart`).
/// 2. Push notification taps (the notification service in
///    `core/notifications/notification_service.dart`) — including the
///    cold-start message.
///
/// Two consumers drain it:
/// 1. The GoRouter redirect reads the value to know whether to **preserve**
///    a deep-link destination while the user is being bounced to `/login`.
/// 2. The login flow calls [consume] on a successful sign-in to land on
///    the queued destination.
///
/// ## Why a single nullable?
///
/// The state is intentionally a single nullable slot:
/// - `null` means "no pending navigation; the user is just navigating the
///   app on their own".
/// - A non-null value means "the user came in from outside the app and
///   wants to land here".
///
/// Stacking destinations is out of scope. The first one wins; subsequent
/// ones overwrite it. This matches user intuition for push notifications and
/// keeps the state machine trivially testable.

@ProviderFor(PendingNavigation)
final pendingNavigationProvider = PendingNavigationProvider._();

/// Holds the next [RouteDescriptor] the app should navigate to.
///
/// Two producers feed this:
/// 1. Incoming deep links at runtime (the deep-link service in
///    `core/notifications/deep_link_service.dart`).
/// 2. Push notification taps (the notification service in
///    `core/notifications/notification_service.dart`) — including the
///    cold-start message.
///
/// Two consumers drain it:
/// 1. The GoRouter redirect reads the value to know whether to **preserve**
///    a deep-link destination while the user is being bounced to `/login`.
/// 2. The login flow calls [consume] on a successful sign-in to land on
///    the queued destination.
///
/// ## Why a single nullable?
///
/// The state is intentionally a single nullable slot:
/// - `null` means "no pending navigation; the user is just navigating the
///   app on their own".
/// - A non-null value means "the user came in from outside the app and
///   wants to land here".
///
/// Stacking destinations is out of scope. The first one wins; subsequent
/// ones overwrite it. This matches user intuition for push notifications and
/// keeps the state machine trivially testable.
final class PendingNavigationProvider
    extends $NotifierProvider<PendingNavigation, RouteDescriptor?> {
  /// Holds the next [RouteDescriptor] the app should navigate to.
  ///
  /// Two producers feed this:
  /// 1. Incoming deep links at runtime (the deep-link service in
  ///    `core/notifications/deep_link_service.dart`).
  /// 2. Push notification taps (the notification service in
  ///    `core/notifications/notification_service.dart`) — including the
  ///    cold-start message.
  ///
  /// Two consumers drain it:
  /// 1. The GoRouter redirect reads the value to know whether to **preserve**
  ///    a deep-link destination while the user is being bounced to `/login`.
  /// 2. The login flow calls [consume] on a successful sign-in to land on
  ///    the queued destination.
  ///
  /// ## Why a single nullable?
  ///
  /// The state is intentionally a single nullable slot:
  /// - `null` means "no pending navigation; the user is just navigating the
  ///   app on their own".
  /// - A non-null value means "the user came in from outside the app and
  ///   wants to land here".
  ///
  /// Stacking destinations is out of scope. The first one wins; subsequent
  /// ones overwrite it. This matches user intuition for push notifications and
  /// keeps the state machine trivially testable.
  PendingNavigationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingNavigationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingNavigationHash();

  @$internal
  @override
  PendingNavigation create() => PendingNavigation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RouteDescriptor? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RouteDescriptor?>(value),
    );
  }
}

String _$pendingNavigationHash() => r'8f9588ab9e376ce7c371454541eaba131bc2663e';

/// Holds the next [RouteDescriptor] the app should navigate to.
///
/// Two producers feed this:
/// 1. Incoming deep links at runtime (the deep-link service in
///    `core/notifications/deep_link_service.dart`).
/// 2. Push notification taps (the notification service in
///    `core/notifications/notification_service.dart`) — including the
///    cold-start message.
///
/// Two consumers drain it:
/// 1. The GoRouter redirect reads the value to know whether to **preserve**
///    a deep-link destination while the user is being bounced to `/login`.
/// 2. The login flow calls [consume] on a successful sign-in to land on
///    the queued destination.
///
/// ## Why a single nullable?
///
/// The state is intentionally a single nullable slot:
/// - `null` means "no pending navigation; the user is just navigating the
///   app on their own".
/// - A non-null value means "the user came in from outside the app and
///   wants to land here".
///
/// Stacking destinations is out of scope. The first one wins; subsequent
/// ones overwrite it. This matches user intuition for push notifications and
/// keeps the state machine trivially testable.

abstract class _$PendingNavigation extends $Notifier<RouteDescriptor?> {
  RouteDescriptor? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RouteDescriptor?, RouteDescriptor?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RouteDescriptor?, RouteDescriptor?>,
              RouteDescriptor?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(pendingNavigationBridge)
final pendingNavigationBridgeProvider = PendingNavigationBridgeProvider._();

final class PendingNavigationBridgeProvider
    extends $FunctionalProvider<ChangeNotifier, ChangeNotifier, ChangeNotifier>
    with $Provider<ChangeNotifier> {
  PendingNavigationBridgeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingNavigationBridgeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingNavigationBridgeHash();

  @$internal
  @override
  $ProviderElement<ChangeNotifier> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChangeNotifier create(Ref ref) {
    return pendingNavigationBridge(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChangeNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChangeNotifier>(value),
    );
  }
}

String _$pendingNavigationBridgeHash() =>
    r'f4275524c5e2a4b43a9f80a32589b00b5a34c560';
