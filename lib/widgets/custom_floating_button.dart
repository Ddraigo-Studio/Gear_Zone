import 'package:flutter/material.dart';
import '../core/app_export.dart';
// import '../theme/custom_button_style.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton(
      {super.key,
      this.alignment,
      this.backgroundColor,
      this.onTap,
      required this.shape,
      required this.width,
      required this.height,
      this.decoration,
      required this.child});

  final Alignment? alignment;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final ShapeBorder? shape;
  final double width;
  final double height;
  final BoxDecoration? decoration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment ?? Alignment.center, child: fabWidget)
        : fabWidget;
  }

  Widget get fabWidget => FloatingActionButton(
        backgroundColor: backgroundColor,
        onPressed: onTap,
        shape: shape,
        child: Container(
          alignment: Alignment.center,
          width: width,
          height: height,
          decoration: decoration ??
              BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(24.h),
              ),
          child: child,
        ),
      );
}
