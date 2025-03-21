import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.deepPurple5001,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  _buildLoyaltyPointsSection(context),
                  SizedBox(height: 30.h),
                  _buildProfileInfoSection(context),
                  SizedBox(height: 30.h),
                  _buildAddressSection(context),
                  SizedBox(height: 8.h),
                  _buildSupportChatSection(context),
                  SizedBox(height: 8.h),
                  CustomElevatedButton(
                    height: 54.h,
                    text: "Đổi mật khẩu",
                    margin: EdgeInsets.symmetric(horizontal: 24.h),
                    leftIcon: Container(
                      margin: EdgeInsets.only(right: 10.h),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgTeenyiconspasswordoutline,
                        height: 22.h,
                        width: 22.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    buttonStyle: CustomButtonStyles.fillWhiteA,
                    buttonTextStyle:
                        CustomTextStyles.titleMediumGabaritoGray900SemiBold,
                  ),
                  SizedBox(height: 8.h),
                  CustomElevatedButton(
                    height: 50.h,
                    text: "Đăng xuất",
                    margin: EdgeInsets.symmetric(horizontal: 24.h),
                    leftIcon: Container(
                      margin: EdgeInsets.only(right: 10.h),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgThumbsup,
                        height: 24.h,
                        width: 24.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    buttonStyle: CustomButtonStyles.fillWhiteA,
                    buttonTextStyle:
                        CustomTextStyles.titleMediumGabaritoRed500SemiBold,
                  ),
                  SizedBox(height: 58.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildLoyaltyPointsSection(BuildContext context) {
    return SizedBox(
      height: 382.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 30.h),
            padding: EdgeInsets.symmetric(vertical: 32.h),
            decoration: AppDecoration.fillWhiteA.copyWith(
              borderRadius: BorderRadiusStyle.customBorderBL20,
            ),
            child: Column(
              spacing: 4,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Điểm tích lũy:",
                      style:
                          CustomTextStyles.titleMediumGabaritoBlack900SemiBold,
                    ),
                    Text(
                      "100 điểm",
                      style: CustomTextStyles.titleMediumGabaritoDeeppurple400,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Ngày kích hoạt: ",
                      style: CustomTextStyles.labelLargeRed400,
                    ),
                    Text(
                      "10/04/2025",
                      style: CustomTextStyles.labelLargeRed400,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 50.h),
                        decoration: AppDecoration.row35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgEllipse14,
                              height: 90.h,
                              width: 90.h,
                              radius: BorderRadius.circular(44.h),
                              margin: EdgeInsets.only(top: 94.h),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30.h),
                    child: Text(
                      "Gilbert Jones",
                      style:
                          CustomTextStyles.bodyLargeBalooBhaijaanDeeppurple50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildProfileInfoSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.h),
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 4.h,
      ),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Gilbert Jones",
                  style: CustomTextStyles.titleMediumGabaritoGray900Bold,
                ),
                Text(
                  "Gilbertjones001@gmail.com",
                  style: CustomTextStyles.bodyLargeGray900,
                ),
                Text(
                  "121-224-7890",
                  style: CustomTextStyles.bodyLargeGray900,
                ),
              ],
            ),
          ),
          Text(
            "Chỉnh sửa",
            style: CustomTextStyles.labelLargePrimary,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildAddressSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.h),
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 14.h,
      ),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgFa6SolidMapLocation,
            height: 24.h,
            width: 28.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.h),
            child: Text(
              "Địa chỉ",
              style: CustomTextStyles.titleMediumGabaritoGray900SemiBold,
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
    );
  }

  /// Section Widget
  Widget _buildSupportChatSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.h),
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 16.h,
      ),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgBxSupport,
            height: 24.h,
            width: 26.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.h),
            child: Text(
              "Trò chuyện với trung tâm hỗ trợ",
              style: CustomTextStyles.titleMediumGabaritoGray900SemiBold,
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
    );
  }



}
