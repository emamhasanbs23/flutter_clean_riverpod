import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/auth_me_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/refresh_token_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/refresh_token_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/remote/auth_remote_source.dart';

/// Aggregate data-source contract for auth. The repository depends on this
/// type — not on [AuthRemoteSource] directly.
abstract interface class AuthDataSource {
  /// Exchanges username + password for an access token (and optional refresh
  /// token). Implementations should persist nothing — the repository owns
  /// secure storage.
  Future<LoginResponse> login({required LoginRequest request});

  /// Trades a refresh token for a fresh access token. May throw
  /// [UnauthorizedFailure] if the refresh token is no longer valid.
  Future<RefreshTokenResponse> refresh({required RefreshTokenRequest request});

  /// Returns the currently authenticated user from `GET /auth/me`.
  Future<AuthMeResponse> getMe();
}
