import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/widgets/app_error_widget.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/widgets/app_loading_indicator.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_list/riverpod/todo_list_providers.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_list/widgets/dialogs/create_todo_dialog.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_list/widgets/todo_app_bar_actions_widget.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_list/widgets/todo_empty_state_widget.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_list/widgets/todo_list_view_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Renders the list of todos with sealed-state rendering and a logout action
/// in the app bar.
class TodoListPage extends ConsumerWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final asyncState = ref.watch(todoListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.todoListTitle),
        actions: const [TodoAppBarActionsWidget()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createTodo(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.todoListAdd),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(todoListControllerProvider.notifier).refresh(),
        child: asyncState.when(
          loading: () => const AppLoadingIndicator(),
          error: (error, _) => AppErrorWidget(
            failure: UnexpectedFailure(error.toString()),
            onRetry: () =>
                ref.read(todoListControllerProvider.notifier).refresh(),
          ),
          data: (state) => switch (state) {
            TodoInitial() || TodoLoading() => const AppLoadingIndicator(),
            TodoError(:final failure) => AppErrorWidget(
              failure: failure,
              onRetry: () =>
                  ref.read(todoListControllerProvider.notifier).refresh(),
            ),
            TodoLoaded(:final todos) when todos.isEmpty =>
              TodoEmptyStateWidget(message: l10n.todoListEmpty),
            TodoLoaded(:final todos, :final hasMore, :final isLoadingMore) =>
              TodoListViewWidget(
                todos: todos,
                hasMore: hasMore,
                isLoadingMore: isLoadingMore,
              ),
          },
        ),
      ),
    );
  }

  Future<void> _createTodo(BuildContext context, WidgetRef ref) async {
    final result = await CreateTodoDialog.show(context);
    if (result != null && result.trim().isNotEmpty) {
      await ref.read(todoListControllerProvider.notifier).add(result);
    }
  }
}
