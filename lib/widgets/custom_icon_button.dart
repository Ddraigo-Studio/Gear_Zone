import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get outline => BoxDecoration(
    color: appTheme.gray100,
    borderRadius: BorderRadius.circular(20.h),
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withValues(
        alpha: 0.1,
      ),
        spreadRadius: 1.h,
        blurRadius: 1.h,
        offset: Offset(
        1,
        0,
      ),
      )
    ],
  );

  static BoxDecoration get fillDeepPurple => BoxDecoration(
    color: appTheme.deepPurple400,
    borderRadius: BorderRadius.circular(8.h),
  );

  static BoxDecoration get outlineBlack => BoxDecoration(
  color: appTheme.deepPurple400,
  borderRadius: BorderRadius.circular(18.h),
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

  static BoxDecoration get fillPrimary => BoxDecoration(
    color: theme.colorScheme.primary,
    borderRadius: BorderRadius.circular(12.h),
  );

  static BoxDecoration get fillDeepPurpleTL16 => BoxDecoration(
    color: appTheme.deepPurple400,
    borderRadius: BorderRadius.circular(16.h),
  );

  static BoxDecoration get outlineBlackTL20 => BoxDecoration(
    color: appTheme.gray100,
    borderRadius: BorderRadius.circular(20.h),
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

  static BoxDecoration get outlineBlackTL22 => BoxDecoration(
    color: appTheme.deepPurple400,
    borderRadius: BorderRadius.circular(22.h),
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withValues(
          alpha: 0.25,
        ),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(
          1,
          1,
        ),
      ),
    ],
  );

  static BoxDecoration get outlineDeepPurpleA => BoxDecoration(
    borderRadius: BorderRadius.circular(16.h),
    border: Border.all(
      color: appTheme.deepPurpleA100,
      width: 2.h,
    ),
  );

  static BoxDecoration get outlineBlackTL24 => BoxDecoration(
    color: theme.colorScheme.primary,
    borderRadius: BorderRadius.circular(24.h),
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

  static BoxDecoration get outlineBlackTL241 => BoxDecoration(
    color: theme.colorScheme.primary,
    borderRadius: BorderRadius.circular(24.h),
    boxShadow: [
      BoxShadow(
        color: appTheme.black900.withValues(
          alpha: 0.25,
        ),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(
          3,
          3,
        ),
      ),
    ],
  );

  static BoxDecoration get fillPrimaryTL20 => BoxDecoration(
    color: theme.colorScheme.primary,
    borderRadius: BorderRadius.circular(20.h),
  );

  static BoxDecoration get fillGreen => BoxDecoration(
    color: appTheme.green600,
    borderRadius: BorderRadius.circular(16.h),
  );

  static BoxDecoration get none => BoxDecoration();
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
    {super.key,
    this.alignment,
    this.height,
    this.width,
    this.decoration,
    this.padding,
    this.onTap,
    this.child});

  final Alignment? alignment;

  final double? height;

  final double? width;

  final BoxDecoration? decoration;

  final EdgeInsetsGeometry? padding;

  final VoidCallback? onTap;

  final Widget? child;
  
  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center, 
            child: iconButtonWidget)
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: DecoratedBox(
          decoration: decoration ??
              BoxDecoration(
                color: appTheme.whiteA700,
                borderRadius: BorderRadius.circular(12.h),
              ),
          child: IconButton(
            padding: padding ?? EdgeInsets.zero,
            onPressed: onTap,
            icon: child ?? Container(),
          ),
        ),
      );
}
