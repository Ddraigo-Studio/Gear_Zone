import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class AppbarLeadingImageOne extends StatelessWidget {
  const AppbarLeadingImageOne({
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
      child: InkWell(
        borderRadius: BorderRadiusStyle.roundedBorder8,
        onTap: () {
          onTap?.call();
        },
        child: CustomImageView(
          imagePath: imagePath!,
          height: height ?? 14.h,
          width: width ?? 16.h,
          fit: BoxFit.contain,
          radius: BorderRadius.circular(8.h),
        ),
      ),
    );
  }
}
