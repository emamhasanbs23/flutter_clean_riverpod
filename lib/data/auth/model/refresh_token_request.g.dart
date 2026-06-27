// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RefreshTokenRequest _$RefreshTokenRequestFromJson(Map<String, dynamic> json) =>
    _RefreshTokenRequest(
      refreshToken: json['refreshToken'] as String,
      expiresInMins: (json['expiresInMins'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RefreshTokenRequestToJson(
  _RefreshTokenRequest instance,
) => <String, dynamic>{
  'refreshToken': instance.refreshToken,
  'expiresInMins': instance.expiresInMins,
};
