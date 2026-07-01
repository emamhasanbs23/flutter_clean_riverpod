import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/entity_mappable_options.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/entities/todo.dart';

part 'todo_page.mapper.dart';

/// Default page size for todo list pagination.
abstract final class TodoListPageSize {
  static const defaultLimit = 20;
}

/// A single page of todos plus pagination metadata from the backend.
@MappableClass(generateMethods: entityGenerateMethods)
class TodoPage with TodoPageMappable {
  const TodoPage({
    required this.todos,
    required this.total,
    required this.skip,
    required this.limit,
  });

  final List<Todo> todos;
  final int total;
  final int skip;
  final int limit;

  bool get hasMore => skip + todos.length < total;
}
