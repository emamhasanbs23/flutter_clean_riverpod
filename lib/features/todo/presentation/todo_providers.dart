import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/network/dio_client.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/todo_mock_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/todo_remote_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/todo_repository_impl.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/create_todo_use_case.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/delete_todo_use_case.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/get_todos_use_case.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/toggle_todo_use_case.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/todo_repository.dart';

/// Default data source. Wires [TodoRemoteDataSource] to [dioProvider] so the
/// full Clean Architecture data flow runs end-to-end against a real HTTP API.
///
/// Tests and offline development override this provider with
/// [todoMockDataSourceProvider].
final todoDataSourceProvider = Provider<TodoDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return TodoRemoteDataSource(dio);
});

/// In-memory data source used by tests and as an offline fallback.
///
/// Lives behind its own provider so test setup can inject a zero-latency
/// instance and production can swap in the remote source without code
/// changes.
final todoMockDataSourceProvider = Provider<TodoDataSource>((ref) {
  return TodoMockDataSource();
});

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepositoryImpl(dataSource: ref.watch(todoDataSourceProvider));
});

final getTodosUseCaseProvider = Provider<GetTodosUseCase>((ref) {
  return GetTodosUseCase(ref.watch(todoRepositoryProvider));
});

final createTodoUseCaseProvider = Provider<CreateTodoUseCase>((ref) {
  return CreateTodoUseCase(ref.watch(todoRepositoryProvider));
});

final toggleTodoUseCaseProvider = Provider<ToggleTodoUseCase>((ref) {
  return ToggleTodoUseCase(ref.watch(todoRepositoryProvider));
});

final deleteTodoUseCaseProvider = Provider<DeleteTodoUseCase>((ref) {
  return DeleteTodoUseCase(ref.watch(todoRepositoryProvider));
});

/// Sealed state used by the UI. Each variant tells the page what to render
/// without forcing consumers to handle nulls.
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

/// Manages the list state and exposes mutating methods. Mutations optimistically
/// re-fetch to keep the data source authoritative, which also keeps the
/// implementation simple at the cost of an extra round-trip.
class TodoListController extends AsyncNotifier<TodoListState> {
  @override
  Future<TodoListState> build() async {
    return _load();
  }

  Future<TodoListState> _load() async {
    final result = await ref.read(getTodosUseCaseProvider).call();
    return result.fold(
      (failure) => TodoError(failure),
      (todos) => TodoLoaded(todos),
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.data(TodoLoading());
    state = await AsyncValue.guard(_load);
  }

  Future<void> add(String title) async {
    final result = await ref.read(createTodoUseCaseProvider).call(title);
    if (result.isRight()) {
      await refresh();
    } else {
      state = AsyncValue.data(
        TodoError(result.fold((f) => f, (_) => const UnexpectedFailure())),
      );
    }
  }

  Future<void> toggle(String id) async {
    final result = await ref.read(toggleTodoUseCaseProvider).call(id);
    if (result.isRight()) {
      await refresh();
    }
  }

  Future<void> delete(String id) async {
    final result = await ref.read(deleteTodoUseCaseProvider).call(id);
    if (result.isRight()) {
      await refresh();
    }
  }
}

final todoListControllerProvider =
    AsyncNotifierProvider<TodoListController, TodoListState>(
  TodoListController.new,
);