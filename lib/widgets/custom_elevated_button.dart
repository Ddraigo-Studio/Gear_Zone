import 'package:flutter/material.dart';
import '../core/app_export.dart';
import 'base_button.dart';

class CustomElevatedButton extends BaseButton {
  const CustomElevatedButton(
    {super.key, 
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    super.margin,
    super.onPressed,
    super.buttonStyle,
    super.alignment,
    super.buttonTextStyle,
    super.isDisabled,
    super.height,
    super.width,
    required super.text});

  final BoxDecoration? decoration;

  final Widget? leftIcon;

  final Widget? rightIcon;

  @override
Widget build(BuildContext context) {
  return alignment != null
      ? Align(
          alignment: alignment ?? Alignment.center,
          child: buildElevatedButtonWidget)
      : buildElevatedButtonWidget;
}

Widget get buildElevatedButtonWidget => Container(
      height: height ?? 20.h,
      width: width ?? double.maxFinite,
      margin: margin,
      decoration: decoration,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: isDisabled ?? false ? null : onPressed ?? () {},
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  leftIcon ?? const SizedBox.shrink(),
                  if (leftIcon != null) SizedBox(width: 8.h),
                  Text(
                    text,
                    style:
                        buttonTextStyle ?? CustomTextStyles.labelMediumInterRed500,
                  ),
                ],
              ),
              rightIcon ?? const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
}
