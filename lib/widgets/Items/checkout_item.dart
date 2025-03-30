import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class CheckoutItem extends StatelessWidget {
  const CheckoutItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgImage32,
          height: 64.h,
          width: 64.h,
          radius: BorderRadius.circular(
            5.h,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 222.h,
                child: Text(
                  "Laptop ASUS Vivobook 14 OLED A1405VA KM095W",
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
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Màu sắc: bạc",
                            style: CustomTextStyles.labelMediumGray60001,
                          ),
                          Text(
                            "Số lượng: 1",
                            style: CustomTextStyles.labelMediumGray60001,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        spacing: 2,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "17.390.000đ",
                            style: theme.textTheme.labelLarge,
                          ),
                          Text(
                            "20.990.000đ",
                            style: theme.textTheme.labelMedium!.copyWith(
                              decoration: TextDecoration.lineThrough,
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
        ),
      ],
    );
  }
}
