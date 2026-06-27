import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';

/// Password field for the login form.
class LoginPasswordFieldWidget extends StatelessWidget {
  const LoginPasswordFieldWidget({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: l10n.loginPasswordLabel,
        prefixIcon: const Icon(Icons.lock_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.loginPasswordRequired;
        }
        if (value.length < 6) {
          return l10n.loginPasswordTooShort;
        }
        return null;
      },
    );
  }
}
