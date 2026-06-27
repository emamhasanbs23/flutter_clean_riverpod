// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodoDto _$TodoDtoFromJson(Map<String, dynamic> json) => _TodoDto(
  id: (json['id'] as num).toInt(),
  todo: json['todo'] as String,
  completed: json['completed'] as bool? ?? false,
  userId: (json['userId'] as num?)?.toInt(),
);

Map<String, dynamic> _$TodoDtoToJson(_TodoDto instance) => <String, dynamic>{
  'id': instance.id,
  'todo': instance.todo,
  'completed': instance.completed,
  'userId': instance.userId,
};

_CreateTodoRequestDto _$CreateTodoRequestDtoFromJson(
  Map<String, dynamic> json,
) => _CreateTodoRequestDto(
  todo: json['todo'] as String,
  userId: (json['userId'] as num).toInt(),
  completed: json['completed'] as bool? ?? false,
);

Map<String, dynamic> _$CreateTodoRequestDtoToJson(
  _CreateTodoRequestDto instance,
) => <String, dynamic>{
  'todo': instance.todo,
  'userId': instance.userId,
  'completed': instance.completed,
};

_UpdateTodoRequestDto _$UpdateTodoRequestDtoFromJson(
  Map<String, dynamic> json,
) => _UpdateTodoRequestDto(completed: json['completed'] as bool);

Map<String, dynamic> _$UpdateTodoRequestDtoToJson(
  _UpdateTodoRequestDto instance,
) => <String, dynamic>{'completed': instance.completed};
