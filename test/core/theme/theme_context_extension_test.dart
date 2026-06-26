import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_theme.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/theme_context_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpWithAppTheme(
  WidgetTester tester, {
  required ThemeData Function() theme,
  required Widget Function(BuildContext context) body,
}) {
  return tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return MaterialApp(
          theme: theme(),
          home: Builder(builder: body),
        );
      },
    ),
  );
}

void main() {
  group('ThemeContextX', () {
    testWidgets('resolves semantic colors and brightness in light theme', (
      tester,
    ) async {
      await _pumpWithAppTheme(
        tester,
        theme: AppTheme.light,
        body: (context) {
          expect(context.isDarkMode, isFalse);
          expect(context.isLightMode, isTrue);
          expect(context.semantic.danger, const Color(0xFFC62828));
          expect(
            context.textStyles.strikeThrough.decoration,
            TextDecoration.lineThrough,
          );
          return const SizedBox.shrink();
        },
      );
    });

    testWidgets('resolves brightness in dark theme', (tester) async {
      await _pumpWithAppTheme(
        tester,
        theme: AppTheme.dark,
        body: (context) {
          expect(context.isDarkMode, isTrue);
          expect(context.isLightMode, isFalse);
          return const SizedBox.shrink();
        },
      );
    });

    testWidgets('falls back when ThemeExtensions are missing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(),
          home: Builder(
            builder: (context) {
              expect(context.semantic.danger, ThemeData().colorScheme.error);
              expect(
                context.textStyles.strikeThrough.decoration,
                TextDecoration.lineThrough,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('exposes ColorScheme and TextTheme via namespaced getters', (
      tester,
    ) async {
      await _pumpWithAppTheme(
        tester,
        theme: AppTheme.light,
        body: (context) {
          expect(context.colors.primary, isNotNull);
          expect(context.textTheme.bodyMedium, isNotNull);
          return const SizedBox.shrink();
        },
      );
    });
  });
}
