import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/repository_impl/auth_repository_impl.dart' show AuthRepositoryImpl;
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/entities/auth_user.dart';

/// Bidirectional mapper between auth wire-format DTOs and domain entities.
///
/// The mapper is the **only** place that knows both shapes — that keeps the
/// domain free of JSON concerns and lets us evolve the wire format and the
/// entity independently.
extension AuthResponseMapper on LoginResponse {
  /// Converts this wire DTO into a domain [AuthUser]. Returns `null` when the
  /// server omitted the nested `user` object, in which case the repository
  /// will fall back to deriving an id from the email (see
  /// [AuthRepositoryImpl.login]).
  AuthUser? toDomainOrNull() {
    final email = userEmail;
    final id = userId;
    if (email == null || email.isEmpty || id == null || id.isEmpty) {
      return null;
    }
    return AuthUser(id: id, email: email);
  }
}
