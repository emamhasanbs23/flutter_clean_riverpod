import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.freezed.dart';
part 'login_request.g.dart';

/// Wire-format request body for `POST /auth/login`.
///
/// Mirrors the JSON DummyJSON expects:
/// `{ "username": "...", "password": "...", "expiresInMins": 60 }`.
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String username,
    required String password,
    int? expiresInMins,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}
