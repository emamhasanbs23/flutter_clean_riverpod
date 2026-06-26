import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/pending_navigation_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_size.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/theme_context_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/presentation/riverpod/auth_providers.dart';
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
    final l10n = context.l10n;
    final state = ref.watch(loginControllerProvider);
    final isSubmitting = state is LoginSubmitting;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSize.pagePadding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.loginTitle,
                      style: context.textTheme.headlineMedium,
                    ),
                    SizedBox(height: AppSize.space2xl),
                    TextFormField(
                      controller: _usernameController,
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
                    ),
                    SizedBox(height: AppSize.spaceLg),
                    TextFormField(
                      controller: _passwordController,
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
                    ),
                    SizedBox(height: AppSize.space2xl),
                    ElevatedButton(
                      onPressed: isSubmitting ? null : _submit,
                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.loginSubmit),
                    ),
                    SizedBox(height: AppSize.spaceLg),
                    Text(
                      l10n.loginDemoHint,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
