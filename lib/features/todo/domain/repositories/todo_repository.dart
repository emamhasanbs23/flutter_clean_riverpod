import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/entities/todo.dart';
import 'package:fpdart/fpdart.dart';

/// Contract for any Todo data source. The mock implementation and a future
/// REST implementation both satisfy this interface, so swapping is just a
/// provider override.
abstract interface class TodoRepository {
  Future<Either<Failure, List<Todo>>> getTodos();
  Future<Either<Failure, Todo>> createTodo(String title);
  Future<Either<Failure, Todo>> toggleTodo(String id);
  Future<Either<Failure, void>> deleteTodo(String id);
}
