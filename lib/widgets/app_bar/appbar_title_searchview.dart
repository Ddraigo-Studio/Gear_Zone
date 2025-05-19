import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class AppbarTitleSearchview extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Function(String)? onSubmitted;
  final EdgeInsetsGeometry? margin;

  const AppbarTitleSearchview({
    super.key,
    this.hintText,
    this.controller,
    this.onSubmitted,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      height: 35.h, // Match the height from the provided snippet
      decoration: BoxDecoration(
        color: Colors.white, // White background
        borderRadius: BorderRadius.circular(5.h), // Rounded corners
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText ?? "Tìm kiếm sản phẩm",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 12.h, // Match font size
          ),
          isDense: true,
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 8.h, right: 4.h),
            child: Icon(
              Icons.search,
              color: Colors.grey,
              size: 15.h, // Match icon size
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.search,
              color: appTheme.deepPurple400, // Match the purple color
              size: 18.h, // Match icon size
            ),
            onPressed: () {
              if (controller != null && controller!.text.trim().isNotEmpty) {
                onSubmitted?.call(controller!.text);
              }
            },
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 36.h,
            minHeight: 36.h,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
        ),
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          fontSize: 12.h, // Match font size
        ),
        textInputAction: TextInputAction.search, // Show "Search" key on keyboard
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            onSubmitted?.call(value);
          }
        },
      ),
    );
  }
}