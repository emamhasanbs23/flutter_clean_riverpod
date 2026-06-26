import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';

/// Sealed state for the todo detail screen.
sealed class TodoDetailState {
  const TodoDetailState();
}

final class TodoDetailInitial extends TodoDetailState {
  const TodoDetailInitial();
}

final class TodoDetailLoading extends TodoDetailState {
  const TodoDetailLoading();
}

final class TodoDetailLoaded extends TodoDetailState {
  const TodoDetailLoaded(this.todo);
  final Todo todo;
}

final class TodoDetailNotFound extends TodoDetailState {
  const TodoDetailNotFound();
}

final class TodoDetailError extends TodoDetailState {
  const TodoDetailError(this.failure);
  final Failure failure;
}
