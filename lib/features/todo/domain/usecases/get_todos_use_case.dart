import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/repositories/todo_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetTodosUseCase {
  GetTodosUseCase(this._repository);

  final TodoRepository _repository;

  Future<Either<Failure, List<Todo>>> call() => _repository.getTodos();
}
