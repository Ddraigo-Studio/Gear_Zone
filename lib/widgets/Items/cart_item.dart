import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CartItem extends StatelessWidget {
  const CartItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.h,
        vertical: 6.h,
      ),
      decoration: AppDecoration.fillGray100.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      child: Row(
        children: [
          SizedBox(
            height: 24.h,
            width: 24.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Add your widget children here
              ],
            ),
          ),
        ],
      ),
    );
  }
}
