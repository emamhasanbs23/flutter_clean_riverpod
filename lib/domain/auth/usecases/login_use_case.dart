import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/auth/entities/auth_user.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/auth/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Thin use case wrapping [AuthRepository.login] with basic input validation.
class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthUser>> call({
    required String username,
    required String password,
  }) {
    if (username.trim().isEmpty) {
      return Future.value(const Left(InvalidCredentialsFailure()));
    }
    if (password.length < 6) {
      return Future.value(const Left(InvalidCredentialsFailure()));
    }
    return _repository.login(username: username.trim(), password: password);
  }
}
