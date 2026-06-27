import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_token_response.freezed.dart';
part 'refresh_token_response.g.dart';

/// Wire-format response body for `POST /auth/refresh`.
///
/// Returns a fresh access token (and optionally a rotated refresh token).
@freezed
abstract class RefreshTokenResponse with _$RefreshTokenResponse {
  const factory RefreshTokenResponse({
    @JsonKey(name: 'accessToken') required String accessToken,
    @JsonKey(name: 'refreshToken') String? refreshToken,
  }) = _RefreshTokenResponse;

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);
}
