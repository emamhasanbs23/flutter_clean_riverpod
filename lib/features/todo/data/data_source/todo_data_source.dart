import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/model/todo_dto.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/model/todos_response_dto.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/remote/todo_remote_source.dart';

/// Aggregate data-source contract for todo. The repository depends on this
/// type — not on [TodoRemoteSource] directly.
abstract interface class TodoDataSource {
  Future<TodosResponseDto> fetchPage({
    required int limit,
    required int skip,
    CancelToken? cancelToken,
  });
  Future<TodoDto> fetchById(String id, {CancelToken? cancelToken});
  Future<TodoDto> create(String title, {CancelToken? cancelToken});
  Future<TodoDto> toggle(
    String id, {
    required bool completed,
    CancelToken? cancelToken,
  });
  Future<void> delete(String id, {CancelToken? cancelToken});
}
