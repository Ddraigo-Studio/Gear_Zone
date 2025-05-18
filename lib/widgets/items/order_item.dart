import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class OrderItem extends StatelessWidget {
  final String productName;
  final String imagePath;
  final double price;
  final int quantity;
  final String color;
  final String size;

  const OrderItem({
    super.key,
    this.productName = "Unknown Product",
    this.imagePath = "assets/images/_product_1.png",
    this.price = 0.0,
    this.quantity = 1,
    this.color = "",
    this.size = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.h),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: imagePath,
            height: 42.h,
            width: 64.h,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 222.h,
                  child: Text(
                    productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.bodySmallBalooBhaiGray900.copyWith(
                      height: 1.60,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        color.isNotEmpty ? "Màu sắc: $color" : "",
                        style: CustomTextStyles.labelMediumGray60001,
                      ),
                      Text(
                        "Số lượng: $quantity",
                        style: CustomTextStyles.labelMediumGray60001,
                      ),
                    ],
                  ),
                ),                SizedBox(height: 6.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      size.isNotEmpty ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "Kích thước: $size",
                          style: CustomTextStyles.labelMediumGray60001,
                        ),
                      ) : Container(),
                      Padding(
                        padding: EdgeInsets.only(left: 4.h),                        child: Text(
                          FormatUtils.formatPrice(price, symbol: "đ", symbolPosition: 'right'),
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
