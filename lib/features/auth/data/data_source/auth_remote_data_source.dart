import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/refresh_token_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/refresh_token_response.dart';
import 'package:fpdart/fpdart.dart' show Either;

/// Network-side contract for auth.
///
/// Lives next to `AuthRepositoryImpl` so the repository can swap between a
/// fake/stub implementation and a Dio-backed one via a provider override.
///
/// Implementations are responsible for translating transport errors into
/// domain [Failure]s before throwing; the repository will then surface them
/// as the `Left` branch of its [Either] return value.
abstract interface class AuthRemoteDataSource {
  /// Exchanges email + password for an access token (and optional refresh
  /// token). Implementations should persist nothing — the repository owns
  /// secure-storage.
  Future<LoginResponse> login({required LoginRequest request});

  /// Trades a refresh token for a fresh access token. May throw
  /// [UnauthorizedFailure] if the refresh token is no longer valid.
  Future<RefreshTokenResponse> refresh({required RefreshTokenRequest request});
}
