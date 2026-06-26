// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_links_deep_link_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that wires the real `app_links`-backed service. Bootstrap
/// overrides [deepLinkServiceProvider] with this in production.

@ProviderFor(appLinksDeepLinkService)
final appLinksDeepLinkServiceProvider = AppLinksDeepLinkServiceProvider._();

/// Provider that wires the real `app_links`-backed service. Bootstrap
/// overrides [deepLinkServiceProvider] with this in production.

final class AppLinksDeepLinkServiceProvider
    extends
        $FunctionalProvider<DeepLinkService, DeepLinkService, DeepLinkService>
    with $Provider<DeepLinkService> {
  /// Provider that wires the real `app_links`-backed service. Bootstrap
  /// overrides [deepLinkServiceProvider] with this in production.
  AppLinksDeepLinkServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLinksDeepLinkServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLinksDeepLinkServiceHash();

  @$internal
  @override
  $ProviderElement<DeepLinkService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeepLinkService create(Ref ref) {
    return appLinksDeepLinkService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeepLinkService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeepLinkService>(value),
    );
  }
}

String _$appLinksDeepLinkServiceHash() =>
    r'67d0cb0b1d6753cd5db7a4e742258ed9e21dfa99';
