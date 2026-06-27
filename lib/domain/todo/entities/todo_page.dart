import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';

/// Default page size for todo list pagination.
abstract final class TodoListPageSize {
  static const defaultLimit = 20;
}

/// A single page of todos plus pagination metadata from the backend.
final class TodoPage {
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
