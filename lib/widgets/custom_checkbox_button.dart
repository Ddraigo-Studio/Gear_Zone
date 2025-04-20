import 'package:flutter/material.dart';
import '../core/app_export.dart';

// ignore_for_file: must_be_immutable
class CustomCheckboxButton extends StatelessWidget {
  CustomCheckboxButton({
    super.key,
    required this.onChange,
    this.decoration,
    this.alignment,
    this.isRightCheck,
    this.iconSize,
    this.value,
    this.text,
    this.width,
    this.padding,
    this.textStyle,
    this.overflow,
    this.textAlignment,
    this.isExpandedText = false,
  });

  final BoxDecoration? decoration;

  final Alignment? alignment;

  final bool? isRightCheck;

  final double? iconSize;

  bool? value;

  final Function(bool) onChange;

  final String? text;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final TextStyle? textStyle;

  final TextOverflow? overflow;

  final TextAlign? textAlignment;

  final bool isExpandedText;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildCheckBoxWidget)
        : buildCheckBoxWidget;
  }

  Widget get buildCheckBoxWidget => GestureDetector(
        onTap: () {
          value = !(value!);
          onChange(value!);
        },
        child: Container(
          decoration: decoration,
          width: width,
          padding: padding,
          child: (isRightCheck ?? false) ? rightSideCheckbox : leftSideCheckbox,
        ),
      );

  Widget get leftSideCheckbox => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          checkboxWidget,
          SizedBox(
            width: text != null && text!.isNotEmpty ? 8 : 0,
          ),
          isExpandedText ? Expanded(child: textWidget) : textWidget
        ],
      );

  Widget get rightSideCheckbox => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isExpandedText ? Expanded(child: textWidget) : textWidget,
        SizedBox(
          width: text != null && text!.isNotEmpty ? 8 : 0,
        ),
        checkboxWidget
      ],
    );

  Widget get textWidget => Text(
      text ?? "",
      textAlign: textAlignment ?? TextAlign.start,
      overflow: overflow,
      style: textStyle ?? CustomTextStyles.bodyMediumGray50001,
    );

  Widget get checkboxWidget => InkWell(
      onTap: () {
        value = !(value ?? false);
        onChange(value!);
      },
      child: Container(
        height: iconSize ?? 20.h,
        width: iconSize ?? 20.h,
        decoration: BoxDecoration(
          color: (value ?? false) ? appTheme.deepPurpleA200 : Colors.transparent,
          border: Border.all(
            color: (value ?? false) ? appTheme.deepPurpleA200 : appTheme.gray60001,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(4.h),
        ),
        child: (value ?? false)
            ? Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: (iconSize ?? 20.h) * 0.7,
                ),
              )
            : null,
      ),
    );
}
