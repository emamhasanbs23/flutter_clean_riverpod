import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/network/network_guard.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/api/todo_api.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/model/todo_dto.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/model/todos_response_dto.dart';

/// Network-side contract for todo.
abstract interface class TodoRemoteSource {
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

/// Real network-backed implementation that talks to DummyJSON through the
/// generated [TodoApi] client.
///
/// DummyJSON simulates writes — `add` / `update` / `delete` echo a response
/// but never mutate server state. Callers must update local UI optimistically
/// rather than re-fetching the list after a mutation.
class TodoRemoteSourceImpl implements TodoRemoteSource {
  TodoRemoteSourceImpl(this._api);

  /// Fallback until the authenticated user id is wired from auth.
  static const defaultUserId = 1;

  final TodoApi _api;

  @override
  Future<TodosResponseDto> fetchPage({
    required int limit,
    required int skip,
    CancelToken? cancelToken,
  }) => guard(
    'TodoRemoteSource.fetchPage',
    () => _api.getTodos(limit: limit, skip: skip, cancelToken: cancelToken),
  );

  @override
  Future<TodoDto> fetchById(String id, {CancelToken? cancelToken}) => guard(
    'TodoRemoteSource.fetchById',
    () => _api.getTodo(id, cancelToken: cancelToken),
  );

  @override
  Future<TodoDto> create(String title, {CancelToken? cancelToken}) => guard(
    'TodoRemoteSource.create',
    () => _api.createTodo(
      CreateTodoRequestDto(todo: title, userId: defaultUserId),
      cancelToken: cancelToken,
    ),
  );

  @override
  Future<TodoDto> toggle(
    String id, {
    required bool completed,
    CancelToken? cancelToken,
  }) => guard(
    'TodoRemoteSource.toggle',
    () => _api.updateTodo(
      id,
      UpdateTodoRequestDto(completed: completed),
      cancelToken: cancelToken,
    ),
  );

  @override
  Future<void> delete(String id, {CancelToken? cancelToken}) =>
      guard('TodoRemoteSource.delete', () async {
        await _api.deleteTodo(id, cancelToken: cancelToken);
      });
}
