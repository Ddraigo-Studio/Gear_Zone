import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_icon_button.dart';

class ProductCarouselItemWidget extends StatelessWidget {
  const ProductCarouselItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.h,
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
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.h,
                            vertical: 4.h,
                          ),
                          decoration: AppDecoration.outlineRed.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder8,
                          ),
                          child: RotationTransition(
                            turns: AlwaysStoppedAnimation(
                              -(180 / 360),
                            ),
                            child: Text(
                              "31%".toUpperCase(),
                              textAlign: TextAlign.left,
                              style: CustomTextStyles.labelMediumInterRed500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.h),
                    child: Text(
                      "20.990.000đ",
                      style: theme.textTheme.labelMedium!.copyWith(
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
                                style: CustomTextStyles
                                    .bodySmallEncodeSansGray90001,
                              ),
                            ),
                            CustomIconButton(
                              height: 24.h,
                              width: 26.h,
                              padding: EdgeInsets.all(4.h),
                              decoration: IconButtonStyleHelper.fillDeepPurple,
                              child: CustomImageView(
                                imagePath:
                                    ImageConstant.imgIconsaxBrokenBag2Gray100,
                              ),
                            ),
                            SizedBox(height: 4.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
