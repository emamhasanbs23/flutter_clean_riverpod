import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// Wire-format response body for `POST /auth/login`.
///
/// Mirrors the JSON the API returns:
/// `{ "access_token": "...", "refresh_token": "...", "user": { "id": "...",
/// "email": "..." } }`.
///
/// The mapper in `auth_mapper.dart` flattens the nested `user` object into
/// [userId] / [userEmail] so the repository can treat the response uniformly.
/// The domain layer never sees this class directly.
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') String? refreshToken,
    @JsonKey(readValue: _readUserId) String? userId,
    @JsonKey(readValue: _readUserEmail) String? userEmail,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

/// Reads `user.id` from the nested `user` object. Falls back to a top-level
/// `user_id` key for backends that flatten the response.
Object? _readUserId(Map<dynamic, dynamic> json, String key) {
  final nested = json['user'];
  if (nested is Map && nested['id'] != null) return nested['id'];
  return json['user_id'];
}

Object? _readUserEmail(Map<dynamic, dynamic> json, String key) {
  final nested = json['user'];
  if (nested is Map && nested['email'] != null) return nested['email'];
  return json['user_email'];
}
