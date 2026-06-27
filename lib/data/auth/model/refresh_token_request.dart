import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_token_request.freezed.dart';
part 'refresh_token_request.g.dart';

/// Wire-format request body for `POST /auth/refresh`.
///
/// Mirrors the JSON DummyJSON expects: `{ "refreshToken": "..." }`.
@freezed
abstract class RefreshTokenRequest with _$RefreshTokenRequest {
  const factory RefreshTokenRequest({
    @JsonKey(name: 'refreshToken') required String refreshToken,
    int? expiresInMins,
  }) = _RefreshTokenRequest;

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);
}
