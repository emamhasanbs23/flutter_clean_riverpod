import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/deep_link_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_links_deep_link_service.g.dart';

/// Production [DeepLinkService] backed by the `app_links` package.
///
/// `app_links` exposes two surfaces we care about:
/// - `AppLinks.uriLinkStream` — fires whenever the OS delivers a URI to
///   the running app (custom scheme taps, Universal / App Link clicks).
/// - `AppLinks.getInitialLink` — the URI the app was cold-started with,
///   which is only available on first read after launch.
///
/// We expose them as the abstract [DeepLinkService] interface so the rest
/// of the app stays platform-plugin-agnostic and unit-testable.
class AppLinksDeepLinkService implements DeepLinkService {
  AppLinksDeepLinkService({AppLinks? appLinks})
    : _appLinks = appLinks ?? AppLinks();

  final AppLinks _appLinks;

  @override
  Stream<Uri> get incoming => _appLinks.uriLinkStream;

  @override
  Future<Uri?> getInitialLink() => _appLinks.getInitialLink();
}

/// Provider that wires the real `app_links`-backed service. Bootstrap
/// overrides [deepLinkServiceProvider] with this in production.
@Riverpod(keepAlive: true)
DeepLinkService appLinksDeepLinkService(Ref ref) {
  final service = AppLinksDeepLinkService();
  ref.onDispose(() {
    unawaited(service.incoming.drain<void>());
  });
  return service;
}
