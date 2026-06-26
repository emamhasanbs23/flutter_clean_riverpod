// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crash_reporter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$crashReporterHash() => r'63a51b507a103976b51eb6ee0292b94371ef9eea';

/// Riverpod entry point. Override with a concrete implementation
/// (e.g. `SentryCrashReporter`) at app startup.
///
/// Copied from [crashReporter].
@ProviderFor(crashReporter)
final crashReporterProvider = Provider<CrashReporter>.internal(
  crashReporter,
  name: r'crashReporterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$crashReporterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CrashReporterRef = ProviderRef<CrashReporter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
