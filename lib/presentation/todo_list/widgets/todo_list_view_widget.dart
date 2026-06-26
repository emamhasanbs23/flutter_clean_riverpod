import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_size.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_list/widgets/todo_list_tile_widget.dart';

/// Scrollable list of todos.
class TodoListViewWidget extends StatelessWidget {
  const TodoListViewWidget({required this.todos, super.key});

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: AppSize.pagePadding,
      itemCount: todos.length,
      separatorBuilder: (_, __) => SizedBox(height: AppSize.spaceSm),
      itemBuilder: (context, index) => TodoListTileWidget(todo: todos[index]),
    );
  }
}
