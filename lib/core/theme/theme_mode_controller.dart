import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_controller.g.dart';

/// Holds the user's preferred [ThemeMode] (light / dark / system).
///
/// In-memory only for now — resets on cold start. Persistence can be added
/// once a storage target is signed off.
@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  @override
  ThemeMode build() => ThemeMode.system;

  // ignore: use_setters_to_change_properties
  void set(ThemeMode mode) => state = mode;

  /// Toggles between light and dark. When currently [ThemeMode.system],
  /// switches to the opposite of the platform default (dark on light
  /// platforms, light on dark platforms).
  void toggle({required Brightness platformBrightness}) {
    final effectiveIsDark = switch (state) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => platformBrightness == Brightness.dark,
    };
    set(effectiveIsDark ? ThemeMode.light : ThemeMode.dark);
  }
}
