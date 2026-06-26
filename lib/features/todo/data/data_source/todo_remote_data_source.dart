import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/network/network_guard.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/api/todo_api.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/model/todo_dto.dart';

/// Contract every Todo data source must satisfy. The mock implementation
/// in `TodoMockDataSource` and the Retrofit-backed implementation below
/// both satisfy this interface so the repository can swap them via a
/// single provider override.
///
/// Methods accept an optional [CancelToken] so a Riverpod controller can
/// abort the request when its widget is disposed mid-flight.
abstract interface class TodoDataSource {
  Future<List<TodoDto>> fetchAll({CancelToken? cancelToken});
  Future<TodoDto> create(String title, {CancelToken? cancelToken});
  Future<TodoDto> toggle(String id, {CancelToken? cancelToken});
  Future<void> delete(String id, {CancelToken? cancelToken});
}

/// Real network-backed implementation that talks to the configured API
/// through the generated `TodoApi` client.
///
/// Each call is wrapped by `guard` which logs the failure, maps the
/// `DioException` to a domain failure, and rethrows so the repository can
/// build an `Either` without per-endpoint boilerplate.
class TodoRemoteDataSource implements TodoDataSource {
  TodoRemoteDataSource(this._api);

  final TodoApi _api;

  @override
  Future<List<TodoDto>> fetchAll({CancelToken? cancelToken}) => guard(
    'TodoRemoteDataSource.fetchAll',
    () => _api.getTodos(cancelToken: cancelToken),
  );

  @override
  Future<TodoDto> create(String title, {CancelToken? cancelToken}) => guard(
    'TodoRemoteDataSource.create',
    () => _api.createTodo(
      TodoDto(id: '0', title: title),
      cancelToken: cancelToken,
    ),
  );

  @override
  Future<TodoDto> toggle(String id, {CancelToken? cancelToken}) =>
      guard('TodoRemoteDataSource.toggle', () async {
        // jsonplaceholder doesn't accept PATCH, so we PUT the toggled
        // state on the same path. A real backend that supports PATCH
        // can swap the annotation on [TodoApi.updateTodo] without
        // changing call sites.
        final current = await _api.updateTodo(
          id,
          TodoDto(id: id, title: '', completed: true),
          cancelToken: cancelToken,
        );
        return current.copyWith(completed: !current.completed);
      });

  @override
  Future<void> delete(String id, {CancelToken? cancelToken}) => guard(
    'TodoRemoteDataSource.delete',
    () => _api.deleteTodo(id, cancelToken: cancelToken),
  );
}
