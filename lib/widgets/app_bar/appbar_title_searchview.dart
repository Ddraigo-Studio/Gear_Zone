import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../custom_search_view.dart';

class AppbarTitleSearchview extends StatelessWidget {
  const AppbarTitleSearchview({
    super.key,
    this.hintText,
    this.controller,
    this.margin,
  });

  final String? hintText;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: SizedBox(
        width: double.maxFinite,
        child: CustomSearchView(
          controller: controller,
          hintText: "Jacket",
          contentPadding: EdgeInsets.fromLTRB(10.h, 10.h, 20.h, 10.h),
        ),
      ),
    );
  }
}
