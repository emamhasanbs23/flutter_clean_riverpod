import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.freezed.dart';
part 'login_request.g.dart';

/// Wire-format request body for `POST /auth/login`.
///
/// Mirrors the JSON the API expects: `{ "email": "...", "password": "..." }`.
/// This is a **data-layer** DTO — the domain layer never references it; the
/// repository converts to/from domain entities via `AuthMapper`.
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}