// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Top-level [GoRouter] wired with the auth redirect AND the deep-link /
/// push-notification replay.
///
/// The router reads two things on every navigation:
/// - [isAuthenticatedProvider] — drives the login redirect.
/// - [pendingNavigationProvider] — when a deep link / push is queued and
///   the user is authed, the queued destination wins.
///
/// `refreshListenable` is the composition of both signals so a change in
/// either one triggers a redirect re-evaluation.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// Top-level [GoRouter] wired with the auth redirect AND the deep-link /
/// push-notification replay.
///
/// The router reads two things on every navigation:
/// - [isAuthenticatedProvider] — drives the login redirect.
/// - [pendingNavigationProvider] — when a deep link / push is queued and
///   the user is authed, the queued destination wins.
///
/// `refreshListenable` is the composition of both signals so a change in
/// either one triggers a redirect re-evaluation.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Top-level [GoRouter] wired with the auth redirect AND the deep-link /
  /// push-notification replay.
  ///
  /// The router reads two things on every navigation:
  /// - [isAuthenticatedProvider] — drives the login redirect.
  /// - [pendingNavigationProvider] — when a deep link / push is queued and
  ///   the user is authed, the queued destination wins.
  ///
  /// `refreshListenable` is the composition of both signals so a change in
  /// either one triggers a redirect re-evaluation.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'644389a14620ba1c86aecec4228831bfc2bc7c47';
