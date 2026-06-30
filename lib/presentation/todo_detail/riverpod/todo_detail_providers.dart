import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/riverpod/async_controller_mixins.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/usecases/get_todo_use_case.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_detail/riverpod/todo_detail_state.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_list/riverpod/todo_list_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'todo_detail_state.dart';

part 'todo_detail_providers.g.dart';

@Riverpod(keepAlive: true)
GetTodoUseCase getTodoUseCase(Ref ref) {
  return GetTodoUseCase(ref.watch(todoRepositoryProvider));
}

/// Loads a single todo by id for the detail route. Each route id gets an
/// isolated controller instance via the family parameter.
@riverpod
class TodoDetailController extends _$TodoDetailController
    with
        CancelableControllerMixin,
        RefreshableAsyncControllerMixin<TodoDetailState> {
  @override
  Future<TodoDetailState> build(String id) async {
    initCancelToken(ref);
    return _load(id);
  }

  Future<TodoDetailState> _load(String id) async {
    final result = await ref
        .read(getTodoUseCaseProvider)
        .call(id, cancelToken: cancelToken);
    if (isCancelled) {
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

  Future<void> refresh() => refreshWith(
    loadingState: const TodoDetailLoading(),
    load: () => _load(id),
  );
}
