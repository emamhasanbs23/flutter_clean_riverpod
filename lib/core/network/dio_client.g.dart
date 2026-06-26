// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dioAuthRepositoryBuilderHash() =>
    r'eb526a60327020681abfcd8f7f6a92402b56574d';

/// Provider for the deferred auth-repository accessor consumed by
/// [dioProvider].
///
/// Implementations return whatever the interceptor needs (typically the
/// `AuthRepository` instance). The default throws so a misconfigured app
/// fails fast instead of silently skipping refresh.
///
/// Copied from [dioAuthRepositoryBuilder].
@ProviderFor(dioAuthRepositoryBuilder)
final dioAuthRepositoryBuilderProvider =
    Provider<DioAuthRepositoryBuilder>.internal(
      dioAuthRepositoryBuilder,
      name: r'dioAuthRepositoryBuilderProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dioAuthRepositoryBuilderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DioAuthRepositoryBuilderRef = ProviderRef<DioAuthRepositoryBuilder>;
String _$dioHash() => r'cbf54e1b57ad9896912bda809f4e751c6d94f6b5';

/// Riverpod entry point for the configured Dio instance.
///
/// Copied from [dio].
@ProviderFor(dio)
final dioProvider = Provider<Dio>.internal(
  dio,
  name: r'dioProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DioRef = ProviderRef<Dio>;
String _$sessionExpiredSignalHash() =>
    r'6be0ca98702ced1bfecfac2bc75c2aeea363e4fe';

/// Provider exposing a callback that the [AuthInterceptor] invokes when it
/// gives up on a token refresh. Default is a no-op so the dio can be used
/// without Riverpod wiring (e.g. tests).
///
/// Copied from [sessionExpiredSignal].
@ProviderFor(sessionExpiredSignal)
final sessionExpiredSignalProvider = Provider<void Function()>.internal(
  sessionExpiredSignal,
  name: r'sessionExpiredSignalProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionExpiredSignalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SessionExpiredSignalRef = ProviderRef<void Function()>;
String _$flavorConfigHash() => r'2cf6a9c045dd934df04c8c8d1ad7526d0e4ecb11';

/// Riverpod entry point for the active [FlavorConfig].
///
/// Overridden at app startup with the value chosen by the entrypoint.
///
/// Copied from [flavorConfig].
@ProviderFor(flavorConfig)
final flavorConfigProvider = Provider<FlavorConfig>.internal(
  flavorConfig,
  name: r'flavorConfigProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$flavorConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FlavorConfigRef = ProviderRef<FlavorConfig>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
