import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_size.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/widgets/app_loading_indicator.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_list/riverpod/todo_list_providers.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_list/widgets/todo_list_tile_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Scrollable, paginated list of todos.
class TodoListViewWidget extends ConsumerStatefulWidget {
  const TodoListViewWidget({
    required this.todos,
    required this.hasMore,
    required this.isLoadingMore,
    super.key,
  });

  final List<Todo> todos;
  final bool hasMore;
  final bool isLoadingMore;

  @override
  ConsumerState<TodoListViewWidget> createState() => _TodoListViewWidgetState();
}

class _TodoListViewWidgetState extends ConsumerState<TodoListViewWidget> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients ||
        widget.isLoadingMore ||
        !widget.hasMore) {
      return;
    }

    final position = _scrollController.position;
    if (position.pixels >=
        position.maxScrollExtent - AppSize.loadMoreThreshold) {
      unawaited(ref.read(todoListControllerProvider.notifier).loadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    final trailingCount = widget.hasMore ? 1 : 0;

    return ListView.separated(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSize.pagePadding,
      itemCount: widget.todos.length + trailingCount,
      separatorBuilder: (_, _) => SizedBox(height: AppSize.spaceSm),
      itemBuilder: (context, index) {
        if (index >= widget.todos.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.spaceMd),
            child: Center(
              child: SizedBox(
                height: AppSize.progressIndicatorSm,
                width: AppSize.progressIndicatorSm,
                child: const AppLoadingIndicator(),
              ),
            ),
          );
        }

        return TodoListTileWidget(todo: widget.todos[index]);
      },
    );
  }
}
