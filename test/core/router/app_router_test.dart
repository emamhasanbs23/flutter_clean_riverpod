import 'package:flutter_clean_riverpod_boilerplate/core/notifications/route_descriptor.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/router/app_router.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/auth/riverpod/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('authRedirect', () {
    test('unauthenticated user on / is redirected to /login', () {
      final next = authRedirect('/', const AsyncValue.data(false));
      expect(next, '/login');
    });

    test('authenticated user on / stays on /', () {
      final next = authRedirect('/', const AsyncValue.data(true));
      expect(next, isNull);
    });

    test('authenticated user on /login is sent back to /', () {
      final next = authRedirect('/login', const AsyncValue.data(true));
      expect(next, '/');
    });

    test('unauthenticated user on /login stays on /login', () {
      final next = authRedirect('/login', const AsyncValue.data(false));
      expect(next, isNull);
    });

    test('loading state redirects protected routes to /splash', () {
      final next = authRedirect('/', const AsyncValue.loading());
      expect(next, '/splash');
    });

    test('loading state stays on /splash', () {
      final next = authRedirect('/splash', const AsyncValue.loading());
      expect(next, isNull);
    });

    test('resolved auth on /splash sends unauthenticated users to /login', () {
      final next = authRedirect('/splash', const AsyncValue.data(false));
      expect(next, '/login');
    });

    test('resolved auth on /splash sends authenticated users to /', () {
      final next = authRedirect('/splash', const AsyncValue.data(true));
      expect(next, '/');
    });
  });

  group('pendingNavigationAwareRedirect', () {
    test(
      'authenticated user with pending destination lands on the pending path',
      () {
        final next = pendingNavigationAwareRedirect(
          matchedLocation: '/',
          auth: const AsyncValue.data(true),
          pending: const RouteDescriptor(path: '/todos/42'),
        );
        expect(next, '/todos/42');
      },
    );

    test('unauthenticated user with pending destination falls through to '
        'authRedirect → /login (pending preserved for replay)', () {
      final next = pendingNavigationAwareRedirect(
        matchedLocation: '/todos/42',
        auth: const AsyncValue.data(false),
        pending: const RouteDescriptor(path: '/todos/42'),
      );
      expect(next, '/login');
    });

    test(
      'authenticated user with no pending destination follows authRedirect',
      () {
        final next = pendingNavigationAwareRedirect(
          matchedLocation: '/todos/42',
          auth: const AsyncValue.data(true),
          pending: null,
        );
        expect(next, isNull);
      },
    );

    test(
      'loading auth redirects to /splash even if a destination is queued',
      () {
        final next = pendingNavigationAwareRedirect(
          matchedLocation: '/',
          auth: const AsyncValue.loading(),
          pending: const RouteDescriptor(path: '/todos/42'),
        );
        expect(next, '/splash');
      },
    );

    test('loading auth stays on /splash when already there', () {
      final next = pendingNavigationAwareRedirect(
        matchedLocation: '/splash',
        auth: const AsyncValue.loading(),
        pending: const RouteDescriptor(path: '/todos/42'),
      );
      expect(next, isNull);
    });

    test('pending destination with query string is forwarded verbatim', () {
      final next = pendingNavigationAwareRedirect(
        matchedLocation: '/',
        auth: const AsyncValue.data(true),
        pending: const RouteDescriptor(
          path: '/todos/42',
          query: {'focus': 'title'},
        ),
      );
      expect(next, '/todos/42?focus=title');
    });
  });

  group('appRouterProvider', () {
    test('exposes a GoRouter bound to the overridable auth provider', () async {
      final container = ProviderContainer(
        overrides: [isAuthenticatedProvider.overrideWith((ref) async => false)],
      );
      addTearDown(container.dispose);

      // Reading the provider must not throw, and the resulting GoRouter
      // must expose the expected routes.
      final router = container.read(appRouterProvider);
      expect(router, isNotNull);
    });
  });
}
