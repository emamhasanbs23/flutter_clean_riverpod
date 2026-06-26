import 'package:flutter/foundation.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/route_descriptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
class PendingNavigationNotifier extends Notifier<RouteDescriptor?> {
  @override
  RouteDescriptor? build() => null;

  /// Set the next destination. Overwrites any previous value.
  // ignore: use_setters_to_change_properties
  void enqueue(RouteDescriptor descriptor) {
    state = descriptor;
  }

  /// Returns and clears the current destination. Returns null if empty.
  RouteDescriptor? consume() {
    final current = state;
    state = null;
    return current;
  }

  /// Clear without returning.
  // ignore: use_setters_to_change_properties
  void clear() {
    state = null;
  }
}

/// The single source of truth for the queued destination. Tests override
/// this to seed a destination; production reads it from the
/// [PendingNavigationNotifier] built above.
final pendingNavigationProvider =
    NotifierProvider<PendingNavigationNotifier, RouteDescriptor?>(
      PendingNavigationNotifier.new,
    );

/// A [ChangeNotifier] that fires whenever [pendingNavigationProvider]'s
/// value changes. GoRouter's `refreshListenable` wants a [Listenable], not
/// a Riverpod subscription, so we bridge the two.
///
/// Created lazily by [pendingNavigationBridgeProvider] so the router only
/// pays for the subscription while it's actually wiring its refresh hook.
class _PendingNavigationBridge extends ChangeNotifier {
  _PendingNavigationBridge(this._ref) {
    _subscription = _ref.listen<RouteDescriptor?>(
      pendingNavigationProvider,
      (_, __) => notifyListeners(),
    );
  }

  final Ref _ref;
  late final ProviderSubscription<RouteDescriptor?> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

final pendingNavigationBridgeProvider = Provider<ChangeNotifier>((ref) {
  final bridge = _PendingNavigationBridge(ref);
  ref.onDispose(bridge.dispose);
  return bridge;
});

/// Combined [Listenable] used by GoRouter's `refreshListenable`.
///
/// GoRouter re-runs `redirect` whenever ANY source fires, so composing the
/// auth refresh notifier + the pending-navigation bridge into a single
/// notifier keeps the router config tidy.
class CombinedRefreshListenable extends ChangeNotifier {
  CombinedRefreshListenable(List<ChangeNotifier> sources) {
    for (final source in sources) {
      _forwarders.add(source);
      source.addListener(_onAnySourceChanged);
    }
  }

  final List<ChangeNotifier> _forwarders = [];

  void _onAnySourceChanged() => notifyListeners();

  @override
  void dispose() {
    for (final source in _forwarders) {
      source.removeListener(_onAnySourceChanged);
    }
    super.dispose();
  }
}
