import 'package:flutter_clean_riverpod_boilerplate/core/notifications/pending_navigation_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/route_descriptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PendingNavigationNotifier', () {
    test('initial value is null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(pendingNavigationProvider), isNull);
    });

    test('enqueue sets the state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(pendingNavigationProvider.notifier)
          .enqueue(const RouteDescriptor(path: '/todos/42'));
      expect(
        container.read(pendingNavigationProvider),
        const RouteDescriptor(path: '/todos/42'),
      );
    });

    test('enqueue overwrites a previous value', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(pendingNavigationProvider.notifier)
          .enqueue(const RouteDescriptor(path: '/todos/1'));
      container
          .read(pendingNavigationProvider.notifier)
          .enqueue(const RouteDescriptor(path: '/todos/2'));
      expect(
        container.read(pendingNavigationProvider),
        const RouteDescriptor(path: '/todos/2'),
      );
    });

    test('consume returns the current value and clears it', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(pendingNavigationProvider.notifier)
          .enqueue(const RouteDescriptor(path: '/todos/7'));
      final consumed =
          container.read(pendingNavigationProvider.notifier).consume();
      expect(consumed, const RouteDescriptor(path: '/todos/7'));
      expect(container.read(pendingNavigationProvider), isNull);
    });

    test('consume on empty returns null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(
        container.read(pendingNavigationProvider.notifier).consume(),
        isNull,
      );
    });

    test('clear empties without returning', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(pendingNavigationProvider.notifier)
          .enqueue(const RouteDescriptor(path: '/todos/3'));
      container.read(pendingNavigationProvider.notifier).clear();
      expect(container.read(pendingNavigationProvider), isNull);
    });
  });

  group('pendingNavigationBridgeProvider', () {
    test('fires listeners on enqueue and on consume', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final bridge = container.read(pendingNavigationBridgeProvider);
      var notifyCount = 0;
      bridge.addListener(() => notifyCount++);

      container
          .read(pendingNavigationProvider.notifier)
          .enqueue(const RouteDescriptor(path: '/todos/1'));
      expect(notifyCount, 1);

      container.read(pendingNavigationProvider.notifier).consume();
      expect(notifyCount, 2);

      // No change → no extra notification.
      container.read(pendingNavigationProvider.notifier).clear();
      expect(notifyCount, 2);
    });
  });
}
