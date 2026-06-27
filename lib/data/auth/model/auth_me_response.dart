import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_me_response.freezed.dart';
part 'auth_me_response.g.dart';

/// Wire-format response body for `GET /auth/me`.
@freezed
abstract class AuthMeResponse with _$AuthMeResponse {
  const factory AuthMeResponse({
    required int id,
    required String email,
    String? username,
    String? firstName,
    String? lastName,
    String? image,
  }) = _AuthMeResponse;

  factory AuthMeResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthMeResponseFromJson(json);
}
