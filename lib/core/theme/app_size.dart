import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralised spacing, radii, and sizing constants.
///
/// UI code should reference these constants rather than hard-coded numbers so
/// the design language can be tweaked in a single place. Values use [Size] /
/// [EdgeInsets] extensions from [ScreenUtil] so they scale with the device.
class AppSize {
  AppSize._();

  // --- Spacing ---
  static double get spaceXxs => 2.sp;
  static double get spaceXs => 4.sp;
  static double get spaceSm => 8.sp;
  static double get spaceMd => 12.sp;
  static double get spaceLg => 16.sp;
  static double get spaceXl => 20.sp;
  static double get space2xl => 24.sp;
  static double get space3xl => 32.sp;
  static double get space4xl => 48.sp;

  // --- Radii ---
  static double get radiusSm => 4.r;
  static double get radiusMd => 8.r;
  static double get radiusLg => 12.r;
  static double get radiusXl => 20.r;

  // --- Padding / Edge insets ---
  static EdgeInsets get pagePadding =>
      EdgeInsets.symmetric(horizontal: spaceLg, vertical: spaceMd);

  static EdgeInsets get cardPadding => EdgeInsets.all(spaceLg);

  // --- Icon sizes ---
  static double get iconSm => 16.sp;
  static double get iconMd => 24.sp;
  static double get iconLg => 32.sp;

  // --- Component heights ---
  static double get inputHeight => 48.sp;
  static double get buttonHeight => 48.sp;
  static double get appBarHeight => 56.sp;
}