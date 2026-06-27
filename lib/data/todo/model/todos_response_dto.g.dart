// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodosResponseDto _$TodosResponseDtoFromJson(Map<String, dynamic> json) =>
    _TodosResponseDto(
      todos:
          (json['todos'] as List<dynamic>?)
              ?.map((e) => TodoDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TodoDto>[],
      total: (json['total'] as num?)?.toInt() ?? 0,
      skip: (json['skip'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TodosResponseDtoToJson(_TodosResponseDto instance) =>
    <String, dynamic>{
      'todos': instance.todos,
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
    };
