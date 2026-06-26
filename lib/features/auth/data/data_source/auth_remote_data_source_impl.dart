import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/network/auth_interceptor.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/network/network_guard.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/api/auth_api.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/refresh_token_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/refresh_token_response.dart';

/// Retrofit-backed `AuthRemoteDataSource`.
///
/// Targets the configured `/auth/*` endpoints through `AuthApi`. Network /
/// transport errors are translated into domain failures by `guard` so the
/// repository can simply re-throw and let its catch block build the `Either`.
///
/// Methods accept an optional [CancelToken] so a Riverpod controller can
/// abort the request when its widget is disposed mid-flight.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._api);

  final AuthApi _api;

  @override
  Future<LoginResponse> login({
    required LoginRequest request,
    CancelToken? cancelToken,
  }) => guard(
    'AuthRemoteDataSource.login',
    () => _api.login(request, cancelToken: cancelToken),
  );

  @override
  Future<RefreshTokenResponse> refresh({
    required RefreshTokenRequest request,
    CancelToken? cancelToken,
  }) => guard(
    'AuthRemoteDataSource.refresh',
    () => _api.refresh(
      request,
      cancelToken: cancelToken,
      // Mark this request to skip auth header attachment so the
      // interceptor doesn't attach the expired access token.
      options: Options(
        extra: <String, dynamic>{AuthInterceptor.skipAuthKey: true},
      ),
    ),
  );
}
