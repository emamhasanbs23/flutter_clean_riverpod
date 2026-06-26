import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/repositories/todo_repository.dart';
import 'package:fpdart/fpdart.dart';

class ToggleTodoUseCase {
  ToggleTodoUseCase(this._repository);

  final TodoRepository _repository;

  Future<Either<Failure, Todo>> call(
    String id, {
    required bool completed,
    CancelToken? cancelToken,
  }) => _repository.toggleTodo(
    id,
    completed: completed,
    cancelToken: cancelToken,
  );
}
