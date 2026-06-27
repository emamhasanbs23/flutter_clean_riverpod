import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/router/todo_routes.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_size.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/theme_context_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_list/riverpod/todo_list_providers.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_list/widgets/dialogs/confirm_delete_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// A single todo row with toggle and delete actions.
class TodoListTileWidget extends ConsumerWidget {
  const TodoListTileWidget({required this.todo, super.key});

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Card(
      child: ListTile(
        contentPadding: AppSize.cardPadding,
        leading: Checkbox(
          value: todo.completed,
          onChanged: (_) =>
              ref.read(todoListControllerProvider.notifier).toggle(todo.id),
        ),
        title: Text(
          todo.title,
          style: todo.completed ? context.textStyles.strikeThrough : null,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: l10n.todoListDelete,
          onPressed: () async {
            final confirmed = await ConfirmDeleteDialog.show(context);
            if (confirmed ?? false) {
              await ref
                  .read(todoListControllerProvider.notifier)
                  .delete(todo.id);
            }
          },
        ),
        onTap: () => context.pushNamed(
          TodoRoutes.detail,
          pathParameters: {'id': todo.id},
        ),
      ),
    );
  }
}
