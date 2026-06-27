import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/network/auth_interceptor.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/network/network_guard.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/api/auth_api.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/model/auth_me_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/model/login_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/model/login_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/model/refresh_token_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/model/refresh_token_response.dart';

/// Network-side contract for auth.
abstract interface class AuthRemoteSource {
  /// Exchanges username + password for an access token (and optional refresh
  /// token). Implementations should persist nothing — the repository owns
  /// secure storage.
  Future<LoginResponse> login({required LoginRequest request});

  /// Trades a refresh token for a fresh access token. May throw
  /// [UnauthorizedFailure] if the refresh token is no longer valid.
  Future<RefreshTokenResponse> refresh({required RefreshTokenRequest request});

  /// Returns the currently authenticated user from `GET /auth/me`.
  Future<AuthMeResponse> getMe();
}

/// Retrofit-backed [AuthRemoteSource].
///
/// Targets the configured `/auth/*` endpoints through [AuthApi]. Network /
/// transport errors are translated into domain failures by [guard] so the
/// repository can simply re-throw and let its catch block build the `Either`.
///
/// Methods accept an optional [CancelToken] so a Riverpod controller can
/// abort the request when its widget is disposed mid-flight.
class AuthRemoteSourceImpl implements AuthRemoteSource {
  AuthRemoteSourceImpl(this._api);

  final AuthApi _api;

  @override
  Future<LoginResponse> login({
    required LoginRequest request,
    CancelToken? cancelToken,
  }) => guard(
    'AuthRemoteSource.login',
    () => _api.login(request, cancelToken: cancelToken),
  );

  @override
  Future<RefreshTokenResponse> refresh({
    required RefreshTokenRequest request,
    CancelToken? cancelToken,
  }) => guard(
    'AuthRemoteSource.refresh',
    () => _api.refresh(
      request,
      cancelToken: cancelToken,
      options: Options(
        extra: <String, dynamic>{AuthInterceptor.skipAuthKey: true},
      ),
    ),
  );

  @override
  Future<AuthMeResponse> getMe({CancelToken? cancelToken}) => guard(
    'AuthRemoteSource.getMe',
    () => _api.getMe(cancelToken: cancelToken),
  );
}
