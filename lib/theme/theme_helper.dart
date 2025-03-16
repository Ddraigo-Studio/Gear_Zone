import 'package:flutter/material.dart';
import '../core/app_export.dart';

String _appTheme = "lightCode";
LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.
// ignore_for_file: must_be_immutable
class ThemeHelper {
  // A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors()
  };

  // A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme
  };

  /// Changes the app theme to [_newTheme].
  void changeTheme(String _newTheme) {
    _appTheme = _newTheme;
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme = _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: appTheme.red500,
            width: 1.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.h),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26.h),
          ),
          elevation: 0,
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return appTheme.deepPurple400;
          }
          return Colors.transparent;
        }),
        side: BorderSide(
          width: 1,
        ),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: appTheme.gray50001,
      ),
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: appTheme.gray900,
          fontSize: 16.fSize,
          fontFamily: 'Baloo Bhai',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: appTheme.gray700,
          fontSize: 14.fSize,
          fontFamily: 'Baloo Bhai',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: appTheme.blueGray900,
          fontSize: 12.fSize,
          fontFamily: 'Fredoka',
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: TextStyle(
          color: appTheme.gray900,
          fontSize: 32.fSize,
          fontFamily: 'Gabarito',
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: TextStyle(
          color: appTheme.gray900,
          fontSize: 24.fSize,
          fontFamily: 'Gabarito',
          fontWeight: FontWeight.w700,
        ),
        labelLarge: TextStyle(
          color: appTheme.red500,
          fontSize: 12.fSize,
          fontFamily: 'Gabarito',
          fontWeight: FontWeight.w700,
        ),
        labelMedium: TextStyle(
          color: appTheme.gray700,
          fontSize: 10.fSize,
          fontFamily: 'Gabarito',
          fontWeight: FontWeight.w700,
        ),
        labelSmall: TextStyle(
          color: colorScheme.errorContainer,
          fontSize: 8.fSize,
          fontFamily: 'PP Mori',
          fontWeight: FontWeight.w800,
        ),
        titleLarge: TextStyle(
          color: appTheme.whiteA700,
          fontSize: 20.fSize,
          fontFamily: 'Baloo Bhai',
          fontWeight: FontWeight.w400,
        ),
        titleMedium: TextStyle(
          color: appTheme.blueGray90001,
          fontSize: 16.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: appTheme.blueGray90001,
          fontSize: 14.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light(
    primary: Color(0XFF86ECEE),
    primaryContainer: Color(0XFF4DA8AE),
    errorContainer: Color(0XFFFFF550),
    onError: Color(0XFF6CD075),
    onPrimary: Color(0XFF1E1E1E),
    onPrimaryContainer: Color(0XFF70DEB1),
  );
}

/// Class containing custom colors for a lightCode theme.
class LightCodeColors {
  // Amber
  Color get amberA200 => Color(0xFFFFD33C);

  // Black
  Color get black900 => Color(0xFF000000);

  // Blue
  Color get blue300 => Color(0xFF6593EA);

  // BlueGray
  Color get blueGray100 => Color(0xFFD9D9D9);
  Color get blueGray300 => Color(0xFFA1A5B0);
  Color get blueGray600 => Color(0xFF5F6473);
  Color get blueGray900 => Color(0xFF303030);
  Color get blueGray90001 => Color(0xFF2E313B);
  Color get blueGray90002 => Color(0xFF363636);

  // DeepOrange
  Color get deepOrange300 => Color(0xFFFF8A4F);
  Color get deepOrange400 => Color(0xFFFF6C50);
  Color get deepOrange600 => Color(0xFFF24822);

  // DeepPurple
  Color get deepPurple1003f => Color(0x3FCAADFF);
  Color get deepPurple400 => Color(0xFF894FC8);
  Color get deepPurple50 => Color(0xFFE9E1FC);
  Color get deepPurple500 => Color(0xFF733BDC);
  Color get deepPurple5001 => Color(0xFF9E3F5);
  Color get deepPurpleA100 => Color(0xFFBB9DFB);

  // Gray
  Color get gray100 => Color(0XFFFF4F4F4);
  Color get gray10001 => Color(0XFFFF7F7F7);
  Color get gray10002 => Color(0XFFFF5F5F5);
  Color get gray300 => Color(0XFFDDADADA);
  Color get gray500 => Color(0XFFFA9A9A);
  Color get gray50001 => Color(0XFF9C9C9C);
  Color get gray600 => Color(0XFF7F57575);
  Color get gray60001 => Color(0XFF787880);
  Color get gray700 => Color(0XFF666666);
  Color get gray70001 => Color(0XFF5B5B5B);
  Color get gray900 => Color(0XFF272727);
  Color get gray90001 => Color(0XFF292526);

  // Green
  Color get green400 => Color(0xFF5FB567);
  Color get green600 => Color(0xFF429049);

  // GreenA
  Color get greenA200Ad => Color(0xAD7D6FBF);

  // Orange
  Color get orange300 => Color(0xFFF4BD46);

  // Pink
  Color get pink300 => Color(0xFFFF5DA8);
  Color get pinkA700 => Color(0xFFCE048C);

  // Purple
  Color get purple900 => Color(0xFFF3D176);

  // Red
  Color get red400 => Color(0xFFFF2645C);
  Color get red50 => Color(0xFFFFF2F2);
  Color get red500 => Color(0xFFFFA3636);
  Color get red700 => Color(0xFFDC2626);
  Color get redA200 => Color(0xFFFFE959);

  // Teal
  Color get teal400 => Color(0xFF3F9A84);

  // White
  Color get whiteA700 => Color(0xFFFFFFFF);
  Color get whiteA70001 => Color(0xFFFFFDFD);

  // Yellow
  Color get yellow700 => Color(0xFFF4BD2F);
  Color get yellow900 => Color(0xFFFC6D26);
}