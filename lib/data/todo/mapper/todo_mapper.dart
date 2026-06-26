import 'package:flutter_clean_riverpod_boilerplate/data/todo/model/todo_dto.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/model/todos_response_dto.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo_page.dart';

/// Bidirectional mapper between [TodoDto] (wire format) and [Todo] (domain).
extension TodoDtoMapper on TodoDto {
  Todo toDomain() => Todo(id: id.toString(), title: todo, completed: completed);
}

extension TodoDomainMapper on Todo {
  TodoDto toDto() =>
      TodoDto(id: int.tryParse(id) ?? 0, todo: title, completed: completed);
}

extension TodosResponseDtoMapper on TodosResponseDto {
  TodoPage toDomain() => TodoPage(
    todos: todos.map((d) => d.toDomain()).toList(growable: false),
    total: total,
    skip: skip,
    limit: limit,
  );
}
