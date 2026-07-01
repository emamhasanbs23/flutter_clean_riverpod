import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/repositories/todo_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteTodoUseCase {
  DeleteTodoUseCase(this._repository);

  final TodoRepository _repository;

  Future<Either<Failure, void>> call(String id, {CancelToken? cancelToken}) =>
      _repository.deleteTodo(id, cancelToken: cancelToken);
}
