import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';

/// Translates a [DioException] into the closest domain [Failure].
///
/// Repositories call this in their catch blocks so presentation never has to
/// know about HTTP details.
Failure mapDioExceptionToFailure(DioException error) {
  final response = error.response;
  final status = response?.statusCode;

  if (error.type == DioExceptionType.connectionError ||
      error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout) {
    return const NetworkFailure();
  }

  if (status == 401 || status == 403) {
    return const UnauthorizedFailure();
  }
  if (status == 404) {
    return const NotFoundFailure();
  }

  return UnexpectedFailure(
    response?.statusMessage ?? error.message ?? 'Unexpected error',
  );
}