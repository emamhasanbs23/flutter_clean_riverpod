import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crash_reporter.g.dart';

/// Abstraction for crash reporting.
///
/// Implementations are responsible for forwarding uncaught errors to a
/// backend (Sentry, Crashlytics, Bugsnag, etc.). The default
/// [NoOpCrashReporter] just logs the error — wire a real one by overriding
/// [crashReporterProvider] at app startup.
abstract interface class CrashReporter {
  /// Reports a caught (synchronous or asynchronous) error.
  void reportError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, Object?>? context,
  });

  /// Adds user context that subsequent reports will be tagged with.
  void setUserContext({String? userId, String? email});

  /// Removes any user context (called on sign-out).
  void clearUserContext();
}

/// Inert [CrashReporter] used as a default. Errors are still logged so a
/// developer running the app can see them, but nothing leaves the device.
class NoOpCrashReporter implements CrashReporter {
  const NoOpCrashReporter();

  @override
  void reportError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, Object?>? context,
  }) {
    debugPrint('NoOpCrashReporter: ${reason ?? 'uncaught error'} — $error');
    if (stackTrace != null) debugPrint(stackTrace.toString());
  }

  @override
  void setUserContext({String? userId, String? email}) {}

  @override
  void clearUserContext() {}
}

/// Riverpod entry point. Override with a concrete implementation
/// (e.g. `SentryCrashReporter`) at app startup.
@Riverpod(keepAlive: true)
CrashReporter crashReporter(Ref ref) {
  return const NoOpCrashReporter();
}
