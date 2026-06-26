import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/auth_me_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/repository_impl/auth_repository_impl.dart'
    show AuthRepositoryImpl;
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/entities/auth_user.dart';

/// Bidirectional mapper between auth wire-format DTOs and domain entities.
extension AuthResponseMapper on LoginResponse {
  /// Converts this wire DTO into a domain [AuthUser]. Returns `null` when the
  /// server omitted user fields, in which case the repository will fall back
  /// to deriving an id from the username (see [AuthRepositoryImpl.login]).
  AuthUser? toDomainOrNull() {
    final email = userEmail;
    final id = userId;
    if (email == null || email.isEmpty || id == null || id.isEmpty) {
      return null;
    }
    return AuthUser(id: id, email: email);
  }
}

extension AuthMeResponseMapper on AuthMeResponse {
  AuthUser toDomain() => AuthUser(id: id.toString(), email: email);
}
