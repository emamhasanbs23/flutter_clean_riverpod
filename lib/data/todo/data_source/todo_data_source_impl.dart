import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/data/todo/data_source/todo_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/model/todo_dto.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/remote/todo_remote_source.dart';

/// Facade that delegates todo network calls to [TodoRemoteSource].
class TodoDataSourceImpl implements TodoDataSource {
  TodoDataSourceImpl(this._remoteSource);

  final TodoRemoteSource _remoteSource;

  @override
  Future<List<TodoDto>> fetchAll({CancelToken? cancelToken}) =>
      _remoteSource.fetchAll(cancelToken: cancelToken);

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
