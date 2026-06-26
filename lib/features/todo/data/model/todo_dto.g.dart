// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoDtoImpl _$$TodoDtoImplFromJson(Map<String, dynamic> json) =>
    _$TodoDtoImpl(
      id: (json['id'] as num).toInt(),
      todo: json['todo'] as String,
      completed: json['completed'] as bool? ?? false,
      userId: (json['userId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TodoDtoImplToJson(_$TodoDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'todo': instance.todo,
      'completed': instance.completed,
      'userId': instance.userId,
    };

_$CreateTodoRequestDtoImpl _$$CreateTodoRequestDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CreateTodoRequestDtoImpl(
  todo: json['todo'] as String,
  userId: (json['userId'] as num).toInt(),
  completed: json['completed'] as bool? ?? false,
);

Map<String, dynamic> _$$CreateTodoRequestDtoImplToJson(
  _$CreateTodoRequestDtoImpl instance,
) => <String, dynamic>{
  'todo': instance.todo,
  'userId': instance.userId,
  'completed': instance.completed,
};

_$UpdateTodoRequestDtoImpl _$$UpdateTodoRequestDtoImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateTodoRequestDtoImpl(completed: json['completed'] as bool);

Map<String, dynamic> _$$UpdateTodoRequestDtoImplToJson(
  _$UpdateTodoRequestDtoImpl instance,
) => <String, dynamic>{'completed': instance.completed};
