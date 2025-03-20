import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../custom_icon_button.dart';

class AppbarTrailingIconbutton extends StatelessWidget {
  const AppbarTrailingIconbutton({
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
          padding: EdgeInsets.all(6.h),
          decoration: IconButtonStyleHelper.outlineBlack,
          child: CustomImageView(
            imagePath: ImageConstant.imgIconsaxBrokenBag2WhiteA700,
          ),
        ),
      ),
    );
  }

}
