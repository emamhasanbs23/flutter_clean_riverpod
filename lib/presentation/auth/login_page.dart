import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/pending_navigation_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_size.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/auth/riverpod/auth_providers.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/auth/widgets/login_form_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Username/password sign-in page.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspass');

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final success = await ref
        .read(loginControllerProvider.notifier)
        .submit(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );
    if (!success) {
      if (!mounted) return;
      final state = ref.read(loginControllerProvider);
      final text = state is LoginError
          ? state.failure.toMessage(context)
          : l10n.loginInvalidCredentials;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(text)));
      return;
    }
    if (!mounted) return;
    final pending = ref.read(pendingNavigationProvider.notifier).consume();
    if (pending != null) {
      context.go(pending.toLocation(), extra: pending.extra);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    final isSubmitting = state is LoginSubmitting;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSize.pagePadding,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: AppSize.maxContentWidth),
              child: LoginFormWidget(
                args: LoginFormWidgetArgs(
                  formKey: _formKey,
                  usernameController: _usernameController,
                  passwordController: _passwordController,
                  isSubmitting: isSubmitting,
                  onSubmit: _submit,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
