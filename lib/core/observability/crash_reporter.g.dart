// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crash_reporter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod entry point. Override with a concrete implementation
/// (e.g. `SentryCrashReporter`) at app startup.

@ProviderFor(crashReporter)
final crashReporterProvider = CrashReporterProvider._();

/// Riverpod entry point. Override with a concrete implementation
/// (e.g. `SentryCrashReporter`) at app startup.

final class CrashReporterProvider
    extends $FunctionalProvider<CrashReporter, CrashReporter, CrashReporter>
    with $Provider<CrashReporter> {
  /// Riverpod entry point. Override with a concrete implementation
  /// (e.g. `SentryCrashReporter`) at app startup.
  CrashReporterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crashReporterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crashReporterHash();

  @$internal
  @override
  $ProviderElement<CrashReporter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CrashReporter create(Ref ref) {
    return crashReporter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CrashReporter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CrashReporter>(value),
    );
  }
}

String _$crashReporterHash() => r'63a51b507a103976b51eb6ee0292b94371ef9eea';
