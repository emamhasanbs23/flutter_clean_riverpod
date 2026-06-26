import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cross-platform abstraction over incoming deep links.
///
/// Two kinds of URIs flow through this service:
/// 1. **Custom scheme**: `boilerplate-dev://todos/42` — declared in the
///    per-platform manifest / plist, always delivered to our app.
/// 2. **Universal / App Links**: `https://example.com/todos/42` — declared
///    via `autoVerify` on Android and the `apple-app-site-association`
///    file on iOS, only delivered to our app once the platform has
///    verified the domain association.
///
/// The service has two entry points:
/// - [incoming]: a [Stream] of URIs that arrive while the app is alive.
/// - [getInitialLink]: returns the URI the app was cold-started with, or
///   `null` if it was launched from the home screen.
///
/// All implementations must be safe to construct before
/// `runApp` (so the bootstrap can pre-fetch the initial link) and must
/// tolerate the platform plugin not being registered (e.g. unit tests).
abstract interface class DeepLinkService {
  /// URIs delivered after the app is running. The first event may fire
  /// shortly after subscription if the OS batches the initial URI.
  Stream<Uri> get incoming;

  /// Returns the URI the app was COLD-STARTED with, if any. Must only be
  /// called once at startup; calling later returns `null`.
  Future<Uri?> getInitialLink();
}

/// Provider entry point. Default implementation is a no-op so unit tests
/// (which never call `getInitialLink`) stay green. Bootstrap overrides this
/// with the real platform-backed implementation.
final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  return const NoOpDeepLinkService();
});

/// Default no-op implementation.
///
/// `incoming` is an empty stream and `getInitialLink` returns `null`. The
/// app boots normally with no deep link to consume.
class NoOpDeepLinkService implements DeepLinkService {
  const NoOpDeepLinkService();

  @override
  Stream<Uri> get incoming => const Stream<Uri>.empty();

  @override
  Future<Uri?> getInitialLink() async => null;
}
