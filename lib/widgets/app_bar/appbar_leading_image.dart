import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class AppbarLeadingImage extends StatelessWidget {
  const AppbarLeadingImage({
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
        borderRadius: BorderRadius.circular(28.h), 
        onTap: () {
          onTap?.call();
        },
        child: ClipOval( 
          child: CustomImageView(
            imagePath: imagePath!,
            height: height ?? 15.h,
            width: width ?? 15.h,
            fit: BoxFit.contain,  
          ),
        ),
      ),
    );
  }
}
