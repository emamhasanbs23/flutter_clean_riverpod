import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/data_source/todo_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/model/todo_dto.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/model/todos_response_dto.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/remote/todo_remote_source.dart';

/// Facade that delegates todo network calls to [TodoRemoteSource].
class TodoDataSourceImpl implements TodoDataSource {
  TodoDataSourceImpl(this._remoteSource);

  final TodoRemoteSource _remoteSource;

  @override
  Future<TodosResponseDto> fetchPage({
    required int limit,
    required int skip,
    CancelToken? cancelToken,
  }) => _remoteSource.fetchPage(
    limit: limit,
    skip: skip,
    cancelToken: cancelToken,
  );

  @override
  Future<TodoDto> fetchById(String id, {CancelToken? cancelToken}) =>
      _remoteSource.fetchById(id, cancelToken: cancelToken);

  @override
  Future<TodoDto> create(String title, {CancelToken? cancelToken}) =>
      _remoteSource.create(title, cancelToken: cancelToken);

  @override
  Future<TodoDto> toggle(
    String id, {
    required bool completed,
    CancelToken? cancelToken,
  }) =>
      _remoteSource.toggle(id, completed: completed, cancelToken: cancelToken);

  @override
  Future<void> delete(String id, {CancelToken? cancelToken}) =>
      _remoteSource.delete(id, cancelToken: cancelToken);
}
