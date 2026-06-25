import 'package:fpdart/fpdart.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/auth_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/auth_user.dart';

/// Thin use case wrapping [AuthRepository.login] with basic input validation.
///
/// Use cases live in the domain layer so presentation does not call
/// repositories directly. This particular use case rejects obviously invalid
/// input (empty fields, short password) before the repository gets a chance
/// to do its work.
class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthUser>> call({
    required String email,
    required String password,
  }) {
    if (email.isEmpty || !email.contains('@')) {
      return Future.value(
        const Left(InvalidCredentialsFailure()),
      );
    }
    if (password.length < 6) {
      return Future.value(
        const Left(InvalidCredentialsFailure()),
      );
    }
    return _repository.login(email: email, password: password);
  }
}
