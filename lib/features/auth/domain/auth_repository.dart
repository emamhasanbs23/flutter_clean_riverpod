import 'package:fpdart/fpdart.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/auth_user.dart';

/// Contract every auth implementation must satisfy.
///
/// The interface returns [Either] so the presentation layer can branch on
/// success/failure without try/catch noise.
abstract interface class AuthRepository {
  /// Exchanges credentials for tokens and persists them in secure storage.
  Future<Either<Failure, AuthUser>> login({
    required String email,
    required String password,
  });

  /// Clears the stored tokens and forgets the current user.
  Future<Either<Failure, void>> logout();

  /// Synchronous-ish read of the current auth state. Used by the router to
  /// decide redirects on cold start.
  Future<bool> isAuthenticated();

  /// Trades the stored refresh token for a new access token. Returns the
  /// new access token on success or an [UnauthorizedFailure] when the
  /// refresh token is missing or has been revoked.
  ///
  /// Implementations should persist the new tokens before returning.
  Future<Either<Failure, String>> refreshAccessToken();
}
