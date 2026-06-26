import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';

/// Prompts the user for a new todo title.
class CreateTodoDialog extends StatelessWidget {
  const CreateTodoDialog({required this.controller, super.key});

  final TextEditingController controller;

  static Future<String?> show(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => CreateTodoDialog(controller: controller),
    );
    controller.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.todoListNewTitle),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(hintText: l10n.todoListNewDescription),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.todoListCancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(controller.text),
          child: Text(l10n.todoListCreate),
        ),
      ],
    );
  }
}
