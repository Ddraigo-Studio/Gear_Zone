import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/cart_controller.dart';
import '../core/app_export.dart';
import 'app_bar/appbar_image.dart';

class CartIconButton extends StatelessWidget {
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final Color buttonColor;
  final Color iconColor;

  const CartIconButton({
    super.key,
    this.iconSize,
    this.padding,
    Color? buttonColor,
    this.iconColor = Colors.white,
  }) : buttonColor = buttonColor ?? const Color(0xFF7E57C2);

  @override
  Widget build(BuildContext context) {
    // Determine if we're on a desktop or mobile device
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;
    
    // Calculate responsive icon size
    final responsiveIconSize = iconSize ?? 
        (isDesktop ? 56.0 : 45.0 * MediaQuery.of(context).textScaleFactor);
    
    // Calculate responsive padding
    final responsivePadding = padding ?? 
        EdgeInsets.all(isDesktop ? 12.0 : 8.0);
    
    return Consumer<CartController>(
      builder: (context, cartController, _) {
        final itemCount = cartController.itemCount;
        
        return Stack(
          children: [
            IconButton(
              iconSize: responsiveIconSize + 10, // Increase touch target size
              icon: Container(
                width: responsiveIconSize,
                height: responsiveIconSize,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(responsiveIconSize / 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
                padding: responsivePadding,
                child: AppbarImage(
                  imagePath: ImageConstant.imgIconsaxBrokenBag2Gray100,
                  height: responsiveIconSize * 0.4,
                  width: responsiveIconSize * 0.4,
                  color: iconColor,
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.myCartScreen),
            ),
            if (itemCount > 0)
              Positioned(
                right: 5,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(isDesktop ? 6.0 : 4.0),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: isDesktop ? 24.0 : 18.0,
                    minHeight: isDesktop ? 24.0 : 18.0,
                  ),
                  child: Center(
                    child: Text(
                      itemCount > 99 ? '99+' : itemCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isDesktop ? 12.0 : 10.0,
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