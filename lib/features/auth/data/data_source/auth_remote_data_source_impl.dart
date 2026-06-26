import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/dio_failure_mapper.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/logger/app_logger.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/refresh_token_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/refresh_token_response.dart';

/// Dio-backed [AuthRemoteDataSource].
///
/// Targets a configurable `/auth/*` endpoint, defaulting to placeholder
/// paths so the wiring is visible without requiring a live backend.
///
/// The default endpoint shape is intentionally minimal — a real backend
/// can override the path by passing `loginPath` / `refreshPath` to the
/// constructor. The response is expected to be
/// `{"access_token": "...", "refresh_token": "...", "user": {"id": "...",
/// "email": "..."}}`.
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
  Future<LoginResponse> login({required LoginRequest request}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _loginPath,
        data: request.toJson(),
      );
      return _parseLoginResponse(response.data);
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
  Future<RefreshTokenResponse> refresh({
    required RefreshTokenRequest request,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _refreshPath,
        data: request.toJson(),
      );
      return _parseRefreshResponse(response.data);
    } on DioException catch (error, stackTrace) {
      AppLogger.e(
        'AuthRemoteDataSource.refresh failed',
        error: error,
        stackTrace: stackTrace,
      );
      throw mapDioExceptionToFailure(error);
    }
  }

  LoginResponse _parseLoginResponse(Map<String, dynamic>? body) {
    if (body == null) {
      throw const UnexpectedFailure('Empty auth response');
    }
    try {
      return LoginResponse.fromJson(body);
    } on Object catch (error, stackTrace) {
      AppLogger.e(
        'AuthRemoteDataSource._parseLoginResponse failed',
        error: error,
        stackTrace: stackTrace,
      );
      throw const UnexpectedFailure('Malformed login response');
    }
  }

  RefreshTokenResponse _parseRefreshResponse(Map<String, dynamic>? body) {
    if (body == null) {
      throw const UnexpectedFailure('Empty refresh response');
    }
    try {
      return RefreshTokenResponse.fromJson(body);
    } on Object catch (error, stackTrace) {
      AppLogger.e(
        'AuthRemoteDataSource._parseRefreshResponse failed',
        error: error,
        stackTrace: stackTrace,
      );
      throw const UnexpectedFailure('Malformed refresh response');
    }
  }
}
