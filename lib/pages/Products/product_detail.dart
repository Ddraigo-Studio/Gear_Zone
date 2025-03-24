import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_image.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_floating_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/tab_page/product_tab_page.dart';

// ignore_for_file: must_be_immutable
class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({super.key});

  TextEditingController descriptionEditTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildHeaderStack(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(
                      left: 24.h,
                      top: 36.h,
                      right: 24.h,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "EX DISPLAY : MSI Pro 16 Flex-036AU 15.6 MULTITOUCH All-In-On...",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyles.titleMediumGabaritoBlack900,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        _buildStockInfoRow(context),
                        SizedBox(height: 6.h),
                        _buildColorOptionsRow(context),
                        SizedBox(height: 16.h),
                        _buildPricingRow(context),
                        SizedBox(height: 36.h),
                        ProductTabTabPage(),
                        SizedBox(height: 44.h),
                        _buildRatingRow(context),
                        SizedBox(height: 16.h),
                        _buildReviewRow(context),
                        SizedBox(height: 4.h),
                        Text(
                          "Gucci transcribes its heritage, creativity, and innovation into a plentitude of collections. From staple items to distinctive accessories.",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyles.bodySmallBalooBhaiGray900_1
                              .copyWith(
                            height: 1.60,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "12 ngày trước",
                            style: CustomTextStyles.bodySmallBalooBhaiGray900,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        _buildReviewRow1(context),
                        SizedBox(height: 4.h),
                        Text(
                          "Gucci transcribes its heritage, creativity, and innovation into a plenitude of collections. From staple items to distinctive accessories.",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyles.bodySmallBalooBhaiGray900_1
                              .copyWith(
                            height: 1.60,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "1 tháng trước",
                            style: CustomTextStyles.bodySmallBalooBhaiGray900,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        _buildCommentButton(context),
                        SizedBox(height: 110.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildPurchaseOptionsColumn(context),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  /// Section Widget
  Widget _buildHeaderStack(BuildContext context) {
    return SizedBox(
      height: 152.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicWidth(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgProduct4,
                      height: 152.h,
                      width: 180.h,
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgProduct5,
                      height: 152.h,
                      width: 180.h,
                      margin: EdgeInsets.only(left: 16.h),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgProduct5,
                      height: 152.h,
                      width: 180.h,
                      margin: EdgeInsets.only(left: 16.h),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              height: 44.h,
              leadingWidth: 64.h,
              leading: AppbarLeadingImage(
                imagePath: ImageConstant.imgInbox,
                width: 40.h,
                margin: EdgeInsets.only(
                  left: 24.h,
                  bottom: 30.h,
                ),
              ),
              actions: [
                Container(
                  width: 46.h,
                  margin: EdgeInsets.only(
                    right: 31.h,
                    bottom: 24.h,
                  ),
                  decoration: AppDecoration.outlineBlack900.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder8,
                  ),
                  child: Column(
                    children: [
                      AppbarImage(
                        imagePath: ImageConstant.imgIconsaxBrokenBag2WhiteA700,
                        height: 6.h,
                        margin: EdgeInsets.only(
                          left: 14.h,
                          right: 13.h,
                        ),
                      ),
                      SizedBox(height: 14.h),
                    ],
                  ),
                ),
              ],
              styleType: Style.bgFillWhiteA700,
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildStockInfoRow(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          Text(
            "Còn hàng:",
            style: CustomTextStyles.bodyMediumBalooBhaijaanGray900_1,
          ),
          Text(
            "2",
            style: CustomTextStyles.bodyMediumBalooBhaijaanRed500,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColorOptionsRow(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          Text(
            "Màu sắc:",
            style: CustomTextStyles.bodyMediumBalooBhaijaanDeeppurple500,
          ),
          Container(
            height: 24.h,
            width: 24.h,
            margin: EdgeInsets.only(left: 10.h),
            decoration: BoxDecoration(
              color: appTheme.blueGray100,
              borderRadius: BorderRadius.circular(12.h),
              border: Border.all(
                color: appTheme.gray900,
                width: 1.5.h,
              ),
              boxShadow: [
                BoxShadow(
                  color: appTheme.black900.withValues(
                    alpha: 0.25,
                  ),
                  spreadRadius: 2.h,
                  blurRadius: 2.h,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          Container(
            height: 24.h,
            width: 24.h,
            margin: EdgeInsets.only(left: 10.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12.h),
              boxShadow: [
                BoxShadow(
                  color: appTheme.black900.withValues(
                    alpha: 0.25,
                  ),
                  spreadRadius: 2.h,
                  blurRadius: 2.h,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildThirtyOne(BuildContext context) {
    return CustomElevatedButton(
      height: 24.h,
      width: 36.h,
      text: "31%".toUpperCase(),
      margin: EdgeInsets.only(left: 10.h),
      buttonStyle: CustomButtonStyles.outlineBlack,
      buttonTextStyle: CustomTextStyles.labelMediumInterRed50,
    );
  }

  /// Section Widget
  Widget _buildPricingRow(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          Text(
            "3.890.000đ",
            style: CustomTextStyles.titleMediumGabaritoPrimaryBold,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.h),
            child: Text(
              "4.190.000đ",
              style: CustomTextStyles.titleSmallGabaritoGray900.copyWith(
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildRatingRow(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "4.5/5",
            style: CustomTextStyles.headlineSmallRed500,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgDefaultIcon,
            height: 16.h,
            width: 18.h,
            margin: EdgeInsets.only(left: 2.h),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.h),
            child: Text(
              "213 lượt đánh giá",
              style: CustomTextStyles.bodySmallBalooBhaiDeeppurple400,
            ),
          ),
          Spacer(),
          Text(
            "Xem tất cả",
            style: CustomTextStyles.bodyMediumAmaranthRed500,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgIconsaxBrokenArrowleft2Gray50001,
            height: 16.h,
            width: 18.h,
            margin: EdgeInsets.only(left: 4.h),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildReviewRow(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgEllipse15,
            height: 40.h,
            width: 42.h,
            radius: BorderRadius.circular(20.h),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: 12.h,
                bottom: 10.h,
              ),
              child: Text(
                "Alex Morgan",
                style: CustomTextStyles.labelLargeGray900,
              ),
            ),
          ),
          Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgDefaultIcon,
            height: 16.h,
            width: 18.h,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgDefaultIcon,
            height: 16.h,
            width: 18.h,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgDefaultIcon,
            height: 16.h,
            width: 18.h,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgDefaultIcon,
            height: 16.h,
            width: 18.h,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgDefaultIcon,
            height: 16.h,
            width: 18.h,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewRow1(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgEllipse1540x40,
            height: 40.h,
            width: 42.h,
            radius: BorderRadius.circular(20.h),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: 12.h,
                bottom: 10.h,
              ),
              child: Text(
                "Alex Morgan",
                style: CustomTextStyles.labelLargeGray900,
              ),
            ),
          ),
          Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgDefaultIcon,
            height: 16.h,
            width: 18.h,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgDefaultIcon,
            height: 16.h,
            width: 18.h,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgDefaultIcon,
            height: 16.h,
            width: 18.h,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgDefaultIcon,
            height: 16.h,
            width: 18.h,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgDefaultIcon,
            height: 16.h,
            width: 18.h,
          ),

        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildCommentButton(BuildContext context) {
    return CustomOutlinedButton(
      height: 40.h,
      text: "Bình luận",
      margin: EdgeInsets.symmetric(horizontal: 70.h),
      buttonStyle: CustomButtonStyles.outlinePrimaryTL20,
      buttonTextStyle: CustomTextStyles.bodyLargeBalooBhaijaanDeeppurple400,
    );
  }

  /// Section Widget
  Widget _buildBuyNowButton(BuildContext context) {
    return CustomElevatedButton(
      height: 52.h,
      text: "Mua ngay",
      buttonStyle: CustomButtonStyles.outlineBlackTL261,
      buttonTextStyle: CustomTextStyles.bodyLargeBalooBhaijaanWhiteA700,
    );
  }

  /// Section Widget
  Widget _buildPurchaseOptionsColumn(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.h),
      decoration: AppDecoration.outlineBlack9002,
      child: Column(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                CustomIconButton(
                  height: 40.h,
                  width: 40.h,
                  padding: EdgeInsets.all(12.h),
                  decoration: IconButtonStyleHelper.outline,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgIconsaxBrokenHeart,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 166.h,
            margin: EdgeInsets.only(left: 50.h),
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 8.h,
            ),
            decoration: AppDecoration.fillGray100.copyWith(
              borderRadius: BorderRadiusStyle.circleBorder28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40.h,
                        width: 42.h,
                        decoration: AppDecoration.outlineBlack9003.copyWith(
                          borderRadius: BorderRadiusStyle.circleBorder20,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgIconsaxBrokenMinus,
                              height: 16.h,
                              width: 18.h,
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: RotationTransition(
                            turns: AlwaysStoppedAnimation(
                              -(180 / 360),
                            ),
                            child: Text(
                              "1",
                              style: CustomTextStyles.bodyLarge18,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 40.h,
                        width: 42.h,
                        decoration: AppDecoration.outlineBlack9003.copyWith(
                          borderRadius: BorderRadiusStyle.circleBorder20,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgIconsaxBrokenAdd,
                              height: 16.h,
                              width: 18.h,
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
          _buildBuyNowButton(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildFloatingActionButton(BuildContext context) {
    return CustomFloatingButton(
      height: 50,
      width: 50,
      backgroundColor: theme.colorScheme.primary,
      shape: null,
      child: CustomImageView(
        imagePath: ImageConstant.imgBag,
        height: 25.0.h,
        width: 25.0.h,
      ),
    );
  }

}
