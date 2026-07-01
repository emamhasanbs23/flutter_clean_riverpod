import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/model/todo_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todos_response_dto.freezed.dart';
part 'todos_response_dto.g.dart';

/// Paginated list envelope returned by `GET /todos`.
@freezed
abstract class TodosResponseDto with _$TodosResponseDto {
  const factory TodosResponseDto({
    @Default(<TodoDto>[]) List<TodoDto> todos,
    @Default(0) int total,
    @Default(0) int skip,
    @Default(0) int limit,
  }) = _TodosResponseDto;

  factory TodosResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TodosResponseDtoFromJson(json);
}
