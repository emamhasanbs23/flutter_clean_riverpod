import 'dart:async';

import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/logger/app_logger.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/network/dio_client.dart' show DioClient;
import 'package:flutter_clean_riverpod_boilerplate/core/storage/secure_storage_service.dart';

/// Attaches the access token to every outgoing request and recovers from
/// expired tokens by trading the stored refresh token for a fresh access
/// token, then retrying the original request once.
///
/// All 401s funnel through a single [_refreshFuture] so concurrent requests
/// don't trigger a refresh storm. The interceptor does **not** loop on 401:
/// if the refreshed token still yields 401 we forward the error so the
/// global error pipeline can react (clear auth state + redirect to login).
///
/// The interceptor is intentionally typed against [Object] for the
/// repository builder so the `core/network` package never has to import
/// `features/auth/data` (that would create a cycle with the auth providers
/// that wire the dio). [DioClient] wires the builder to the concrete
/// `AuthRepository` at startup.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(
    this._dio,
    this._storage, {
    required Object Function() authRepositoryBuilder,
    void Function()? onSessionExpired,
  })  : _authRepositoryBuilder = authRepositoryBuilder,
        _onSessionExpired = onSessionExpired;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _retryFlagKey = '_auth_retried';

  /// Dio this interceptor is attached to. The retry path re-uses it so any
  /// test fakes / logging interceptors / etc. attached by the test or by
  /// the application also apply to the retried request.
  final Dio _dio;
  final SecureStorageService _storage;
  final Object Function() _authRepositoryBuilder;
  final void Function()? _onSessionExpired;

  Future<String?>? _refreshFuture;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.headers['Authorization'] == null) {
      final token = await _storage.read(_accessTokenKey);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final status = response?.statusCode;
    final alreadyRetried = err.requestOptions.extra[_retryFlagKey] == true;

    if (status != 401 || alreadyRetried) {
      return handler.next(err);
    }

    final refreshToken = await _storage.read(_refreshTokenKey);
    if (refreshToken == null || refreshToken.isEmpty) {
      AppLogger.w('401 received but no refresh token is stored; '
          'forwarding as Unauthorized.');
      _notifySessionExpired();
      return handler.next(err);
    }

    AppLogger.i('401 detected — attempting token refresh.');
    final refreshed = await _refreshOnce();
    if (refreshed == null) {
      // Refresh failed; clear stored tokens so isAuthenticated() returns
      // false and the router will redirect to the login screen.
      await _clearAuthState();
      _notifySessionExpired();
      AppLogger.w('Token refresh failed; user must sign in again.');
      return handler.next(err);
    }

    // Retry the original request once with the new token.
    final retried = err.requestOptions
      ..headers['Authorization'] = 'Bearer $refreshed'
      ..extra[_retryFlagKey] = true;
    try {
      // Re-use the configured dio so logging interceptors and test
      // adapters see the retry too.
      final response = await _dio.fetch<dynamic>(retried);
      return handler.resolve(response);
    } on DioException catch (retryError) {
      return handler.next(retryError);
    }
  }

  /// Deduplicates concurrent refresh attempts so a wave of 401s becomes
  /// exactly one refresh call.
  Future<String?> _refreshOnce() {
    return _refreshFuture ??= _doRefresh().whenComplete(() {
      _refreshFuture = null;
    });
  }

  Future<String?> _doRefresh() async {
    try {
      final repository = _authRepositoryBuilder();
      // The builder returns an AuthRepository — call refreshAccessToken via a
      // dynamic dispatch so the network layer never has to import the auth
      // data classes.
      final dynamic authRepo = repository;
      final dynamic result = await authRepo.refreshAccessToken();
      // result is `Either<Failure, String>` — inspect via dynamic dispatch.
      final dynamic value = result.fold(
        (Object? failure) {
          AppLogger.w('Refresh returned ${failure.runtimeType}');
          return null;
        },
        (Object? token) => token,
      );
      // Persist the new access token so subsequent requests pick it up
      // via the onRequest hook without having to wait for another 401.
      if (value is String && value.isNotEmpty) {
        await _storage.write(_accessTokenKey, value);
      }
      return value as String?;
    } on Object catch (error, stackTrace) {
      AppLogger.e(
        'AuthInterceptor refresh threw',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> _clearAuthState() async {
    await _storage.delete(_accessTokenKey);
    await _storage.delete(_refreshTokenKey);
  }

  void _notifySessionExpired() {
    final callback = _onSessionExpired;
    if (callback == null) return;
    try {
      callback();
    } on Object catch (error, stackTrace) {
      AppLogger.e(
        'sessionExpired callback threw',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
