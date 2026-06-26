import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';

/// Translates a [DioException] into the closest domain [Failure].
///
/// Repositories call this in their catch blocks so presentation never has to
/// know about HTTP details. The mapping is exhaustive across Dio error types
/// and HTTP status codes for precise error handling.
Failure mapDioExceptionToFailure(DioException error) {
  // First check DioExceptionType for transport/cancellation errors
  return switch (error.type) {
    DioExceptionType.cancel => const CancelledFailure(),
    DioExceptionType.connectionError => const NoConnectionFailure(),
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => const TimeoutFailure(),
    _ => _mapStatusCode(error),
  };
}

/// Maps HTTP status codes to specific [Failure] subtypes.
Failure _mapStatusCode(DioException error) {
  final status = error.response?.statusCode;

  // Handle null status (no response received)
  if (status == null) {
    return UnexpectedFailure(
      error.response?.statusMessage ?? error.message ?? 'Unexpected error',
    );
  }

  return switch (status) {
    400 || 422 => const ValidationFailure(),
    401 || 403 => const UnauthorizedFailure(),
    404 => const NotFoundFailure(),
    429 => RateLimitFailure(
      retryAfter: _parseRetryAfter(error.response?.headers),
    ),
    >= 500 && < 600 => ServerFailure(
      error.response?.statusMessage ?? 'Server error',
    ),
    _ => UnexpectedFailure(
      error.response?.statusMessage ?? error.message ?? 'Unexpected error',
    ),
  };
}

/// Extracts retry-after header value if present.
int? _parseRetryAfter(Headers? headers) {
  final value = headers?.value('retry-after');
  if (value == null) return null;
  return int.tryParse(value);
}
