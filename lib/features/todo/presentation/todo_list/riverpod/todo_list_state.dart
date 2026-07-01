import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/entities/todo.dart';

/// Sealed state used by the list UI. Each variant tells the page what to
/// render without forcing consumers to handle nulls.
sealed class TodoListState {
  const TodoListState();
}

class TodoInitial extends TodoListState {
  const TodoInitial();
}

class TodoLoading extends TodoListState {
  const TodoLoading();
}

class TodoLoaded extends TodoListState {
  const TodoLoaded({
    required this.todos,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<Todo> todos;
  final bool hasMore;
  final bool isLoadingMore;

  TodoLoaded copyWith({
    List<Todo>? todos,
    bool? hasMore,
    bool? isLoadingMore,
  }) => TodoLoaded(
    todos: todos ?? this.todos,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

class TodoError extends TodoListState {
  /// Carries the domain [Failure] so the page can call
  /// `failure.toMessage(context)` at the render site.
  const TodoError(this.failure);
  final Failure failure;
}
