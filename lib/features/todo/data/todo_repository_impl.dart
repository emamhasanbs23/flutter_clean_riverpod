import 'package:fpdart/fpdart.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/todo_mapper.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/todo_remote_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/todo_repository.dart';

/// Concrete repository backed by any [TodoDataSource] (mock or remote).
///
/// Every method catches data source exceptions and returns an [Either] so
/// callers never have to try/catch. [Failure] subtypes thrown by the data
/// source (e.g. [NetworkFailure] from the Dio mapper) are preserved verbatim.
class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl({required TodoDataSource dataSource})
      : _dataSource = dataSource;

  final TodoDataSource _dataSource;

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      final dtos = await _dataSource.fetchAll();
      return Right(dtos.map((d) => d.toDomain()).toList(growable: false));
    } on Failure catch (failure) {
      return Left(failure);
    } on StateError catch (e) {
      return Left(NotFoundFailure(e.message));
    } on Object {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Todo>> createTodo(String title) async {
    try {
      final dto = await _dataSource.create(title);
      return Right(dto.toDomain());
    } on Failure catch (failure) {
      return Left(failure);
    } on Object {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Todo>> toggleTodo(String id) async {
    try {
      final dto = await _dataSource.toggle(id);
      return Right(dto.toDomain());
    } on Failure catch (failure) {
      return Left(failure);
    } on StateError catch (e) {
      return Left(NotFoundFailure(e.message));
    } on Object {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(String id) async {
    try {
      await _dataSource.delete(id);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } on StateError catch (e) {
      return Left(NotFoundFailure(e.message));
    } on Object {
      return const Left(UnexpectedFailure());
    }
  }
}