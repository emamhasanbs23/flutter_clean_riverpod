// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_me_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthMeResponse _$AuthMeResponseFromJson(Map<String, dynamic> json) =>
    _AuthMeResponse(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      username: json['username'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$AuthMeResponseToJson(_AuthMeResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'image': instance.image,
    };
