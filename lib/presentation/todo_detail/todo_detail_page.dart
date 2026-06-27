import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/widgets/app_error_widget.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/widgets/app_loading_indicator.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/widgets/async_value_widget.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_detail/riverpod/todo_detail_providers.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_detail/widgets/todo_detail_card_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Detail page for a single Todo, reached via `/todos/:id` (deep link, push
/// notification, or in-app navigation from the list).
///
/// Fetches the todo by id via the detail use case so cold opens work without
/// loading the list first.
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
    final asyncState = ref.watch(todoDetailControllerProvider(id));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.todoDetailTitle)),
      body: AsyncValueWidget(
        value: asyncState,
        onRetry: () =>
            ref.read(todoDetailControllerProvider(id).notifier).refresh(),
        data: (state) => switch (state) {
          TodoDetailInitial() ||
          TodoDetailLoading() => const AppLoadingIndicator(),
          TodoDetailLoaded(:final todo) => TodoDetailCardWidget(
            todo: todo,
            highlightTitle: extra?['focus'] == _focusTitleKey,
          ),
          TodoDetailNotFound() => AppErrorWidget(
            message: l10n.errorNotFound,
            onRetry: () =>
                ref.read(todoDetailControllerProvider(id).notifier).refresh(),
          ),
          TodoDetailError(:final failure) => AppErrorWidget(
            failure: failure,
            onRetry: () =>
                ref.read(todoDetailControllerProvider(id).notifier).refresh(),
          ),
        },
      ),
    );
  }
}
