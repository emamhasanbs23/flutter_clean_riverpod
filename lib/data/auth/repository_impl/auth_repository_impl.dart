import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/logger/app_logger.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/storage/secure_storage_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/data_source/auth_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/mapper/auth_mapper.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/model/login_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/model/refresh_token_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/auth/entities/auth_user.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/auth/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Real [AuthRepository] backed by [AuthDataSource] and secure storage.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthDataSource dataSource,
    required SecureStorageService storage,
  }) : _dataSource = dataSource,
       _storage = storage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';
  static const _userEmailKey = 'user_email';

  final AuthDataSource _dataSource;
  final SecureStorageService _storage;

  @override
  Future<Either<Failure, AuthUser>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dataSource.login(
        request: LoginRequest(username: username, password: password),
      );

      final user =
          response.toDomainOrNull() ??
          AuthUser(
            id: _fakeUserId(username),
            email: response.userEmail ?? username,
          );

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
      if (failure is ValidationFailure || failure is UnauthorizedFailure) {
        return const Left(InvalidCredentialsFailure());
      }
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
      final accessToken = await _storage.read(_accessTokenKey);
      if (accessToken == null || accessToken.isEmpty) {
        return const Right(null);
      }

      try {
        final response = await _dataSource.getMe();
        final user = response.toDomain();
        await _storage.write(_userIdKey, user.id);
        await _storage.write(_userEmailKey, user.email);
        return Right(user);
      } on Failure catch (failure) {
        final cached = await _readCachedUser();
        if (cached != null) {
          return Right(cached);
        }
        return Left(failure);
      }
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
      final response = await _dataSource.refresh(
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

  Future<AuthUser?> _readCachedUser() async {
    final id = await _storage.read(_userIdKey);
    final email = await _storage.read(_userEmailKey);
    if (id == null || id.isEmpty || email == null || email.isEmpty) {
      return null;
    }
    return AuthUser(id: id, email: email);
  }

  String _fakeUserId(String username) {
    return 'usr_${username.hashCode.toUnsigned(32)}';
  }
}
