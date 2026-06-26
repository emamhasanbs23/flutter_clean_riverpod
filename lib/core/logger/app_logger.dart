import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Shared logger used across the app.
///
/// All flavors emit logs but only [Level.debug] and below are suppressed on
/// release builds via the `kReleaseMode`/`kDebugMode` checks below.
final class AppLogger {
  AppLogger._();

  static final Logger _instance = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      printEmojis: false,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: kReleaseMode ? Level.info : Level.trace,
  );

  static void d(String message, {Object? error, StackTrace? stackTrace}) {
    _instance.d(message, error: error, stackTrace: stackTrace);
  }

  static void i(String message, {Object? error, StackTrace? stackTrace}) {
    _instance.i(message, error: error, stackTrace: stackTrace);
  }

  static void w(String message, {Object? error, StackTrace? stackTrace}) {
    _instance.w(message, error: error, stackTrace: stackTrace);
  }

  static void e(String message, {Object? error, StackTrace? stackTrace}) {
    _instance.e(message, error: error, stackTrace: stackTrace);
  }
}
