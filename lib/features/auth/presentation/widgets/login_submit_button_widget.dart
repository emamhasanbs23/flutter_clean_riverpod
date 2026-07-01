import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_size.dart';

/// Submit button for the login form, with a loading spinner while submitting.
class LoginSubmitButtonWidget extends StatelessWidget {
  const LoginSubmitButtonWidget({
    required this.isSubmitting,
    required this.onPressed,
    super.key,
  });

  final bool isSubmitting;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ElevatedButton(
      onPressed: isSubmitting ? null : onPressed,
      child: isSubmitting
          ? SizedBox(
              height: AppSize.progressIndicatorSm,
              width: AppSize.progressIndicatorSm,
              child: const CircularProgressIndicator(
                strokeWidth: AppSize.progressIndicatorStrokeSm,
              ),
            )
          : Text(l10n.loginSubmit),
    );
  }
}
