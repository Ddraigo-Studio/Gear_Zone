import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../custom_icon_button.dart';

class AppbarLeadingIconbutton extends StatelessWidget {
  const AppbarLeadingIconbutton({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.onTap,
    this.margin,
  });

  final double? height;
  final double? width;
  final String? imagePath;
  final Function? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: CustomIconButton(
          height: height ?? 40.h,
          width: width ?? 40.h,
          padding: EdgeInsets.all(12.h),
          decoration: IconButtonStyleHelper.outline,
          child: CustomImageView(
            imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
          ),
        ),
      ),
    );
  }
}
