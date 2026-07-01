import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/data_source/auth_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/auth_me_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/refresh_token_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/refresh_token_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/remote/auth_remote_source.dart';

/// Facade that delegates auth network calls to [AuthRemoteSource].
class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl(this._remoteSource);

  final AuthRemoteSource _remoteSource;

  @override
  Future<LoginResponse> login({required LoginRequest request}) =>
      _remoteSource.login(request: request);

  @override
  Future<RefreshTokenResponse> refresh({
    required RefreshTokenRequest request,
  }) => _remoteSource.refresh(request: request);

  @override
  Future<AuthMeResponse> getMe() => _remoteSource.getMe();
}
