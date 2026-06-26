import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/repositories/todo_repository.dart';
import 'package:fpdart/fpdart.dart';

class CreateTodoUseCase {
  CreateTodoUseCase(this._repository);

  final TodoRepository _repository;

  Future<Either<Failure, Todo>> call(String title, {CancelToken? cancelToken}) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return Future.value(const Left(NotFoundFailure('Title is required')));
    }
    return _repository.createTodo(trimmed, cancelToken: cancelToken);
  }
}
