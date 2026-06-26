// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_navigation_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pendingNavigationBridgeHash() =>
    r'f4275524c5e2a4b43a9f80a32589b00b5a34c560';

/// See also [pendingNavigationBridge].
@ProviderFor(pendingNavigationBridge)
final pendingNavigationBridgeProvider = Provider<ChangeNotifier>.internal(
  pendingNavigationBridge,
  name: r'pendingNavigationBridgeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingNavigationBridgeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingNavigationBridgeRef = ProviderRef<ChangeNotifier>;
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
///
/// Copied from [PendingNavigation].
@ProviderFor(PendingNavigation)
final pendingNavigationProvider =
    NotifierProvider<PendingNavigation, RouteDescriptor?>.internal(
      PendingNavigation.new,
      name: r'pendingNavigationProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pendingNavigationHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PendingNavigation = Notifier<RouteDescriptor?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
