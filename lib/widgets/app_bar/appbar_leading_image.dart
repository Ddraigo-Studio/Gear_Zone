import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'appbar_image.dart';

class AppbarLeadingImage extends StatelessWidget {
  const AppbarLeadingImage({
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
      child: InkWell(
        onTap: onTap != null ? () => onTap!() : null,
        child: AppbarImage(
          imagePath: imagePath,
          height: height ?? 20.h,
          width: width ?? 20.h,
          color: color?? Colors.black54,
        ),
      ),
    );
  }
}
