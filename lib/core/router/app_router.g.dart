// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appRouterHash() => r'c13d30a63e6103d3af5679b6c408a5976af8a462';

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
///
/// Copied from [appRouter].
@ProviderFor(appRouter)
final appRouterProvider = Provider<GoRouter>.internal(
  appRouter,
  name: r'appRouterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appRouterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppRouterRef = ProviderRef<GoRouter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
