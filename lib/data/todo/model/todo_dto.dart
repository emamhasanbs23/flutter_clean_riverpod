import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_dto.freezed.dart';
part 'todo_dto.g.dart';

/// Wire-format representation of a DummyJSON Todo.
@freezed
class TodoDto with _$TodoDto {
  const factory TodoDto({
    required int id,
    @JsonKey(name: 'todo') required String todo,
    @Default(false) bool completed,
    @JsonKey(name: 'userId') int? userId,
  }) = _TodoDto;

  factory TodoDto.fromJson(Map<String, dynamic> json) =>
      _$TodoDtoFromJson(json);
}

/// Request body for `POST /todos/add`.
@freezed
class CreateTodoRequestDto with _$CreateTodoRequestDto {
  const factory CreateTodoRequestDto({
    required String todo,
    @JsonKey(name: 'userId') required int userId,
    @Default(false) bool completed,
  }) = _CreateTodoRequestDto;

  factory CreateTodoRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateTodoRequestDtoFromJson(json);
}

/// Partial update body for `PATCH /todos/{id}`.
@freezed
class UpdateTodoRequestDto with _$UpdateTodoRequestDto {
  const factory UpdateTodoRequestDto({required bool completed}) =
      _UpdateTodoRequestDto;

  factory UpdateTodoRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateTodoRequestDtoFromJson(json);
}
