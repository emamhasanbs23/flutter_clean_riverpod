import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/usecases/login_use_case.dart' show LoginUseCase;
import 'package:fpdart/fpdart.dart';

/// Clears persisted tokens and the stored user profile.
///
/// Thin wrapper around [AuthRepository.logout] — kept as its own use case so
/// presentation never calls the repository directly, mirroring the
/// [LoginUseCase] pattern.
class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, void>> call() => _repository.logout();
}
