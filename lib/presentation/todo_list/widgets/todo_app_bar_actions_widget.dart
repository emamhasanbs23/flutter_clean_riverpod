import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/theme_mode_controller.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/auth/riverpod/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Theme toggle and logout actions for the todo list app bar.
class TodoAppBarActionsWidget extends ConsumerWidget {
  const TodoAppBarActionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final themeMode = ref.watch(themeModeControllerProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: switch (themeMode) {
            ThemeMode.dark => l10n.themeToggleLight,
            ThemeMode.light => l10n.themeToggleDark,
            ThemeMode.system => l10n.themeToggleSystem,
          },
          icon: Icon(switch (themeMode) {
            ThemeMode.dark => Icons.light_mode_outlined,
            ThemeMode.light => Icons.dark_mode_outlined,
            ThemeMode.system => Icons.brightness_auto_outlined,
          }),
          onPressed: () => ref
              .read(themeModeControllerProvider.notifier)
              .toggle(
                platformBrightness: MediaQuery.platformBrightnessOf(context),
              ),
        ),
        IconButton(
          tooltip: l10n.logout,
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await ref.read(logoutControllerProvider).call();
          },
        ),
      ],
    );
  }
}
