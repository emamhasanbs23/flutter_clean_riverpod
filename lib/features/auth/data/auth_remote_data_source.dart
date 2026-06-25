import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/dio_failure_mapper.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/logger/app_logger.dart';

/// Network-side contract for auth. Lives next to [AuthRepositoryImpl] so the
/// repository can swap between a fake/stub implementation and a Dio-backed
/// one via a provider override.
///
/// Implementations are responsible for translating [DioException]s into
/// [Failure]s before throwing; the repository will then surface them as the
/// `Left` branch of its [Either] return value.
abstract interface class AuthRemoteDataSource {
  /// Exchanges email + password for an access token (and optional refresh
  /// token). Implementations should persist nothing — the repository owns
  /// secure-storage.
  Future<AuthTokens> login({required String email, required String password});

  /// Trades a refresh token for a fresh access token. May throw
  /// [UnauthorizedFailure] if the refresh token is no longer valid.
  Future<AuthTokens> refresh({required String refreshToken});
}

/// Result of an authentication round-trip.
class AuthTokens {
  const AuthTokens({required this.accessToken, this.refreshToken});

  final String accessToken;
  final String? refreshToken;
}

/// Dio-backed implementation. Targets a configurable `/auth/*` endpoint,
/// defaulting to a placeholder path so the wiring is visible without
/// requiring a live backend.
///
/// The default endpoint shape is intentionally minimal — a real backend
/// can override the path by passing [loginPath] / [refreshPath] to the
/// constructor. The response is expected to be `{"access_token": "...",
/// "refresh_token": "..."}`.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(
    this._dio, {
    String loginPath = '/auth/login',
    String refreshPath = '/auth/refresh',
  })  : _loginPath = loginPath,
        _refreshPath = refreshPath;

  final Dio _dio;
  final String _loginPath;
  final String _refreshPath;

  @override
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _loginPath,
        data: {'email': email, 'password': password},
      );
      return _parseTokens(response.data);
    } on DioException catch (error, stackTrace) {
      AppLogger.e(
        'AuthRemoteDataSource.login failed',
        error: error,
        stackTrace: stackTrace,
      );
      throw mapDioExceptionToFailure(error);
    }
  }

  @override
  Future<AuthTokens> refresh({required String refreshToken}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _refreshPath,
        data: {'refresh_token': refreshToken},
      );
      return _parseTokens(response.data);
    } on DioException catch (error, stackTrace) {
      AppLogger.e(
        'AuthRemoteDataSource.refresh failed',
        error: error,
        stackTrace: stackTrace,
      );
      throw mapDioExceptionToFailure(error);
    }
  }

  AuthTokens _parseTokens(Map<String, dynamic>? body) {
    if (body == null) {
      throw const UnexpectedFailure('Empty auth response');
    }
    final access = body['access_token'];
    if (access is! String || access.isEmpty) {
      throw const UnexpectedFailure('Missing access_token in response');
    }
    final refresh = body['refresh_token'];
    return AuthTokens(
      accessToken: access,
      refreshToken: refresh is String ? refresh : null,
    );
  }
}