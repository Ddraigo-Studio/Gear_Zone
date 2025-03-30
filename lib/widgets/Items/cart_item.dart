import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key});

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
                Container(
                  height: 18.h,
                  width: 18.h,
                  decoration: BoxDecoration(
                    color: appTheme.deepPurple400,
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgCheckmark,
                  height: 24.h,
                  width: 24.h,
                ),
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgImage33,
            height: 42.h,
            width: 64.h,
            margin: EdgeInsets.only(left: 16.h),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200.h,
                    child: Text(
                      "Laptop ASUS Vivobook 14 OLED A1405VA KM095W",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.bodyMediumGray900.copyWith(
                        height: 1.60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Color: sliver",
                        style: CustomTextStyles.labelLargeGray60001,
                      ),
                      Text(
                        "Số lượng: 1",
                        style: CustomTextStyles.labelLargeGray60001,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "17.390.000đ",
                        style: CustomTextStyles.titleSmallGabaritoRed500,
                      ),
                      Text(
                        "20.990.000đ",
                        style: CustomTextStyles.labelMedium11.copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: AppDecoration.fillWhiteA.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 20.h,
                              decoration: AppDecoration.fillPrimary.copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder8,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant
                                        .imgIconsaxBrokenMinusGray100,
                                    height: 12.h,
                                    width: 14.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text(
                          ("lblQuantity").toString(),
                          style: CustomTextStyles.labelLargeInterDeeppurple500,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 20.h,
                              decoration: AppDecoration.fillPrimary.copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder8,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant
                                        .imgIconsaxBrokenAddGray100,
                                    height: 12.h,
                                    width: 14.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
