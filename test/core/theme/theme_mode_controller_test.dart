import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/theme_mode_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeModeController', () {
    test('starts at system', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(themeModeControllerProvider), ThemeMode.system);
    });

    test('set updates mode', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(themeModeControllerProvider.notifier).set(ThemeMode.dark);
      expect(container.read(themeModeControllerProvider), ThemeMode.dark);
    });

    test('toggle switches between light and dark from light', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeModeControllerProvider.notifier)
        ..set(ThemeMode.light)
        ..toggle(platformBrightness: Brightness.light);

      expect(container.read(themeModeControllerProvider), ThemeMode.dark);
      notifier.toggle(platformBrightness: Brightness.dark);
      expect(container.read(themeModeControllerProvider), ThemeMode.light);
    });

    test('toggle from system uses platform brightness', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(themeModeControllerProvider.notifier)
          .toggle(platformBrightness: Brightness.light);

      expect(container.read(themeModeControllerProvider), ThemeMode.dark);
    });
  });
}
