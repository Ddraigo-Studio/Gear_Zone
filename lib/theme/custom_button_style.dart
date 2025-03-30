import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Filled button style
  static ButtonStyle get fillDeepPurple => ElevatedButton.styleFrom(
    backgroundColor: appTheme.deepPurple400,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.h),
    ),
    elevation: 0,
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get fillGray => ElevatedButton.styleFrom(
    backgroundColor: appTheme.gray100,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.h),
    ),
    elevation: 0,
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get fillGreenAAd => ElevatedButton.styleFrom(
    backgroundColor: appTheme.greenA200Ad,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.h),
    ),
    elevation: 0,
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get fillPrimaryTL12 => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.h),
    ),
    elevation: 0,
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get fillPrimaryTL22 => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22.h),
    ),
    elevation: 0,
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get fillPrimaryTL30 => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.h),
    ),
    elevation: 0,
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get fillPrimaryTL8 => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.h),
    ),
    elevation: 0,
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get fillWhiteA => ElevatedButton.styleFrom(
    backgroundColor: appTheme.whiteA700,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.h),
    ),
    elevation: 0,
    padding: EdgeInsets.zero,
  );

  // Outline button style
  static ButtonStyle get outlineBlack => ElevatedButton.styleFrom(
    backgroundColor: appTheme.red700,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.h),
    ),
    shadowColor: appTheme.black900.withValues(
      alpha: 0.25,
    ),
    elevation: 2,
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlineBlackTL10 => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.h),
    ),
    shadowColor: appTheme.black900.withValues(
      alpha: 0.25,
    ),
    elevation: 2,
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlineBlackTL26 => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(26.h),
    ),
    shadowColor: appTheme.black900.withValues(
      alpha: 0.25,
    ),
    elevation: 2,
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlineBlackTL261 => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(26.h),
    ),
    shadowColor: appTheme.black900.withValues(
      alpha: 0.25,
    ),
    elevation: 3,
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlineBlackTL262 => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(26.h),
    ),
    shadowColor: appTheme.black900.withValues(
      alpha: 0.25,
    ),
    elevation: 3,
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlineBlackTL263 => ElevatedButton.styleFrom(
    backgroundColor: appTheme.deepPurple400,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(26.h),
    ),
    shadowColor: appTheme.black900.withValues(
      alpha: 0.25,
    ),
    elevation: 2,
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlineBlackTL32 => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32.h),
    ),
    shadowColor: appTheme.black900.withValues(
      alpha: 0.25,
    ),
    elevation: 2,
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlineBlackTL321 => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32.h),
    ),
    shadowColor: appTheme.black900.withValues(
      alpha: 0.25,
    ),
    elevation: 2,
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlineGray => OutlinedButton.styleFrom(
    backgroundColor: Colors.transparent,
    side: BorderSide(
      color: appTheme.gray500.withValues(
        alpha: 0.9,
      ),
      width: 1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.h),
    ),
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlineGrayTL10 => OutlinedButton.styleFrom(
    backgroundColor: Colors.transparent,
    side: BorderSide(
      color: appTheme.gray50001,
      width: 1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.h),
    ),
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlineGrayTL8 => OutlinedButton.styleFrom(
    backgroundColor: Colors.transparent,
    side: BorderSide(
      color: appTheme.gray500.withValues(
        alpha: 0.9,
      ),
      width: 1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.h),
    ),
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlinePrimary => OutlinedButton.styleFrom(
    backgroundColor: Colors.transparent,
    side: BorderSide(
      color: theme.colorScheme.primary,
      width: 1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.h),
    ),
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlinePrimaryTL20 => OutlinedButton.styleFrom(
    backgroundColor: Colors.transparent,
    side: BorderSide(
      color: theme.colorScheme.primary,
      width: 2,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.h),
    ),
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlinePrimaryTL26 => OutlinedButton.styleFrom(
    backgroundColor: appTheme.deepPurple50,
    side: BorderSide(
      color: theme.colorScheme.primary,
      width: 1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(26.h),
    ),
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlineRedTL8 => OutlinedButton.styleFrom(
    backgroundColor: Colors.transparent,
    side: BorderSide(
      color: appTheme.red400,
      width: 1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.h),
    ),
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlineRedTL81 => OutlinedButton.styleFrom(
    backgroundColor: Colors.transparent,
    side: BorderSide(
      color: appTheme.red400,
      width: 1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.h),
    ),
    padding: EdgeInsets.zero,
  );

  // text button style
  static ButtonStyle get none => ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
    elevation: WidgetStateProperty.all<double>(0),
    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
    side: WidgetStateProperty.all<BorderSide>(
      BorderSide(color: Colors.transparent),
    ),
  );

}
