import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/repositories/todo_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetTodoUseCase {
  GetTodoUseCase(this._repository);

  final TodoRepository _repository;

  Future<Either<Failure, Todo>> call(String id, {CancelToken? cancelToken}) =>
      _repository.getTodo(id, cancelToken: cancelToken);
}
