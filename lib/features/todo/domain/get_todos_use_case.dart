import 'package:fpdart/fpdart.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/todo_repository.dart';

class GetTodosUseCase {
  GetTodosUseCase(this._repository);

  final TodoRepository _repository;

  Future<Either<Failure, List<Todo>>> call() => _repository.getTodos();
}
