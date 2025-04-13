import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import '../core/app_export.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillBlueGray => BoxDecoration(
        color: appTheme.blueGray100,
      );
  static BoxDecoration get fillDeepOrange => BoxDecoration(
        color: appTheme.deepOrange50,
      );
  static BoxDecoration get fillDeepPurple => BoxDecoration(
        color: appTheme.deepPurple50,
      );
  static BoxDecoration get fillDeepPurpleA => BoxDecoration(
        color: appTheme.deepPurpleA100,
      );
  static BoxDecoration get fillDeepPurpleF => BoxDecoration(
        color: appTheme.deepPurple400,
      );
  static BoxDecoration get fillDeeppurple5001 => BoxDecoration(
        color: appTheme.deepPurple5001,
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray10001,
      );
  static BoxDecoration get fillGray100 => BoxDecoration(
        color: appTheme.gray100,
      );
  static BoxDecoration get fillGray1002 => BoxDecoration(
        color: appTheme.gray10002,
      );
  static BoxDecoration get fillGray300 => BoxDecoration(
        color: appTheme.gray300,
      );

  static BoxDecoration get fillPrimary => BoxDecoration(
    color: theme.colorScheme.primary,
  );

  static BoxDecoration get fillWhiteA => BoxDecoration(
      color: appTheme.whiteA700,
  );

  static BoxDecoration get fillYellow => BoxDecoration(
      color: appTheme.yellow50,
  );

  static BoxDecoration get fillPink => BoxDecoration(
    color: Color(0xFFFEE9E7),
  );

  // Outline decorations
  static BoxDecoration get outlineBlack => BoxDecoration(
    color: appTheme.deepPurple400,
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withValues(
          alpha: 0.25,
        ),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(
          0,
          2,
        ),
      ),
    ],
  );

  static BoxDecoration get outlineBlack900 => BoxDecoration(
    color: appTheme.deepPurple400,
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withValues(
          alpha: 0.25,
        ),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(
          0,
          4,
        ),
      ),
    ],
  );

  static BoxDecoration get outlineBlack9001 => BoxDecoration(
    color: appTheme.whiteA700,
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withValues(
          alpha: 0.25,
        ),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(
          0,
          2,
        ),
      ),
    ],
  );

  static BoxDecoration get outlineBlack9002 => BoxDecoration(
    color: appTheme.whiteA700,
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withValues(
          alpha: 0.25,
        ),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(
          0,
          -2,
        ),
      ),
    ],
  );

  static BoxDecoration get outlineBlack9003 => BoxDecoration(
    color: theme.colorScheme.primary,
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withValues(
          alpha: 0.25,
        ),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(
          2,
          2,
        ),
      ),
    ],
  );

  static BoxDecoration get outlineBlack9004 => BoxDecoration(
    color: appTheme.whiteA700,
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withValues(
          alpha: 0.1,
        ),
        spreadRadius: 1.h,
        blurRadius: 1.h,
        offset: Offset(
          0,
          1,
        ),
      ),
    ],
  );

  static BoxDecoration get outlineDeepOrange => BoxDecoration(
    border: Border.all(
      color: appTheme.deepOrange300,
      width: 1.5.h,
    ),
  );

  static BoxDecoration get outlineDeepPurpleA => BoxDecoration(
    color: appTheme.blueGray90002,
    border: Border.all(
      color: appTheme.deepPurpleA100,
      width: 1.5.h,
    ),
  );

  static BoxDecoration get outlineDeeppurpleA200 => BoxDecoration();

  static BoxDecoration get outlineGray => BoxDecoration(
    color: appTheme.deepPurple500,
    boxShadow: [
      BoxShadow(
        color: appTheme.gray100,
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(
          0,
          0,
        ),
      ),
    ],
  );

  static BoxDecoration get outlineGray500 => BoxDecoration(
    border: Border.all(
      color: appTheme.gray500.withValues(
        alpha: 0.9,
      ),
      width: 1.5.h,
    ),
  );

  static BoxDecoration get outlineGray50001 => BoxDecoration(
    border: Border.all(
      color: appTheme.gray50001,
      width: 1.h,
    ),
  );

  static BoxDecoration get outlineGray70001 => BoxDecoration(
    color: appTheme.whiteA700.withValues(
      alpha: 0.05,
    ),
    border: Border(
      top: BorderSide(
        color: appTheme.gray70001,
        width: 1.h,
      ),
      left: BorderSide(
        color: appTheme.gray70001,
        width: 1.h,
      ),
    ),
  );

  static BoxDecoration get outlineGreen => BoxDecoration(
    border: Border.all(
      color: appTheme.green400,
      width: 1.5.h,
    ),
  );

  static BoxDecoration get outlineOnError => BoxDecoration(
    border: Border.all(
      color: theme.colorScheme.onError,
      width: 1.5.h,
    ),
  );

  static BoxDecoration get outlineRed => BoxDecoration(
    border: Border.all(
      color: appTheme.red500,
      width: 1.h,
    ),
  );

  static BoxDecoration get outlineRedA => BoxDecoration(
    border: Border.all(
      color: appTheme.redA200,
      width: 1.5.h,
    ),
  );

  static BoxDecoration get outlineRedA200 => BoxDecoration(
    border: Border.all(
      color: appTheme.redA200,
      width: 1.h,
    ),
  );

  // Primary decorations
  static BoxDecoration get primary => BoxDecoration(
    color: appTheme.deepPurple400,
    image: DecorationImage(
      image: AssetImage(
        ImageConstant.imgEllipse2158,
      ),
      fit: BoxFit.fill,
    ),
  );

  // Secondary decorations
  static BoxDecoration get secondary => BoxDecoration(
    color: appTheme.deepPurple500,
  );

  static BoxDecoration get secondaryVariant100 => BoxDecoration(
    border: Border.all(
      color: appTheme.deepPurpleA100,
      width: 2.h,
    ),
  );

  // Shadow decorations
  static BoxDecoration get shadow => BoxDecoration(
    color: appTheme.gray10001,
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withValues(
          alpha: 0.2,
        ),
        spreadRadius: 1.h,
        blurRadius: 1.5.h,
        offset: Offset(
          1,
          0,
        ),
      ),
    ],
  );

  // Row decorations
  static BoxDecoration get row30 => BoxDecoration(
    image: DecorationImage(
      image: fs.Svg(
        ImageConstant.imgPolygon1,
      ),
      fit: BoxFit.fill,
    ),
  );

  // static BoxDecoration get row31 => BoxDecoration(
  //   image: DecorationImage(
  //     image: fs.Svg(
  //       ImageConstant.imgPolygon1,
  //     ),
  //     fit: BoxFit.fill,
  //   ),
  // );

  // static BoxDecoration get row32 => BoxDecoration(
  //   image: DecorationImage(
  //     image: fs.Svg(
  //       ImageConstant.imgPolygon1,
  //     ),
  //     fit: BoxFit.fill,
  //   ),
  // );

  // static BoxDecoration get row33 => BoxDecoration(
  //   image: DecorationImage(
  //     image: fs.Svg(
  //       ImageConstant.imgPolygon1,
  //     ),
  //     fit: BoxFit.fill,
  //   ),
  // );

  // static BoxDecoration get row34 => BoxDecoration(
  //   image: DecorationImage(
  //     image: fs.Svg(
  //       ImageConstant.imgPolygon1,
  //     ),
  //     fit: BoxFit.fill,
  //   ),
  // );

  static BoxDecoration get row35 => BoxDecoration(
    image: DecorationImage(
      image: AssetImage(
        ImageConstant.imgMaskGroup,
      ),
      fit: BoxFit.fill,
    ),
  );
}

class BorderRadiusStyle {
  static var roundedBorder;

  // Circle borders
  static BorderRadius get circleBorder20 => BorderRadius.circular(
        20.h,
      );
  static BorderRadius get circleBorder28 => BorderRadius.circular(
        28.h,
      );

  // Custom borders
  static BorderRadius get customBorderBL20 => BorderRadius.vertical(
        bottom: Radius.circular(20.h),
      );
  static BorderRadius get customBorderTL16 => BorderRadius.vertical(
        top: Radius.circular(16.h),
      );
  static BorderRadius get customBorderTL20 => BorderRadius.horizontal(
        left: Radius.circular(20.h),
      );
  static BorderRadius get customBorderTL201 => BorderRadius.vertical(
        top: Radius.circular(20.h),
      );

  // Rounded borders
  static BorderRadius get roundedBorder12 => BorderRadius.circular(
        12.h,
      );
  static BorderRadius get roundedBorder122 => BorderRadius.circular(
        122.h,
      );
  static BorderRadius get roundedBorder154 => BorderRadius.circular(
        154.h,
      );
  static BorderRadius get roundedBorder16 => BorderRadius.circular(
        16.h,
      );

  static BorderRadius get roundedBorder44 => BorderRadius.circular(
        44.h,
      );
  static BorderRadius get roundedBorder5 => BorderRadius.circular(
        5.h,
      );
  static BorderRadius get roundedBorder8 => BorderRadius.circular(
        8.h,
      );

}
