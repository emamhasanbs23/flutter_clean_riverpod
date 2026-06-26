// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodosResponseDtoImpl _$$TodosResponseDtoImplFromJson(
  Map<String, dynamic> json,
) => _$TodosResponseDtoImpl(
  todos:
      (json['todos'] as List<dynamic>?)
          ?.map((e) => TodoDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TodoDto>[],
  total: (json['total'] as num?)?.toInt() ?? 0,
  skip: (json['skip'] as num?)?.toInt() ?? 0,
  limit: (json['limit'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$TodosResponseDtoImplToJson(
  _$TodosResponseDtoImpl instance,
) => <String, dynamic>{
  'todos': instance.todos,
  'total': instance.total,
  'skip': instance.skip,
  'limit': instance.limit,
};
