// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the deferred auth-repository accessor consumed by
/// [dioProvider].
///
/// Implementations return whatever the interceptor needs (typically the
/// `AuthRepository` instance). The default throws so a misconfigured app
/// fails fast instead of silently skipping refresh.

@ProviderFor(dioAuthRepositoryBuilder)
final dioAuthRepositoryBuilderProvider = DioAuthRepositoryBuilderProvider._();

/// Provider for the deferred auth-repository accessor consumed by
/// [dioProvider].
///
/// Implementations return whatever the interceptor needs (typically the
/// `AuthRepository` instance). The default throws so a misconfigured app
/// fails fast instead of silently skipping refresh.

final class DioAuthRepositoryBuilderProvider
    extends
        $FunctionalProvider<
          DioAuthRepositoryBuilder,
          DioAuthRepositoryBuilder,
          DioAuthRepositoryBuilder
        >
    with $Provider<DioAuthRepositoryBuilder> {
  /// Provider for the deferred auth-repository accessor consumed by
  /// [dioProvider].
  ///
  /// Implementations return whatever the interceptor needs (typically the
  /// `AuthRepository` instance). The default throws so a misconfigured app
  /// fails fast instead of silently skipping refresh.
  DioAuthRepositoryBuilderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioAuthRepositoryBuilderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioAuthRepositoryBuilderHash();

  @$internal
  @override
  $ProviderElement<DioAuthRepositoryBuilder> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DioAuthRepositoryBuilder create(Ref ref) {
    return dioAuthRepositoryBuilder(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DioAuthRepositoryBuilder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DioAuthRepositoryBuilder>(value),
    );
  }
}

String _$dioAuthRepositoryBuilderHash() =>
    r'eb526a60327020681abfcd8f7f6a92402b56574d';

/// Riverpod entry point for the configured Dio instance.

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Riverpod entry point for the configured Dio instance.

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Riverpod entry point for the configured Dio instance.
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'cbf54e1b57ad9896912bda809f4e751c6d94f6b5';

/// Provider exposing a callback that the [AuthInterceptor] invokes when it
/// gives up on a token refresh. Default is a no-op so the dio can be used
/// without Riverpod wiring (e.g. tests).

@ProviderFor(sessionExpiredSignal)
final sessionExpiredSignalProvider = SessionExpiredSignalProvider._();

/// Provider exposing a callback that the [AuthInterceptor] invokes when it
/// gives up on a token refresh. Default is a no-op so the dio can be used
/// without Riverpod wiring (e.g. tests).

final class SessionExpiredSignalProvider
    extends
        $FunctionalProvider<void Function(), void Function(), void Function()>
    with $Provider<void Function()> {
  /// Provider exposing a callback that the [AuthInterceptor] invokes when it
  /// gives up on a token refresh. Default is a no-op so the dio can be used
  /// without Riverpod wiring (e.g. tests).
  SessionExpiredSignalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionExpiredSignalProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionExpiredSignalHash();

  @$internal
  @override
  $ProviderElement<void Function()> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void Function() create(Ref ref) {
    return sessionExpiredSignal(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void Function()>(value),
    );
  }
}

String _$sessionExpiredSignalHash() =>
    r'6be0ca98702ced1bfecfac2bc75c2aeea363e4fe';

/// Riverpod entry point for the active [FlavorConfig].
///
/// Overridden at app startup with the value chosen by the entrypoint.

@ProviderFor(flavorConfig)
final flavorConfigProvider = FlavorConfigProvider._();

/// Riverpod entry point for the active [FlavorConfig].
///
/// Overridden at app startup with the value chosen by the entrypoint.

final class FlavorConfigProvider
    extends $FunctionalProvider<FlavorConfig, FlavorConfig, FlavorConfig>
    with $Provider<FlavorConfig> {
  /// Riverpod entry point for the active [FlavorConfig].
  ///
  /// Overridden at app startup with the value chosen by the entrypoint.
  FlavorConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'flavorConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$flavorConfigHash();

  @$internal
  @override
  $ProviderElement<FlavorConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FlavorConfig create(Ref ref) {
    return flavorConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlavorConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlavorConfig>(value),
    );
  }
}

String _$flavorConfigHash() => r'2cf6a9c045dd934df04c8c8d1ad7526d0e4ecb11';
