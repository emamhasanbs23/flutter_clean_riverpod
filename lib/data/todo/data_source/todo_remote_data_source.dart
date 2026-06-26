import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/network/network_guard.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/api/todo_api.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/model/todo_dto.dart';

/// Contract every Todo data source must satisfy. The mock implementation
/// in `TodoMockDataSource` and the Retrofit-backed implementation below
/// both satisfy this interface so the repository can swap them via a
/// single provider override.
abstract interface class TodoDataSource {
  Future<List<TodoDto>> fetchAll({CancelToken? cancelToken});
  Future<TodoDto> create(String title, {CancelToken? cancelToken});
  Future<TodoDto> toggle(
    String id, {
    required bool completed,
    CancelToken? cancelToken,
  });
  Future<void> delete(String id, {CancelToken? cancelToken});
}

/// Real network-backed implementation that talks to DummyJSON through the
/// generated `TodoApi` client.
///
/// DummyJSON simulates writes — `add` / `update` / `delete` echo a response
/// but never mutate server state. Callers must update local UI optimistically
/// rather than re-fetching the list after a mutation.
class TodoRemoteDataSource implements TodoDataSource {
  TodoRemoteDataSource(this._api);

  /// Fallback until the authenticated user id is wired from auth.
  static const defaultUserId = 1;

  final TodoApi _api;

  @override
  Future<List<TodoDto>> fetchAll({CancelToken? cancelToken}) =>
      guard('TodoRemoteDataSource.fetchAll', () async {
        final response = await _api.getTodos(cancelToken: cancelToken);
        return response.todos;
      });

  @override
  Future<TodoDto> create(String title, {CancelToken? cancelToken}) => guard(
    'TodoRemoteDataSource.create',
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
    'TodoRemoteDataSource.toggle',
    () => _api.updateTodo(
      id,
      UpdateTodoRequestDto(completed: completed),
      cancelToken: cancelToken,
    ),
  );

  @override
  Future<void> delete(String id, {CancelToken? cancelToken}) =>
      guard('TodoRemoteDataSource.delete', () async {
        await _api.deleteTodo(id, cancelToken: cancelToken);
      });
}
