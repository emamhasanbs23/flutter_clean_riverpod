import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/model/todo_dto.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/entities/todo.dart';

/// Bidirectional mapper between [TodoDto] (wire format) and [Todo] (domain).
///
/// Keeping the conversion in one place means the domain never has to import
/// `json_serializable` types — and the wire format can evolve independently
/// of the domain shape.
extension TodoDtoMapper on TodoDto {
  Todo toDomain() => Todo(
        id: id,
        title: title,
        completed: completed,
        createdAt: createdAt,
      );
}

extension TodoDomainMapper on Todo {
  TodoDto toDto() => TodoDto(
        id: id,
        title: title,
        completed: completed,
        createdAt: createdAt,
      );
}
