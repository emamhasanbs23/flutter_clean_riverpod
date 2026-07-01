import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Reads the currently logged-in user from secure storage.
///
/// Returns `Right(null)` when no user is persisted (logged-out state) — that
/// is NOT an error, it is the empty case. The presentation layer renders a
/// "signed-out" branch when the result is `null`.
class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthUser?>> call() => _repository.getCurrentUser();
}
