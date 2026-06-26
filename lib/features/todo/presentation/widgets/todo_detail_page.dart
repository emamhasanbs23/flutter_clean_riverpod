import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_size.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_theme.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/widgets/app_error_widget.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/widgets/app_loading_indicator.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/presentation/riverpod/todo_providers.dart';

/// Detail page for a single Todo, reached via `/todos/:id` (e.g. from a
/// deep link or push notification payload of `{"route": "/todos/42"}`).
///
/// This page exists primarily to demonstrate path-param + `extra` routing
/// in the boilerplate. It reads the cached [todoListControllerProvider]
/// rather than firing a fresh request, so a tap from a push notification
/// that arrives while the list is already on screen is instant.
class TodoDetailPage extends ConsumerWidget {
  const TodoDetailPage({required this.id, this.extra, super.key});

  /// Path-parameter extracted from the route (e.g. `/todos/42` -> `id=42`).
  final String id;

  /// Optional payload forwarded as `GoRouter.state.extra`. Populated by
  /// push notifications (`extra_focus: "title"`) and any internal callers
  /// that want to direct attention to a specific field.
  final Map<String, Object?>? extra;

  /// When `extra["focus"]` equals this value, the title is rendered with
  /// the theme's primary accent so it stands out on cold open.
  static const _focusTitleKey = 'title';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final asyncState = ref.watch(todoListControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.todoListTitle)),
      body: asyncState.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () =>
              ref.read(todoListControllerProvider.notifier).refresh(),
        ),
        data: (state) {
          final todos = switch (state) {
            TodoLoaded(:final todos) => todos,
            _ => const <Todo>[],
          };
          final match = _findTodo(todos, id);
          if (match == null) {
            return AppErrorWidget(
              message: l10n.errorNotFound,
              onRetry: () =>
                  ref.read(todoListControllerProvider.notifier).refresh(),
            );
          }
          return _Detail(
            todo: match,
            highlightTitle: extra?['focus'] == _focusTitleKey,
            theme: theme,
          );
        },
      ),
    );
  }

  static Todo? _findTodo(List<Todo> todos, String id) {
    for (final todo in todos) {
      if (todo.id == id) return todo;
    }
    return null;
  }
}

class _Detail extends StatelessWidget {
  const _Detail({
    required this.todo,
    required this.highlightTitle,
    required this.theme,
  });

  final Todo todo;
  final bool highlightTitle;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final baseTitle = theme.textTheme.headlineSmall;
    final titleStyle = baseTitle?.copyWith(
      color: highlightTitle ? theme.colorScheme.primary : null,
      fontWeight: highlightTitle ? FontWeight.bold : baseTitle.fontWeight,
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: AppSize.pagePadding,
          child: Card(
            child: Padding(
              padding: AppSize.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Todo #${todo.id}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  SizedBox(height: AppSize.spaceSm),
                  Text(
                    todo.title,
                    style: todo.completed
                        ? theme.extension<AppCustomTextStyles>()?.strikeThrough
                        : titleStyle,
                  ),
                  SizedBox(height: AppSize.spaceLg),
                  Row(
                    children: [
                      Icon(
                        todo.completed
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        size: AppSize.iconMd,
                        color: todo.completed
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                      ),
                      SizedBox(width: AppSize.spaceSm),
                      Text(
                        todo.completed ? 'Completed' : 'Pending',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  if (todo.createdAt != null) ...[
                    SizedBox(height: AppSize.spaceMd),
                    Text(
                      'Created ${todo.createdAt!.toLocal()}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
