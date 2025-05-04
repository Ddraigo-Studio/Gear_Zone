import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../Profile/edit_profile_screen.dart';
import '../Profile/list_address_screen.dart';

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
                  _buttonAddress(context),
                  SizedBox(height: 10.h),
                  _buildSupportChatSection(context),
                  SizedBox(height: 10.h),
                  _buttonChangePassword(context),
                  SizedBox(height: 10.h),
                  _buttonLogout(context),
                  SizedBox(height: 10.h),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgProfile,
                              height: 90.h,
                              width: 90.h,
                              radius: BorderRadius.circular(44.h),
                              margin: EdgeInsets.only(top: 94.h),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 94.h, left: 10),
                              child: Text(
                                "Gilbert Jones",
                                style: CustomTextStyles
                                    .bodyLargeBalooBhaijaanDeeppurple50,
                              ),
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
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(),
                ),
              );
            },
            child: Text(
              "Chỉnh sửa",
              style: CustomTextStyles.labelLargePrimary,
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonAddress(BuildContext context) {
    return CustomElevatedButton(
      alignment: Alignment.centerLeft,
      height: 50.h,
      text: "Địa chỉ",
      margin: EdgeInsets.symmetric(horizontal: 24.h),
      leftIcon: Container(
        margin: EdgeInsets.only(right: 10.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgFa6SolidMapLocation,
          height: 24.h,
          width: 24.h,
          fit: BoxFit.contain,
        ),
      ),
      rightIcon: CustomImageView(
        imagePath: ImageConstant.imgIconsaxBrokenArrowright2,
        height: 24.h,
        width: 26.h,
      ),
      buttonStyle: CustomButtonStyles.fillWhiteA,
      buttonTextStyle: CustomTextStyles.titleMediumGabaritoGray900SemiBold,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListAddressScreen(),
          ),
        );
      },
    );
  }

  Widget _buttonChangePassword(BuildContext context) {
    return CustomElevatedButton(
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
      buttonTextStyle: CustomTextStyles.titleMediumGabaritoGray900SemiBold,
    );
  }

  /// Section Widget
  Widget _buildSupportChatSection(BuildContext context) {
    return CustomElevatedButton(
      height: 54.h,
      text: "Trò chuyện với trung tâm hỗ trợ",
      margin: EdgeInsets.symmetric(horizontal: 24.h),
      leftIcon: Container(
        margin: EdgeInsets.only(right: 10.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgBxSupport,
          height: 22.h,
          width: 22.h,
          fit: BoxFit.contain,
        ),
      ),
      rightIcon: CustomImageView(
        imagePath: ImageConstant.imgIconsaxBrokenArrowright2,
        height: 24.h,
        width: 26.h,
      ),
      buttonStyle: CustomButtonStyles.fillWhiteA,
      buttonTextStyle: CustomTextStyles.titleMediumGabaritoGray900SemiBold,
    );
  }

  Widget _buttonLogout(BuildContext context) {
    return CustomElevatedButton(
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
      buttonTextStyle: CustomTextStyles.titleMediumGabaritoRed500SemiBold,
    );
  }
}
