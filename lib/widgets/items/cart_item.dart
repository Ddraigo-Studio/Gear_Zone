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
                  size: 20.h),
            ),
          ),
          onTap: (handler) async {},
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
          onTap: (handler) async {},
        ),
      ],
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.h),
          color: isSelected ? Color(0xFFEEE6FF) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 1),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Left: Checkbox + Product Image
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  width: 80.h,
                  height: 80.h,
                  margin: EdgeInsets.only(left: 4.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.h),
                    child: CustomImageView(
                      imagePath: imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    left: 0,
                    top: 0,
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

            SizedBox(width: 12.h),

            // Middle: Product Info with Quantity Controls
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    productName,
                    style: CustomTextStyles.titleMediumBaloo2Gray500SemiBold
                        .copyWith(
                      color: Colors.black87,
                      fontSize: 16.h,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  // Only show color if available
                  if (color.isNotEmpty && color != "Default")
                    Text(
                      "Màu: $color",
                      style: CustomTextStyles.labelLargeGray60001.copyWith(
                        fontSize: 14.h,
                      ),
                    ),
                  SizedBox(height: 8.h),
                  Text(
                    "Số lượng: $quantity",
                    style: CustomTextStyles.labelMedium11.copyWith(
                      fontSize: 14.h,
                      color: appTheme.gray500,
                    ),
                  ),
                  // Quantity Controls
                ],
              ),
            ),

            SizedBox(width: 8.h),

            // Right: Price Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [                Text(
                  FormatUtils.formatPrice(discountedPrice),
                  style: CustomTextStyles.labelMedium11.copyWith(
                    decoration: TextDecoration.lineThrough,
                    fontSize: 12.h,
                    color: appTheme.gray500,
                  ),
                ),
                
                SizedBox(height: 4.h),
                if (originalPrice > 0)
                  Text(
                    FormatUtils.formatPrice(originalPrice),
                    style: CustomTextStyles.titleSmallGabaritoRed500.copyWith(
                      fontSize: 16.h,
                    ),
                  ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Container(
                      width: 26.h,
                      height: 26.h,
                      decoration: BoxDecoration(
                        color: appTheme.deepPurpleA200,
                        borderRadius: BorderRadiusStyle.circleBorder20,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon:
                            Icon(Icons.remove, size: 14.h, color: Colors.white),
                        onPressed: () =>
                            onQuantityChanged(quantity > 1 ? quantity - 1 : 1),
                      ),
                    ),
                    Container(
                      width: 35.h,
                      height: 26.h,
                      alignment: Alignment.center,
                      child: Text(
                        quantity.toString(),
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Container(
                      width: 26.h,
                      height: 26.h,
                      decoration: BoxDecoration(
                        color: appTheme.deepPurpleA200,
                        borderRadius: BorderRadiusStyle.circleBorder20,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.add, size: 14.h, color: Colors.white),
                        onPressed: () => onQuantityChanged(quantity + 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
