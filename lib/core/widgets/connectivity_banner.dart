import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/connectivity/connectivity_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_size.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/theme_context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Top-of-screen banner shown when the device has no connectivity.
///
/// Listens to [connectivityStreamProvider] so it animates in/out as the
/// network state changes. The banner does not block user interaction; it is
/// intentionally non-modal.
class ConnectivityBanner extends ConsumerWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStatus = ref.watch(connectivityStreamProvider);
    final isOnline = asyncStatus.maybeWhen(
      data: (online) => online,
      orElse: () => true,
    );

    if (isOnline) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final dangerColor = context.semantic.danger;

    return Material(
      color: dangerColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.spaceLg,
            vertical: AppSize.spaceSm,
          ),
          child: Row(
            children: [
              const Icon(Icons.wifi_off, color: Colors.white, size: 18),
              SizedBox(width: AppSize.spaceSm),
              Expanded(
                child: Text(
                  l10n.connectivityOffline,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => ref.invalidate(connectivityStreamProvider),
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: Text(l10n.connectivityRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
