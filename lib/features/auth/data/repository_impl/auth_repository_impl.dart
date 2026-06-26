import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/logger/app_logger.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/network/auth_interceptor.dart' show AuthInterceptor;
import 'package:flutter_clean_riverpod_boilerplate/core/storage/secure_storage_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/mapper/auth_mapper.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/refresh_token_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Real [AuthRepository] backed by [AuthRemoteDataSource] and secure storage.
///
/// Tokens persist across launches; the [AuthInterceptor] reads the access
/// token on every request. The refresh token is held so the interceptor can
/// recover from a 401 by trading it for a new pair via
/// [AuthRemoteDataSource.refresh].
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService storage,
  })  : _remote = remoteDataSource,
        _storage = storage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';
  static const _userEmailKey = 'user_email';

  final AuthRemoteDataSource _remote;
  final SecureStorageService _storage;

  @override
  Future<Either<Failure, AuthUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remote.login(
        request: LoginRequest(email: email, password: password),
      );

      // Prefer the user object embedded in the response; fall back to a
      // deterministic id derived from the email for legacy backends that
      // don't return a nested user object yet.
      final user = response.toDomainOrNull() ??
          AuthUser(id: _fakeUserId(email), email: email);

      await _storage.write(_accessTokenKey, response.accessToken);
      if (response.refreshToken != null) {
        await _storage.write(_refreshTokenKey, response.refreshToken!);
      }
      await _storage.write(_userIdKey, user.id);
      await _storage.write(_userEmailKey, user.email);

      AppLogger.i('AuthRepository.login succeeded for ${user.email}');
      return Right(user);
    } on Failure catch (failure) {
      AppLogger.w('AuthRepository.login rejected: ${failure.message}');
      return Left(failure);
    } on Object catch (error, stackTrace) {
      AppLogger.e(
        'AuthRepository.login failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _storage.delete(_accessTokenKey);
      await _storage.delete(_refreshTokenKey);
      await _storage.delete(_userIdKey);
      await _storage.delete(_userEmailKey);
      return const Right(null);
    } on Object catch (error, stackTrace) {
      AppLogger.e(
        'AuthRepository.logout failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _storage.read(_accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    try {
      final id = await _storage.read(_userIdKey);
      final email = await _storage.read(_userEmailKey);
      if (id == null || id.isEmpty || email == null || email.isEmpty) {
        return const Right(null);
      }
      return Right(AuthUser(id: id, email: email));
    } on Object catch (error, stackTrace) {
      AppLogger.e(
        'AuthRepository.getCurrentUser failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, String>> refreshAccessToken() async {
    final refresh = await _storage.read(_refreshTokenKey);
    if (refresh == null || refresh.isEmpty) {
      return const Left(UnauthorizedFailure('No refresh token stored'));
    }
    try {
      final response = await _remote.refresh(
        request: RefreshTokenRequest(refreshToken: refresh),
      );
      await _storage.write(_accessTokenKey, response.accessToken);
      if (response.refreshToken != null) {
        await _storage.write(_refreshTokenKey, response.refreshToken!);
      }
      return Right(response.accessToken);
    } on Failure catch (failure) {
      return Left(failure);
    } on Object catch (error, stackTrace) {
      AppLogger.e(
        'AuthRepository.refreshAccessToken failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Left(UnexpectedFailure());
    }
  }

  String _fakeUserId(String email) {
    // Simple deterministic id — a real backend will return a UUID in the
    // auth response and the repository will pick it up from there via the
    // mapper.
    return 'usr_${email.hashCode.toUnsigned(32)}';
  }
}
