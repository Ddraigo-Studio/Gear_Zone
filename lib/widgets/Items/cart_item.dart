import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import '../../core/app_export.dart';

class CartItem extends StatelessWidget {
  final String productName;
  final String imagePath;
  final String color;
  final int quantity;
  final double discountedPrice;
  final double originalPrice;
  final Function(int) onQuantityChanged;
  final VoidCallback onDelete;
  final bool isSelected;
  final Function(bool) onSelectionChanged;

  const CartItem({
    super.key,
    required this.productName,
    required this.imagePath,
    required this.color,
    required this.quantity,
    required this.discountedPrice,
    required this.originalPrice,
    required this.onQuantityChanged,
    required this.onDelete,
    this.isSelected = false,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwipeActionCell(
      backgroundColor: Colors.transparent,
      key: ObjectKey(productName),
      leadingActions: [
        SwipeAction(
          forceAlignmentToBoundary: true,
          performsFirstActionWithFullSwipe: true,
          color: Colors.transparent,
          content: Container(
            width: 35.h,
            height: 35.h,
            decoration: BoxDecoration(
              color: appTheme.deepPurpleA200,
              borderRadius: BorderRadius.circular(8.h),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                onSelectionChanged(!isSelected);
              },
              icon: Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                color: Colors.white,
                size: 20.h
              ),
            ),
          ),
          onTap: (handler) async {
          },
        ),
      ],
      trailingActions: [
        SwipeAction(
          forceAlignmentToBoundary: true,
          performsFirstActionWithFullSwipe: true,
          color: Colors.transparent,
          content: Container(
            width: 40.h,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8.h),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                onDelete();
              },
              icon: Icon(Icons.delete_outline, color: Colors.white, size: 20.h),
            ),
          ),
          onTap: (handler) async {
          },
        ),
      ],
      // Removed invalid 'onTap' parameter as it is not supported by SwipeActionCell
      child: Container(
        padding: EdgeInsets.all(8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.h),
          color: isSelected ? Color(0xFFEEE6FF) : Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    CustomImageView(
                      imagePath: imagePath,
                      height: 64.h,
                      width: 64.h,
                      radius: BorderRadius.circular(4.h),
                      margin: EdgeInsets.only(left: 8.h),
                    ),
                    if (isSelected)
                      Positioned(
                        left: 2.h,
                        top: 2.h,
                        child: Container(
                          padding: EdgeInsets.all(2.h),
                          decoration: BoxDecoration(
                            color: appTheme.deepPurpleA200,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12.h,
                          ),
                        ),
                      ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName,
                          style: CustomTextStyles.titleMediumBaloo2Gray500SemiBold.copyWith(
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text(
                              "Màu: $color",
                              style: CustomTextStyles.labelLargeGray60001.copyWith(
                                fontSize: 14.h,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 30.h,
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: appTheme.deepPurpleA200,
                          borderRadius: BorderRadiusStyle.circleBorder20,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.remove, size: 16.h, color: Colors.white),
                          onPressed: () => onQuantityChanged(quantity - 1),
                        ),
                      ),
                      Container(
                        width: 35.h,
                        height: 32.h,
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            quantity.toString(),
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Container(
                        width: 30.h,
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: appTheme.deepPurpleA200,
                          borderRadius: BorderRadiusStyle.circleBorder20,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.add, size: 16.h, color: Colors.white),
                          onPressed: () => onQuantityChanged(quantity + 1),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${discountedPrice.toStringAsFixed(0)}đ",
                        style: CustomTextStyles.titleSmallGabaritoRed500.copyWith(
                          fontSize: 16.h,
                        ),
                      ),
                      Text(
                        "${originalPrice.toStringAsFixed(0)}đ",
                        style: CustomTextStyles.labelMedium11.copyWith(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 13.h,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
