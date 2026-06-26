import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/usecases/get_todo_use_case.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_list/riverpod/todo_list_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_detail_providers.g.dart';

@Riverpod(keepAlive: true)
GetTodoUseCase getTodoUseCase(Ref ref) {
  return GetTodoUseCase(ref.watch(todoRepositoryProvider));
}

/// Sealed state for the todo detail screen.
sealed class TodoDetailState {
  const TodoDetailState();
}

final class TodoDetailInitial extends TodoDetailState {
  const TodoDetailInitial();
}

final class TodoDetailLoading extends TodoDetailState {
  const TodoDetailLoading();
}

final class TodoDetailLoaded extends TodoDetailState {
  const TodoDetailLoaded(this.todo);
  final Todo todo;
}

final class TodoDetailNotFound extends TodoDetailState {
  const TodoDetailNotFound();
}

final class TodoDetailError extends TodoDetailState {
  const TodoDetailError(this.failure);
  final Failure failure;
}

/// Loads a single todo by id for the detail route. Each route id gets an
/// isolated controller instance via the family parameter.
@riverpod
class TodoDetailController extends _$TodoDetailController {
  late final CancelToken _cancelToken;

  @override
  Future<TodoDetailState> build(String id) async {
    _cancelToken = CancelToken();
    ref.onDispose(_cancelToken.cancel);
    return _load(id);
  }

  Future<TodoDetailState> _load(String id) async {
    final result = await ref
        .read(getTodoUseCaseProvider)
        .call(id, cancelToken: _cancelToken);
    if (_cancelToken.isCancelled) {
      return const TodoDetailInitial();
    }
    return result.fold(
      (failure) => switch (failure) {
        NotFoundFailure() => const TodoDetailNotFound(),
        _ => TodoDetailError(failure),
      },
      TodoDetailLoaded.new,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.data(TodoDetailLoading());
    state = await AsyncValue.guard(() => _load(id));
  }
}
