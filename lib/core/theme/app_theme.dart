import 'package:flutter/material.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_size.dart';

/// Brand and semantic colour palette. Layered on top of Material 3's
/// [ColorScheme] so designers have one place to tweak intent (success,
/// warning, danger) while Material handles primary/secondary derivation.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
  });

  /// Derived defaults when the extension is missing (e.g. bare [ThemeData] in
  /// tests). Mirrors the `?? colorScheme.error` intent for [danger].
  factory AppSemanticColors.fallback(ColorScheme colorScheme) =>
      AppSemanticColors(
        success: colorScheme.tertiary,
        warning: colorScheme.secondary,
        danger: colorScheme.error,
        info: colorScheme.primary,
      );

  final Color success;
  final Color warning;
  final Color danger;
  final Color info;

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      danger: Color.lerp(danger, other.danger, t) ?? danger,
      info: Color.lerp(info, other.info, t) ?? info,
    );
  }
}

/// Custom text style roles. Material's [TextTheme] covers the basics; this
/// extension adds domain roles (button, caption, link).
@immutable
class AppCustomTextStyles extends ThemeExtension<AppCustomTextStyles> {
  const AppCustomTextStyles({
    required this.button,
    required this.link,
    required this.strikeThrough,
  });

  /// Derived defaults when the extension is missing (e.g. bare [ThemeData] in
  /// tests).
  factory AppCustomTextStyles.fallback(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) => AppCustomTextStyles(
    button: (textTheme.labelLarge ?? const TextStyle()).copyWith(
      color: colorScheme.onPrimary,
    ),
    link: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
      color: colorScheme.primary,
      decoration: TextDecoration.underline,
    ),
    strikeThrough: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
      color: colorScheme.onSurfaceVariant,
      decoration: TextDecoration.lineThrough,
    ),
  );

  final TextStyle button;
  final TextStyle link;

  /// Applied to list items that have been completed (todo checkboxes,
  /// dismissed notifications, etc). Bundles the line-through decoration
  /// with the theme's disabled colour so dark mode and high-contrast
  /// palettes stay coherent without per-call-site hand-rolling.
  final TextStyle strikeThrough;

  @override
  AppCustomTextStyles copyWith({
    TextStyle? button,
    TextStyle? link,
    TextStyle? strikeThrough,
  }) {
    return AppCustomTextStyles(
      button: button ?? this.button,
      link: link ?? this.link,
      strikeThrough: strikeThrough ?? this.strikeThrough,
    );
  }

  @override
  AppCustomTextStyles lerp(
    ThemeExtension<AppCustomTextStyles>? other,
    double t,
  ) {
    if (other is! AppCustomTextStyles) return this;
    return AppCustomTextStyles(
      button: TextStyle.lerp(button, other.button, t) ?? button,
      link: TextStyle.lerp(link, other.link, t) ?? link,
      strikeThrough:
          TextStyle.lerp(strikeThrough, other.strikeThrough, t) ??
          strikeThrough,
    );
  }
}

/// Builds the app's [ThemeData] for light and dark modes.
class AppTheme {
  AppTheme._();

  static const _seedColor = Color(0xFF3D5AFE);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );

    const semanticColors = AppSemanticColors(
      success: Color(0xFF2E7D32),
      warning: Color(0xFFF9A825),
      danger: Color(0xFFC62828),
      info: Color(0xFF0277BD),
    );

    final customTextStyles = AppCustomTextStyles(
      button: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colorScheme.onPrimary,
      ),
      link: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorScheme.primary,
        decoration: TextDecoration.underline,
      ),
      strikeThrough: TextStyle(
        decoration: TextDecoration.lineThrough,
        // Use onSurfaceVariant so completed items read as muted in both
        // light and dark themes without depending on
        // Theme.of(...).disabledColor, which collapses to grey in dark mode.
        color: colorScheme.onSurfaceVariant,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSize.spaceLg,
          vertical: AppSize.spaceMd,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.radiusMd),
          borderSide: BorderSide.none,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(AppSize.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.radiusMd),
          ),
          textStyle: customTextStyles.button,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.radiusLg),
        ),
        color: colorScheme.surfaceContainerHigh,
      ),
      extensions: <ThemeExtension<dynamic>>[semanticColors, customTextStyles],
    );
  }
}
