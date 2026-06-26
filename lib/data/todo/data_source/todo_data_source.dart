import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/data/todo/model/todo_dto.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/remote/todo_remote_source.dart';

/// Aggregate data-source contract for todo. The repository depends on this
/// type — not on [TodoRemoteSource] directly.
abstract interface class TodoDataSource {
  Future<List<TodoDto>> fetchAll({CancelToken? cancelToken});
  Future<TodoDto> fetchById(String id, {CancelToken? cancelToken});
  Future<TodoDto> create(String title, {CancelToken? cancelToken});
  Future<TodoDto> toggle(
    String id, {
    required bool completed,
    CancelToken? cancelToken,
  });
  Future<void> delete(String id, {CancelToken? cancelToken});
}
