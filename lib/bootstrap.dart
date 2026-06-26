import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_clean_riverpod_boilerplate/app.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/config/flavor.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/logger/app_logger.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/network/dio_client.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/app_links_deep_link_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/deep_link_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/fcm_notification_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/no_op_notification_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/notification_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/pending_navigation_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/route_descriptor.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/route_descriptor_parser.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/observability/analytics.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/observability/crash_reporter.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/presentation/riverpod/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Initialises framework bindings, resolves the flavor, wires global error
/// capture, and mounts [App] inside a [ProviderScope].
///
/// Called once from each flavor entrypoint (`main_dev.dart`, etc.) so the
/// flavor is set before the first frame.
///
/// ## Cold-start deep links
///
/// Before `runApp` is called we read [DeepLinkService.getInitialLink] and
/// enqueue it on [pendingNavigationProvider] so the GoRouter redirect can
/// pick it up the first time it runs. We also subscribe to
/// [DeepLinkService.incoming] after `runApp` so deep links that arrive
/// while the app is running are enqueued the same way. The login flow
/// consumes the queued value after a successful sign-in.
Future<void> bootstrap(Flavor flavor) async {
  // Run the entire app inside a guarded zone so uncaught async errors are
  // forwarded to the [CrashReporter] instead of crashing silently.
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final config = FlavorConfig.fromFlavor(flavor);
      AppLogger.i('Bootstrapping app for flavor=${config.flavor.name}');

      // Capture every error class Flutter exposes:
      //  - `FlutterError.onError`         — framework (build/layout/paint)
      //  - `PlatformDispatcher.onError`   — uncaught Dart errors at the
      //    engine boundary (e.g. async errors that escape a Future)
      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        // The reporter isn't available yet (we're inside the zone), so we
        // hop back through a microtask to read it from the container.
        scheduleMicrotask(() {
          // No container yet — fall back to the no-op reporter for the
          // very first error. After [runApp] the active reporter will be
          // wired via the provider override.
          const NoOpCrashReporter().reportError(
            details.exception,
            stackTrace: details.stack,
            reason: details.context?.toString(),
          );
        });
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        // Same story as above — bootstrap-time errors go to the no-op.
        const NoOpCrashReporter().reportError(error, stackTrace: stack);
        return true;
      };

      // Build the deep-link + notification services up-front so we can
      // pre-read the cold-start link before the first frame. These get
      // re-bound inside the ProviderScope below so tests can override.
      final deepLinkService = AppLinksDeepLinkService();

      // Try to wire up FCM. If the platform config is missing
      // (developer who hasn't set up Firebase yet, or `flutter test`
      // without a plugin registry), fall back to a no-op service so the
      // app still boots. `initialize()` is called below the container is
      // built so that the cold-start tap, if any, lands on
      // pendingNavigationProvider via the runtime stream subscription.
      final notificationService = _buildNotificationService();

      // Read the cold-start URI (if any). If we got one, pre-build the
      // provider container with the seed so the router redirect can pick
      // it up on first frame.
      final coldStart = await _readColdStart(deepLinkService);
      if (coldStart != null) {
        AppLogger.i('Cold-start destination seeded: $coldStart');
      }

      final container = ProviderContainer(
        observers: [_ProviderLogger()],
        overrides: [
          flavorConfigProvider.overrideWithValue(config),
          // Wire the dio's auth-repository builder to the real
          // [AuthRepository] so the [AuthInterceptor] can refresh expired
          // tokens. Using a closure means the interceptor always reads
          // the current Riverpod-scoped repository (test overrides
          // apply).
          dioAuthRepositoryBuilderProvider.overrideWith(
            (ref) =>
                () => ref.read(authRepositoryProvider),
          ),
          // When the interceptor gives up on a refresh, it invokes this
          // callback. We flip [sessionExpiredProvider] so the router
          // redirect can pick the change up.
          sessionExpiredSignalProvider.overrideWith((ref) {
            return () {
              ref.read(sessionExpiredProvider.notifier).state = true;
            };
          }),
          // Hook the global error reporter / analytics into the app.
          // Concrete implementations (Sentry, Firebase) override these
          // before `runApp` runs.
          crashReporterProvider.overrideWithValue(_BootstrapReporter()),
          analyticsProvider.overrideWithValue(_BootstrapAnalytics()),
          // Production deep-link + notification services. Tests override
          // these with fakes.
          deepLinkServiceProvider.overrideWithValue(deepLinkService),
          notificationServiceProvider.overrideWithValue(notificationService),
          // Seed the pending-navigation notifier with the cold-start
          // destination so the router redirect fires immediately.
          if (coldStart != null)
            pendingNavigationProvider.overrideWith(
              () => _SeededPendingNavigationNotifier(coldStart),
            ),
        ],
      );

      // After the first frame, subscribe to runtime deep-link +
      // notification taps so events arriving on a live app are also
      // enqueued.
      scheduleMicrotask(() {
        _wireRuntimeStreams(container);
        // FCM initialise is async; doing it here (post-frame) lets the
        // cold-start tap (if any) be replayed on the very next stream
        // tick. Failures are swallowed because the FCM service itself
        // already catches init errors.
        unawaited(notificationService.initialize().catchError((Object e) {
          AppLogger.w('FCM initialize failed', error: e);
        }));
      });

      runApp(
        UncontrolledProviderScope(container: container, child: const App()),
      );
    },
    (error, stack) {
      AppLogger.e('Uncaught zone error', error: error, stackTrace: stack);
    },
  );
}

/// Wraps `getInitialLink` so that platform-plugin errors don't take down
/// the bootstrap (e.g. when running `flutter test` with no plugin
/// registration).
Future<RouteDescriptor?> _readColdStart(DeepLinkService service) async {
  try {
    final uri = await service.getInitialLink();
    if (uri == null) return null;
    return RouteDescriptorParser.parse(uri);
  } on Object catch (error, stack) {
    AppLogger.w(
      'getInitialLink failed; continuing without cold-start destination',
      error: error,
      stackTrace: stack,
    );
    return null;
  }
}

/// Builds the production [NotificationService]. FCM is the default; if
/// `initialize()` later fails (e.g. missing google-services.json /
/// GoogleService-Info.plist, or `flutter test` without a plugin
/// registry), the FCM service logs and no-ops itself, so the app still
/// boots cleanly.
///
/// `initialize()` is intentionally NOT called here — it's fired
/// post-frame in [_wireRuntimeStreams] to avoid blocking the first
/// frame on Firebase.
NotificationService _buildNotificationService() {
  return FcmNotificationService();
}

/// Subscribes to the deep-link + notification streams and enqueues any
/// destinations on [pendingNavigationProvider]. Lives for the lifetime of
/// [container] (i.e. the entire app).
void _wireRuntimeStreams(ProviderContainer container) {
  final deepLink = container.read(deepLinkServiceProvider);
  final notifications = container.read(notificationServiceProvider);

  deepLink.incoming.listen((uri) {
    final descriptor = RouteDescriptorParser.parse(uri);
    if (descriptor != null) {
      AppLogger.i('Deep link received: $uri -> $descriptor');
      container.read(pendingNavigationProvider.notifier).enqueue(descriptor);
    }
  });

  notifications.onTap.listen((descriptor) {
    AppLogger.i('Notification tap: $descriptor');
    container.read(pendingNavigationProvider.notifier).enqueue(descriptor);
  });
}

/// PendingNavigationNotifier pre-seeded with a cold-start destination.
///
/// Used only when `bootstrap` finds a deep link at launch. After
/// [consume] returns the seed once, behaviour is identical to the
/// default notifier.
class _SeededPendingNavigationNotifier extends PendingNavigationNotifier {
  _SeededPendingNavigationNotifier(this._seed);

  final RouteDescriptor _seed;

  @override
  RouteDescriptor? build() => _seed;

  @override
  RouteDescriptor? consume() {
    if (state != _seed) {
      return super.consume();
    }
    state = null;
    return _seed;
  }
}

/// CrashReporter used during bootstrap (before the [ProviderScope] is
/// available). Falls back to [NoOpCrashReporter] for the very first frame;
/// once the container is ready the providers above are read instead.
class _BootstrapReporter implements CrashReporter {
  @override
  void reportError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, Object?>? context,
  }) {
    const NoOpCrashReporter().reportError(
      error,
      stackTrace: stackTrace,
      reason: reason,
      context: context,
    );
  }

  @override
  void setUserContext({String? userId, String? email}) {}

  @override
  void clearUserContext() {}
}

class _BootstrapAnalytics implements Analytics {
  @override
  void logEvent(String name, {Map<String, Object?>? parameters}) {}

  @override
  void logScreenView(String screenName) {}

  @override
  void setUserProperty(String name, {String? value}) {}
}

/// Lightweight [ProviderObserver] that pipes provider creation / errors
/// through the global error pipeline. Keeps Riverpod's lifecycle aligned
/// with the rest of the observability stack.
class _ProviderLogger extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    const NoOpCrashReporter().reportError(
      error,
      stackTrace: stackTrace,
      reason: 'Riverpod provider failed: ${provider.name ?? '<anon>'}',
    );
  }
}
