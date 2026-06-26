import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// Wire-format response body for `POST /auth/login`.
///
/// DummyJSON returns a flat user object with camelCase token keys:
/// `{ "id": 1, "email": "...", "accessToken": "...", "refreshToken": "..." }`.
///
/// The mapper in `auth_mapper.dart` flattens user fields into [userId] /
/// [userEmail] so the repository can treat the response uniformly.
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @JsonKey(name: 'accessToken') required String accessToken,
    @JsonKey(name: 'refreshToken') String? refreshToken,
    @JsonKey(readValue: _readUserId) String? userId,
    @JsonKey(readValue: _readUserEmail) String? userEmail,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

/// Reads `user.id` from a nested `user` object, or top-level `id` /
/// `user_id`. Coerces numeric ids to [String] (DummyJSON returns an int).
Object? _readUserId(Map<dynamic, dynamic> json, String key) {
  final nested = json['user'];
  final raw =
      (nested is Map ? nested['id'] : null) ?? json['id'] ?? json['user_id'];
  return raw?.toString();
}

Object? _readUserEmail(Map<dynamic, dynamic> json, String key) {
  final nested = json['user'];
  return (nested is Map ? nested['email'] : null) ??
      json['email'] ??
      json['user_email'];
}
