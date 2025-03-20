import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../custom_search_view.dart';

class AppbarTitleSearchviewOne extends StatelessWidget {
  const AppbarTitleSearchviewOne({
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
          hintText: "Tìm kiếm",
          contentPadding: EdgeInsets.fromLTRB(12.h, 12.h, 12.h, 14.h),
          borderDecoration: SearchViewStyleHelper.outlineDeepPurple,
          filled: false,
        ),
      ),
    );
  }
}
