import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/network/dio_client.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/api/todo_api.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/data_source/todo_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/data_source/todo_data_source_impl.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/mock/todo_mock_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/remote/todo_remote_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/repository_impl/todo_repository_impl.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/repositories/todo_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/usecases/create_todo_use_case.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/usecases/delete_todo_use_case.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/usecases/get_todos_use_case.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/usecases/toggle_todo_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_list_providers.g.dart';

/// Retrofit-generated `TodoApi` bound to the configured `Dio`. Shares the
/// Dio's interceptors (auth + logging) with the rest of the app.
@Riverpod(keepAlive: true)
TodoApi todoApi(Ref ref) {
  return TodoApi(ref.watch(dioProvider));
}

/// Dio-backed [TodoRemoteSource] driven by [todoApiProvider].
@Riverpod(keepAlive: true)
TodoRemoteSource todoRemoteSource(Ref ref) {
  return TodoRemoteSourceImpl(ref.watch(todoApiProvider));
}

/// Default aggregate data source. Wires [TodoDataSourceImpl] to
/// [todoRemoteSourceProvider] so the full Clean Architecture data flow runs
/// end-to-end against a real HTTP API.
///
/// Tests and offline development override this provider with
/// [todoMockSourceProvider].
@Riverpod(keepAlive: true)
TodoDataSource todoDataSource(Ref ref) {
  return TodoDataSourceImpl(ref.watch(todoRemoteSourceProvider));
}

/// In-memory data source used by tests and as an offline fallback.
@Riverpod(keepAlive: true)
TodoDataSource todoMockSource(Ref ref) {
  return TodoMockSource();
}

@Riverpod(keepAlive: true)
TodoRepository todoRepository(Ref ref) {
  return TodoRepositoryImpl(dataSource: ref.watch(todoDataSourceProvider));
}

@Riverpod(keepAlive: true)
GetTodosUseCase getTodosUseCase(Ref ref) {
  return GetTodosUseCase(ref.watch(todoRepositoryProvider));
}

@Riverpod(keepAlive: true)
CreateTodoUseCase createTodoUseCase(Ref ref) {
  return CreateTodoUseCase(ref.watch(todoRepositoryProvider));
}

@Riverpod(keepAlive: true)
ToggleTodoUseCase toggleTodoUseCase(Ref ref) {
  return ToggleTodoUseCase(ref.watch(todoRepositoryProvider));
}

@Riverpod(keepAlive: true)
DeleteTodoUseCase deleteTodoUseCase(Ref ref) {
  return DeleteTodoUseCase(ref.watch(todoRepositoryProvider));
}

/// Sealed state used by the list UI. Each variant tells the page what to
/// render without forcing consumers to handle nulls.
sealed class TodoListState {
  const TodoListState();
}

class TodoInitial extends TodoListState {
  const TodoInitial();
}

class TodoLoading extends TodoListState {
  const TodoLoading();
}

class TodoLoaded extends TodoListState {
  const TodoLoaded(this.todos);
  final List<Todo> todos;
}

class TodoError extends TodoListState {
  /// Carries the domain [Failure] so the page can call
  /// `failure.toMessage(context)` at the render site.
  const TodoError(this.failure);
  final Failure failure;
}

/// Manages the list state and exposes mutating methods. Mutations
/// optimistically re-fetch to keep the data source authoritative, which also
/// keeps the implementation simple at the cost of an extra round-trip.
@Riverpod(keepAlive: true)
class TodoListController extends _$TodoListController {
  /// One [CancelToken] per controller build. We create it on first `build`
  /// and cancel it in `ref.onDispose` so any in-flight request is aborted
  /// when the consumer (typically the page widget) is torn down.
  late final CancelToken _cancelToken;

  @override
  Future<TodoListState> build() async {
    _cancelToken = CancelToken();
    ref.onDispose(_cancelToken.cancel);
    return _load();
  }

  Future<TodoListState> _load() async {
    final result = await ref
        .read(getTodosUseCaseProvider)
        .call(cancelToken: _cancelToken);
    if (_cancelToken.isCancelled) {
      return const TodoInitial();
    }
    return result.fold(TodoError.new, TodoLoaded.new);
  }

  Future<void> refresh() async {
    state = const AsyncValue.data(TodoLoading());
    state = await AsyncValue.guard(_load);
  }

  Future<void> add(String title) async {
    final result = await ref
        .read(createTodoUseCaseProvider)
        .call(title, cancelToken: _cancelToken);
    if (_cancelToken.isCancelled) return;
    result.fold((failure) => state = AsyncValue.data(TodoError(failure)), (
      todo,
    ) {
      final current = state.valueOrNull;
      final updated = switch (current) {
        TodoLoaded(:final todos) => [todo, ...todos],
        _ => [todo],
      };
      state = AsyncValue.data(TodoLoaded(updated));
    });
  }

  Future<void> toggle(String id) async {
    final current = state.valueOrNull;
    if (current is! TodoLoaded) return;

    final index = current.todos.indexWhere((t) => t.id == id);
    if (index < 0) return;

    final targetCompleted = !current.todos[index].completed;
    final result = await ref
        .read(toggleTodoUseCaseProvider)
        .call(id, completed: targetCompleted, cancelToken: _cancelToken);
    if (_cancelToken.isCancelled) return;
    if (result.isRight()) {
      final updated = result.fold((_) => current.todos[index], (todo) => todo);
      final todos = [...current.todos];
      todos[index] = updated;
      state = AsyncValue.data(TodoLoaded(todos));
    }
  }

  Future<void> delete(String id) async {
    final result = await ref
        .read(deleteTodoUseCaseProvider)
        .call(id, cancelToken: _cancelToken);
    if (_cancelToken.isCancelled) return;
    if (result.isRight()) {
      final current = state.valueOrNull;
      if (current is TodoLoaded) {
        final todos = current.todos.where((t) => t.id != id).toList();
        state = AsyncValue.data(TodoLoaded(todos));
      }
    }
  }
}
