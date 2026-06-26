import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/pending_navigation_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_size.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/presentation/riverpod/auth_providers.dart';

/// Email/password sign-in page.
///
/// All state lives in [loginControllerProvider]; this widget is intentionally
/// thin and free of business logic.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'demo@example.com');
  final _passwordController = TextEditingController(text: 'password');

  @override
  void dispose() {
    _emailController.dispose();
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
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (!success) {
      if (!mounted) return;
      // Read the failure (if any) from the controller state and localize
      // it via the Failure.toMessage pipeline. Falls back to the generic
      // invalid-credentials string if the state has changed.
      final state = ref.read(loginControllerProvider);
      final text = state is LoginError
          ? state.failure.toMessage(context)
          : l10n.loginInvalidCredentials;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(text)));
      return;
    }
    // Login succeeded. If the user got here via a deep link or push
    // notification, replay that destination instead of letting the
    // auth-guard redirect them to /. We only touch the router when
    // there's actually a pending destination — the no-pending case
    // continues to rely on the router's auth-guard redirect so the
    // existing test setup (which pumps LoginPage without a GoRouter
    // ancestor) keeps working.
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
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: AppSize.space2xl),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: l10n.loginEmailLabel,
                        prefixIcon: const Icon(Icons.alternate_email),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.loginEmailRequired;
                        }
                        if (!value.contains('@')) {
                          return l10n.loginEmailInvalid;
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
                      style: Theme.of(context).textTheme.bodySmall,
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
