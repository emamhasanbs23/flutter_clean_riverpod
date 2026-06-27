import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_size.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/theme_context_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_detail/widgets/todo_status_row_widget.dart';

/// Card body for a single todo on the detail page.
class TodoDetailCardWidget extends StatelessWidget {
  const TodoDetailCardWidget({
    required this.todo,
    required this.highlightTitle,
    super.key,
  });

  final Todo todo;
  final bool highlightTitle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final baseTitle = context.textTheme.headlineSmall;
    final titleStyle = baseTitle?.copyWith(
      color: highlightTitle ? context.colors.primary : null,
      fontWeight: highlightTitle ? FontWeight.bold : baseTitle.fontWeight,
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: AppSize.maxContentWidth),
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
                    l10n.todoDetailIdLabel(todo.id),
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colors.outline,
                    ),
                  ),
                  SizedBox(height: AppSize.spaceSm),
                  Text(
                    todo.title,
                    style: todo.completed
                        ? context.textStyles.strikeThrough
                        : titleStyle,
                  ),
                  SizedBox(height: AppSize.spaceLg),
                  TodoStatusRowWidget(completed: todo.completed),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
