import 'package:flutter_clean_riverpod_boilerplate/data/todo/model/todo_dto.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';

/// Bidirectional mapper between [TodoDto] (wire format) and [Todo] (domain).
extension TodoDtoMapper on TodoDto {
  Todo toDomain() => Todo(id: id.toString(), title: todo, completed: completed);
}

extension TodoDomainMapper on Todo {
  TodoDto toDto() =>
      TodoDto(id: int.tryParse(id) ?? 0, todo: title, completed: completed);
}
