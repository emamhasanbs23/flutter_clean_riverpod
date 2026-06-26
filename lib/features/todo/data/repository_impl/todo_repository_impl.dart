import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/data_source/todo_remote_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/mapper/todo_mapper.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/repositories/todo_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Concrete repository backed by any [TodoDataSource] (mock or remote).
///
/// Every method catches data source exceptions and returns an [Either] so
/// callers never have to try/catch. Failures thrown by the data source
/// (via `guard` mapping) are preserved verbatim. A `DioExceptionType.cancel`
/// surfaces as a `NetworkFailure` (via the mapper) which the controller
/// inspects via `_cancelToken.isCancelled` to short-circuit UI updates.
class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl({required TodoDataSource dataSource})
    : _dataSource = dataSource;

  final TodoDataSource _dataSource;

  @override
  Future<Either<Failure, List<Todo>>> getTodos({
    CancelToken? cancelToken,
  }) async {
    try {
      final dtos = await _dataSource.fetchAll(cancelToken: cancelToken);
      return Right(dtos.map((d) => d.toDomain()).toList(growable: false));
    } on Failure catch (failure) {
      return Left(failure);
    } on Object {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Todo>> createTodo(
    String title, {
    CancelToken? cancelToken,
  }) async {
    try {
      final dto = await _dataSource.create(title, cancelToken: cancelToken);
      return Right(dto.toDomain());
    } on Failure catch (failure) {
      return Left(failure);
    } on Object {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Todo>> toggleTodo(
    String id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final dto = await _dataSource.toggle(id, cancelToken: cancelToken);
      return Right(dto.toDomain());
    } on Failure catch (failure) {
      return Left(failure);
    } on Object {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(
    String id, {
    CancelToken? cancelToken,
  }) async {
    try {
      await _dataSource.delete(id, cancelToken: cancelToken);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } on Object {
      return const Left(UnexpectedFailure());
    }
  }
}
