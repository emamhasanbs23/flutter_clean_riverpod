// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RefreshTokenRequestImpl _$$RefreshTokenRequestImplFromJson(
  Map<String, dynamic> json,
) => _$RefreshTokenRequestImpl(
  refreshToken: json['refreshToken'] as String,
  expiresInMins: (json['expiresInMins'] as num?)?.toInt(),
);

Map<String, dynamic> _$$RefreshTokenRequestImplToJson(
  _$RefreshTokenRequestImpl instance,
) => <String, dynamic>{
  'refreshToken': instance.refreshToken,
  'expiresInMins': instance.expiresInMins,
};
