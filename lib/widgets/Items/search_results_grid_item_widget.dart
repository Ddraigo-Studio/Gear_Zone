import 'package:flutter/material.dart';
import '../../core/app_export.dart';
// import '../../theme/custom_button_style.dart';
import '../custom_icon_button.dart';
import '../custom_outlined_button.dart';

class SearchResultsGridItemWidget extends StatelessWidget {
  const SearchResultsGridItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: AppDecoration.fillGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(6.h),
            decoration: AppDecoration.fillGray.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconButton(
                  height: 26.h,
                  width: 26.h,
                  padding: EdgeInsets.all(6.h),
                  decoration: IconButtonStyleHelper.none,
                  alignment: Alignment.centerRight,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgHeartIconlyPro,
                  ),
                ),
                SizedBox(height: 14.h),
                CustomImageView(
                  imagePath: ImageConstant.imgImage1,
                  height: 72.h,
                  width: 48.h,
                ),
                SizedBox(height: 18.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.h),
                    child: Text(
                      "Huawei Matebook X13",
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 6.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "17.390.000đ",
                        style: theme.textTheme.labelLarge,
                      ),
                      _buildDiscountBadge(context),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.h),
                    child: Text(
                      "20.990.000đ",
                      style: theme.textTheme.labelMedium?.copyWith(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 6.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgDefaultIcon,
                              height: 18.h,
                              width: 18.h,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.h),
                              child: Text(
                                "5.0",
                                style: CustomTextStyles.bodySmallEncodeSansGray90001,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomIconButton(
                        height: 24.h,
                        width: 26.h,
                        padding: EdgeInsets.all(4.h),
                        decoration: IconButtonStyleHelper.fillDeepPurple,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgIconsaxBrokenBag2Gray100,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildDiscountBadge(BuildContext context) {
    return CustomOutlinedButton(
      width: 34.h,
      text: "31%".toUpperCase(),
      alignment: Alignment.center,
    );
  }

}
