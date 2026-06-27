import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/dio_failure_mapper.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/logger/app_logger.dart';

/// Wraps a single Retrofit / Dio call so every remote data source method
/// collapses to a one-liner.
///
/// Responsibilities:
/// - Log failures with the caller's tag and stack trace.
/// - Translate `DioException` into the domain failure hierarchy via
///   `mapDioExceptionToFailure` so repositories can catch a failure and
///   build an `Either` without re-implementing the mapping.
/// - Rethrow any non-Dio exception untouched (programmer errors stay loud).
///
/// Per `docs/agents/error-handling.md`, `try`/`catch` is reserved for
/// `bootstrap.dart`, the Dio interceptor, and tests. This helper is the
/// single allowed exception at the data-source boundary because every
/// remote method needs identical handling and duplicating it across N
/// endpoints is what got us here.
///
/// Usage from a data source:
/// ```dart
/// @override
/// Future<List<TodoDto>> fetchAll() => guard(
///       'TodoRemoteDataSourceImpl.fetchAll',
///       () => _api.getTodos(),
///     );
/// ```
Future<T> guard<T>(String tag, Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (error, stackTrace) {
    AppLogger.e('$tag failed', error: error, stackTrace: stackTrace);
    throw mapDioExceptionToFailure(error);
  }
}
