import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo_page.dart';
import 'package:fpdart/fpdart.dart';

/// Contract for any Todo data source. The mock implementation and a future
/// REST implementation both satisfy this interface, so swapping is just a
/// provider override.
///
/// All methods accept an optional `CancelToken` so a Riverpod controller
/// can abort the underlying request when its widget is disposed mid-flight.
/// Domain layer does not depend on `dio` for behavior — only the type
/// signature — so the dependency direction stays one-way.
abstract interface class TodoRepository {
  Future<Either<Failure, TodoPage>> getTodos({
    int limit = TodoListPageSize.defaultLimit,
    int skip = 0,
    CancelToken? cancelToken,
  });
  Future<Either<Failure, Todo>> getTodo(String id, {CancelToken? cancelToken});
  Future<Either<Failure, Todo>> createTodo(
    String title, {
    CancelToken? cancelToken,
  });
  Future<Either<Failure, Todo>> toggleTodo(
    String id, {
    required bool completed,
    CancelToken? cancelToken,
  });
  Future<Either<Failure, void>> deleteTodo(
    String id, {
    CancelToken? cancelToken,
  });
}
