import 'package:flutter/material.dart';
import '../../core/app_export.dart';

enum Style {
  bgShadowBlack900_1,
  bgShadowBlack900,
  bgShadowBlack900_2,
  bgFillWhiteA700
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.height,
    this.shape,
    this.styleType,
    this.leadingWidth,
    this.leading,
    this.title,
    this.centerTitle,
    this.actions,
  });

  final double? height;
  final ShapeBorder? shape;
  final Style? styleType;
  final double? leadingWidth;
  final Widget? leading;
  final Widget? title;
  final bool? centerTitle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      shape: shape,
      toolbarHeight: height ?? 56.h,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: _getStyle(),
      leadingWidth: leadingWidth ?? 0,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(
        SizeUtils.width,
        height ?? 56.h,
      );

  _getStyle() {
    switch (styleType) {
      case Style.bgShadowBlack900_1:
        return Container(
          height: 88.h,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: appTheme.whiteA700,
            boxShadow: [
              BoxShadow(
                color: appTheme.black900.withValues(
                  alpha: 0.25,
                ),
                spreadRadius: 2.h,
                blurRadius: 2.h,
                offset: Offset(
                  0,
                  2,
                ),
              ),
            ],
          ),
        );

      case Style.bgShadowBlack900:
        return Container(
          height: 88.h,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: appTheme.whiteA700,
            boxShadow: [
              BoxShadow(
                color: appTheme.black900.withValues(
                  alpha: 0.25,
                ),
                spreadRadius: 2.h,
                blurRadius: 2.h,
                offset: Offset(
                  0,
                  2,
                ),
              ),
            ],
          ),
        );

      case Style.bgShadowBlack900_2:
        return Container(
          height: 88.h,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: appTheme.deepPurple400,
            boxShadow: [
              BoxShadow(
                color: appTheme.black900.withValues(
                  alpha: 0.25,
                ),
                spreadRadius: 2.h,
                blurRadius: 2.h,
                offset: Offset(
                  0,
                  2,
                ),
              ),
            ],
          ),
        );

      case Style.bgFillWhiteA700:
        return Container(
          height: 72.h,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: appTheme.whiteA700,
          ),
        );

      default:
        return null;
    }
  }
}
