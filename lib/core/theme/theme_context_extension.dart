import 'package:flutter/material.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_theme.dart';

/// Namespaced, convenience access to the active [ThemeData], its [ColorScheme],
/// [TextTheme], and the app's [ThemeExtension]s straight off [BuildContext].
///
/// Replaces verbose, nullable `Theme.of(context).extension<...>()` chains.
/// Each getter subscribes the calling widget to theme changes (same as
/// `Theme.of(context)`), so widgets rebuild on light/dark switches.
///
/// Usage:
/// ```dart
/// context.colors.primary          // ColorScheme role
/// context.semantic.danger         // AppSemanticColors
/// context.textStyles.button       // AppCustomTextStyles
/// context.textTheme.bodySmall     // Material TextTheme
/// if (context.isDarkMode) { ... }
/// ```
extension ThemeContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// App-specific semantic colors (success / warning / danger / info).
  /// Non-null: falls back to [AppSemanticColors.fallback] when the
  /// extension was never registered.
  AppSemanticColors get semantic =>
      theme.extension<AppSemanticColors>() ??
      AppSemanticColors.fallback(colors);

  /// App-specific custom text styles (button / link / strikeThrough).
  /// Non-null: falls back to [AppCustomTextStyles.fallback] when the
  /// extension was never registered.
  AppCustomTextStyles get textStyles =>
      theme.extension<AppCustomTextStyles>() ??
      AppCustomTextStyles.fallback(colors, textTheme);

  Brightness get brightness => Theme.of(this).brightness;
  bool get isDarkMode => brightness == Brightness.dark;
  bool get isLightMode => brightness == Brightness.light;
}
