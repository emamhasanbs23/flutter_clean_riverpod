import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo_page.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/repositories/todo_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetTodosUseCase {
  GetTodosUseCase(this._repository);

  final TodoRepository _repository;

  Future<Either<Failure, TodoPage>> call({
    int limit = TodoListPageSize.defaultLimit,
    int skip = 0,
    CancelToken? cancelToken,
  }) =>
      _repository.getTodos(limit: limit, skip: skip, cancelToken: cancelToken);
}
