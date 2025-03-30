import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(
                    left: 16.h,
                    top: 40.h,
                    right: 16.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [_buildPaymentMethodsList(context)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildConfirmationButton(context),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 88.h,
      leadingWidth: 64.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
        margin: EdgeInsets.only(
          left: 24.h,
          top: 24.h,
          bottom: 23.h,
        ),
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Phương thức thanh toán",
      ),
      styleType: Style.bgShadowBlack900_1,
    );
  }

  /// Section Widget
  Widget _buildPaymentMethodsList(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 16,
        children: [
          Container(
            padding: EdgeInsets.all(10.h),
            decoration: AppDecoration.fillGray100.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Thẻ nội địa Napas",
                        style: CustomTextStyles.bodyMediumGray900_1,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Text(
                              "**** 4187",
                              style: theme.textTheme.bodyLarge,
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgNapas,
                              height: 16.h,
                              width: 24.h,
                              margin: EdgeInsets.only(left: 16.h),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
                  height: 24.h,
                  width: 24.h,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.h,
              vertical: 20.h,
            ),
            decoration: AppDecoration.fillGray100.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgArcticonsMomo,
                  height: 24.h,
                  width: 26.h,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 10.h,
                    bottom: 4.h,
                  ),
                  child: Text(
                    "Thanh toán ví Momo",
                    style: CustomTextStyles.bodyMediumGray900_1,
                  ),
                ),
                Spacer(),
                CustomImageView(
                  imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
                  height: 24.h,
                  width: 26.h,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.h,
              vertical: 22.h,
            ),
            decoration: AppDecoration.fillGray100.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgTdesignMoney,
                  height: 24.h,
                  width: 26.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.h),
                  child: Text(
                    "Thanh toán khi nhận hàng",
                    style: CustomTextStyles.bodyMediumGray900_1,
                  ),
                ),
                Spacer(),
                CustomImageView(
                  imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
                  height: 24.h,
                  width: 26.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
  /// Section Widget
  Widget _buildConfirmationButton(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 24.h,
        vertical: 18.h,
      ),
      decoration: AppDecoration.fillWhiteA,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            height: 64.h,
            text: "Đồng ý",
            buttonStyle: CustomButtonStyles.outlineBlackTL321,
            buttonTextStyle: theme.textTheme.titleLarge!,
          ),
        ],
      ),
    );
  }

}
