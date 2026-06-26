import 'package:fpdart/fpdart.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/repositories/todo_repository.dart';

class ToggleTodoUseCase {
  ToggleTodoUseCase(this._repository);

  final TodoRepository _repository;

  Future<Either<Failure, Todo>> call(String id) => _repository.toggleTodo(id);
}
