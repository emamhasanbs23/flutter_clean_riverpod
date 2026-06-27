// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deep_link_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider entry point. Default implementation is a no-op so unit tests
/// (which never call `getInitialLink`) stay green. Bootstrap overrides this
/// with the real platform-backed implementation.

@ProviderFor(deepLinkService)
final deepLinkServiceProvider = DeepLinkServiceProvider._();

/// Provider entry point. Default implementation is a no-op so unit tests
/// (which never call `getInitialLink`) stay green. Bootstrap overrides this
/// with the real platform-backed implementation.

final class DeepLinkServiceProvider
    extends
        $FunctionalProvider<DeepLinkService, DeepLinkService, DeepLinkService>
    with $Provider<DeepLinkService> {
  /// Provider entry point. Default implementation is a no-op so unit tests
  /// (which never call `getInitialLink`) stay green. Bootstrap overrides this
  /// with the real platform-backed implementation.
  DeepLinkServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deepLinkServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deepLinkServiceHash();

  @$internal
  @override
  $ProviderElement<DeepLinkService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeepLinkService create(Ref ref) {
    return deepLinkService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeepLinkService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeepLinkService>(value),
    );
  }
}

String _$deepLinkServiceHash() => r'684c673f53b86253ec1122e04cc7911c71e22783';
