/// Supported build flavors.
///
/// Each flavor points at a different backend, has a different display name,
/// and controls dev-only niceties like Dio request logging.
enum Flavor {
  dev,
  staging,
  prod;

  /// Parses a flavor from a `String` (typically the `--dart-define` value).
  /// Falls back to [Flavor.dev] when the value is unknown so development never
  /// crashes on a typo.
  static Flavor fromString(String? value) {
    switch (value) {
      case 'dev':
        return Flavor.dev;
      case 'staging':
        return Flavor.staging;
      case 'prod':
        return Flavor.prod;
      default:
        return Flavor.dev;
    }
  }
}

/// Runtime configuration derived from the active [Flavor].
///
/// Populated once during `bootstrap` and consumed via Riverpod providers.
///
/// Build-time overrides (any of these win over the flavor defaults):
///
///   * `BASE_URL` — API root. Maps to [baseUrl].
///   * `APP_NAME` — display name. Maps to [appName].
///   * `DIO_LOGGING` — `true` / `false`. Forces the Dio pretty logger on or
///     off regardless of flavor.
///   * `ENV_FILE` — path to a `dart-define-from-file` JSON file (the same
///     flag the Dart CLI consumes).
enum EnvKeys {
  baseUrl,
  appName,
  dioLogging;
}

/// Static accessor for build-time `--dart-define` overrides. Reads the value
/// once per key; safe to call from any layer.
class Env {
  Env._();

  static const _baseUrlDefine = String.fromEnvironment('BASE_URL');
  static const _appNameDefine = String.fromEnvironment('APP_NAME');
  static const _dioLoggingDefine = String.fromEnvironment('DIO_LOGGING');

  static String? get baseUrl =>
      _baseUrlDefine.isEmpty ? null : _baseUrlDefine;

  static String? get appName =>
      _appNameDefine.isEmpty ? null : _appNameDefine;

  static bool? get dioLogging {
    if (_dioLoggingDefine.isEmpty) return null;
    return _dioLoggingDefine.toLowerCase() == 'true' ||
        _dioLoggingDefine == '1';
  }
}

/// Runtime configuration derived from the active [Flavor].
class FlavorConfig {
  const FlavorConfig({
    required this.flavor,
    required this.baseUrl,
    required this.appName,
    required this.enableDioLogging,
  });

  const FlavorConfig._forFlavor({
    required this.flavor,
    required this.baseUrl,
    required this.appName,
    required this.enableDioLogging,
  });

  /// Resolves the runtime config for [flavor], layered with any
  /// `--dart-define` overrides from [Env]. Build-time overrides win over
  /// the flavor defaults so CI can point at any backend without touching
  /// code.
  factory FlavorConfig.fromFlavor(Flavor flavor) {
    final defaults = _defaultsFor(flavor);
    return FlavorConfig(
      flavor: flavor,
      baseUrl: Env.baseUrl ?? defaults.baseUrl,
      appName: Env.appName ?? defaults.appName,
      enableDioLogging: Env.dioLogging ?? defaults.enableDioLogging,
    );
  }

  final Flavor flavor;
  final String baseUrl;
  final String appName;
  final bool enableDioLogging;

  static const FlavorConfig _devDefaults = FlavorConfig._forFlavor(
    flavor: Flavor.dev,
    baseUrl: 'https://dev.api.example.com',
    appName: 'Boilerplate (Dev)',
    enableDioLogging: true,
  );

  static const FlavorConfig _stagingDefaults = FlavorConfig._forFlavor(
    flavor: Flavor.staging,
    baseUrl: 'https://staging.api.example.com',
    appName: 'Boilerplate (Staging)',
    enableDioLogging: true,
  );

  static const FlavorConfig _prodDefaults = FlavorConfig._forFlavor(
    flavor: Flavor.prod,
    baseUrl: 'https://api.example.com',
    appName: 'Boilerplate',
    enableDioLogging: false,
  );

  static FlavorConfig _defaultsFor(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        return _devDefaults;
      case Flavor.staging:
        return _stagingDefaults;
      case Flavor.prod:
        return _prodDefaults;
    }
  }
}
