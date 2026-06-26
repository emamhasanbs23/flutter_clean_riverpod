import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_size.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_theme.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/widgets/app_error_widget.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/widgets/app_loading_indicator.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/presentation/riverpod/auth_providers.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/presentation/riverpod/todo_providers.dart';
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
        actions: [
          IconButton(
            tooltip: l10n.logout,
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(logoutControllerProvider).call();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, ref),
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
            TodoLoaded(:final todos) when todos.isEmpty => _EmptyState(
                message: l10n.todoListEmpty,
              ),
            TodoLoaded(:final todos) => _TodoList(todos: todos),
          },
        ),
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.todoListNewTitle),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: l10n.todoListNewDescription,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.todoListCancel),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text),
              child: Text(l10n.todoListCreate),
            ),
          ],
        );
      },
    );

    if (result != null && result.trim().isNotEmpty) {
      await ref.read(todoListControllerProvider.notifier).add(result);
    }
    controller.dispose();
  }
}

class _TodoList extends ConsumerWidget {
  const _TodoList({required this.todos});

  final List<Todo> todos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return ListView.separated(
      padding: AppSize.pagePadding,
      itemCount: todos.length,
      separatorBuilder: (_, __) => SizedBox(height: AppSize.spaceSm),
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          child: ListTile(
            contentPadding: AppSize.cardPadding,
            leading: Checkbox(
              value: todo.completed,
              onChanged: (_) => ref
                  .read(todoListControllerProvider.notifier)
                  .toggle(todo.id),
            ),
            title: Text(
              todo.title,
              style: todo.completed
                  ? Theme.of(context)
                      .extension<AppCustomTextStyles>()
                      ?.strikeThrough
                  : null,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.todoListDelete,
              onPressed: () async {
                final confirmed = await _confirmDelete(context);
                if (confirmed ?? false) {
                  await ref
                      .read(todoListControllerProvider.notifier)
                      .delete(todo.id);
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    final l10n = context.l10n;
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: Text(l10n.todoListDeleteConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.todoListCancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.todoListDelete),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ListView(
      // ListView so RefreshIndicator can still drag-to-refresh an empty list.
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.25),
        Center(
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
