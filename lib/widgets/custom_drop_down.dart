import 'package:flutter/material.dart';
import '../core/app_export.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown(
      {super.key,
      this.alignment,
      this.width,
      this.boxDecoration,
      this.focusNode,
      this.icon,
      this.iconSize,
      this.autofocus = false,
      this.textStyle,
      this.hintText,
      this.hintStyle,
      this.items,
      this.prefix,
      this.prefixConstraints,
      this.contentPadding,
      this.borderDecoration,
      this.fillColor,
      this.filled = true,
      this.validator,
      this.onChanged});
  
  final Alignment? alignment;
  final double? width;
  final BoxDecoration? boxDecoration;
  final FocusNode? focusNode;
  final Widget? icon;
  final double? iconSize;
  final bool? autofocus;
  final TextStyle? textStyle;
  final String? hintText;
  final TextStyle? hintStyle;
  final List<String>? items;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool? filled;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center, child: dropDownWidget)
        : dropDownWidget;
  }

  Widget get dropDownWidget => Container(
        width: width ?? double.maxFinite,
        decoration: boxDecoration,
        child: DropdownButtonFormField(
          focusNode: focusNode,
          icon: icon,
          iconSize: iconSize ?? 24,
          autofocus: autofocus!,
          isExpanded: true,
          style: textStyle ?? CustomTextStyles.bodyLargeGray900,
          hint: Text(
            hintText ?? "",
            style: hintStyle ?? CustomTextStyles.bodyLargeGray900,
            overflow: TextOverflow.ellipsis,
          ),
          items: items?.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: hintStyle ?? CustomTextStyles.bodyLargeGray900,
              ),
            );
          }).toList(),
          decoration: decoration,
          validator: validator,
          onChanged: (value) {
            onChanged!(value.toString());
          },
        ),
      );

      InputDecoration get decoration => InputDecoration(
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      isDense: true,
      contentPadding: contentPadding ?? EdgeInsets.all(10.h),
      fillColor: fillColor ?? appTheme.gray100,
      filled: filled,
      border: borderDecoration ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.h),
            borderSide: BorderSide.none,
          ),
      enabledBorder: borderDecoration ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.h),
            borderSide: BorderSide.none,
          ),
      focusedBorder: (borderDecoration ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.h),
              ))
          .copyWith(
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 1,
            ),
          ),
    );

}
