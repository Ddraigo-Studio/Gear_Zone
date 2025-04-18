import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class AppbarImage extends StatelessWidget {
  const AppbarImage({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.onTap,
    this.margin, 
    this.color,
  });

  final double? height;
  final double? width;
  final String? imagePath;
  final Function? onTap;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: CustomImageView(
          imagePath: imagePath!,
          height: height ?? 16.h,
          width: width ?? 16.h,
          fit: BoxFit.contain,
          color: color ?? Colors.white, // Default to deep purple
      ),
    );
  }
}
