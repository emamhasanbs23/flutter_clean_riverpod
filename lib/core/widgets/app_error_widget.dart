import 'package:flutter/material.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_size.dart';

/// Generic full-bleed error placeholder with an optional retry action.
///
/// Pass either [message] (already localized) or [failure] (which will be
/// localized via `failure.toMessage(context)`). When both are present,
/// [message] wins so callers can override the localized string with a more
/// specific one.
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    this.message,
    this.failure,
    this.onRetry,
  }) : assert(
          message != null || failure != null || onRetry != null,
          'Provide message, failure, or onRetry',
        );

  /// Pre-localized error message. Takes precedence over [failure].
  final String? message;

  /// Domain [Failure] whose message will be resolved via
  /// `failure.toMessage(context)`.
  final Failure? failure;

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final text = message ??
        failure?.toMessage(context) ??
        l10n.errorUnexpected;

    return Center(
      child: Padding(
        padding: AppSize.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: AppSize.iconLg,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: AppSize.spaceLg),
            Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              SizedBox(height: AppSize.spaceLg),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(l10n.commonRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}