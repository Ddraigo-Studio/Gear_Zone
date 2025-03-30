import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_outlined_button.dart';

class OrderedItem extends StatelessWidget {
  const OrderedItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 8.h,
        vertical: 4.h,
      ),
      decoration: AppDecoration.fillGray100.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      child: Column(
        spacing: 18,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgThiTKChAC42x60,
                  height: 42.h,
                  width: 60.h,
                  margin: EdgeInsets.only(bottom: 6.h),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Bag",
                            style: theme.textTheme.bodyLarge,
                          ),
                          Text(
                            "Color Berawn",
                            style: CustomTextStyles.bodySmallBalooBhaiBlack900,
                          ),
                          Text(
                            "Số lượng: 1",
                            style: CustomTextStyles.bodySmallBalooBhaiGray90010,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.h),
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.h,
                            vertical: 2.h,
                          ),
                          decoration: AppDecoration.outlineDeepOrange.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder8,
                          ),
                          child: Text(
                            "Chờ xử lý",
                            textAlign: TextAlign.center,
                            style:
                                CustomTextStyles.labelMediumInterDeeporange300,
                          ),
                        ),
                        Text(
                          "24.00",
                          style: CustomTextStyles.bodySmallBalooBhaiRed500,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildReviewButton(context),
                _buildDetailsButton(context)
              ],
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildReviewButton(BuildContext context) {
    return CustomOutlinedButton(
      height: 34.h,
      width: 120.h,
      text: "Đánh giá",
      buttonStyle: CustomButtonStyles.outlineGray,
      buttonTextStyle: CustomTextStyles.bodyLargeGray50001,
    );
  }

  /// Section Widget
  Widget _buildDetailsButton(BuildContext context) {
    return CustomElevatedButton(
      height: 34.h,
      width: 120.h,
      text: "Chi tiết",
      margin: EdgeInsets.only(left: 30.h),
      buttonStyle: CustomButtonStyles.fillPrimaryTL8,
      buttonTextStyle: CustomTextStyles.bodyLargeWhiteA700,
    );
  }

}
