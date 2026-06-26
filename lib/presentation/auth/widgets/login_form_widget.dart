import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_size.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/theme_context_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/auth/widgets/login_password_field_widget.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/auth/widgets/login_submit_button_widget.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/auth/widgets/login_username_field_widget.dart';

/// Form fields and submit button for the login page.
class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({required this.args, super.key});

  final LoginFormWidgetArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Form(
      key: args.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.loginTitle, style: context.textTheme.headlineMedium),
          SizedBox(height: AppSize.space2xl),
          LoginUsernameFieldWidget(controller: args.usernameController),
          SizedBox(height: AppSize.spaceLg),
          LoginPasswordFieldWidget(controller: args.passwordController),
          SizedBox(height: AppSize.space2xl),
          LoginSubmitButtonWidget(
            isSubmitting: args.isSubmitting,
            onPressed: args.onSubmit,
          ),
          SizedBox(height: AppSize.spaceLg),
          Text(
            l10n.loginDemoHint,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// Inputs for [LoginFormWidget].
class LoginFormWidgetArgs {
  const LoginFormWidgetArgs({
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isSubmitting;
  final VoidCallback onSubmit;
}
