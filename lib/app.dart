import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/router/app_router.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_theme.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/theme_mode_controller.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/widgets/connectivity_banner.dart';
import 'package:flutter_clean_riverpod_boilerplate/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Root widget. Mounted under [ProviderScope] by the flavor entrypoints.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeControllerProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Flutter Boilerplate',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) {
            // Wrap the whole subtree so the banner appears above every route.
            return Column(
              children: [
                const ConnectivityBanner(),
                Expanded(child: child ?? const SizedBox.shrink()),
              ],
            );
          },
        );
      },
    );
  }
}
