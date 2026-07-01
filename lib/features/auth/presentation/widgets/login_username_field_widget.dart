import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';

/// Username field for the login form.
class LoginUsernameFieldWidget extends StatelessWidget {
  const LoginUsernameFieldWidget({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: l10n.loginUsernameLabel,
        prefixIcon: const Icon(Icons.person_outline),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.loginUsernameRequired;
        }
        return null;
      },
    );
  }
}
