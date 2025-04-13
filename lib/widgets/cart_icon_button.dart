import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/cart_controller.dart';
import '../core/app_export.dart';
import 'app_bar/appbar_image.dart';

class CartIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final Color buttonColor;
  final Color iconColor;

  const CartIconButton({
    super.key,
    required this.onPressed,
    this.iconSize = 45,
    this.padding,
    Color? buttonColor,
    this.iconColor = Colors.white, // Default to white
  }) : buttonColor = buttonColor ?? const Color(0xFF7E57C2); // Set default color here

  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, cartController, _) {
        final itemCount = cartController.itemCount;
        
        return Stack(
          children: [
            IconButton(
              icon: Container(
                width: iconSize?.h,
                height: iconSize?.h,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadiusStyle.circleBorder28,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(0, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
                padding: padding ?? EdgeInsets.all(8.h),
                child: AppbarImage(
                  imagePath: ImageConstant.imgIconsaxBrokenBag2Gray100,
                  height: (iconSize! * 0.4).h,
                  width: (iconSize! * 0.4).h,
                  color: iconColor,
                ),
              ),
              onPressed: onPressed,
            ),
            if (itemCount > 0)
              Positioned(
                right: 5,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(4.h),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 18.h,
                    minHeight: 18.h,
                  ),
                  child: Center(
                    child: Text(
                      itemCount > 99 ? '99+' : itemCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.h,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}