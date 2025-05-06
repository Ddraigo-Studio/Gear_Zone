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
      resizeToAvoidBottomInset: false,
      backgroundColor: appTheme.deepPurple1003f,
      body: SafeArea(
        top: false,
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
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.h),
          bottomRight: Radius.circular(24.h),
        ),
        image: DecorationImage(
          image: AssetImage(ImageConstant.imgMaskGroup),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 50.h),
          // Phần avatar và tên người dùng
          Center(
            child: Column(
              children: [
                Container(
                  height: 100.h,
                  width: 100.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.h,
                    ),
                    image: DecorationImage(
                      image: AssetImage(ImageConstant.imgProfile),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  "Gilbert Jones",
                  style:
                      CustomTextStyles.bodyLargeBalooBhaijaanWhiteA700.copyWith(
                    fontSize: 24.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Badge "Khách hàng thân thiết"
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20.h),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgMedal,
                  height: 20.h,
                  width: 20.h,
                ),
                SizedBox(width: 8.h),
                Text(
                  "Khách hàng thân thiết",
                  style: CustomTextStyles.bodyLargeBalooBhaijaanWhiteA700.copyWith(
                    fontSize: 16.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Thẻ thông tin với viền cong và nền trắng
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 24.h),
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.h),
            ),
            child: Column(
              children: [
                // Phần điểm tích lũy
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Điểm tích lũy: ",
                        style: CustomTextStyles
                            .titleMediumGabaritoBlack900SemiBold
                            .copyWith(
                          fontSize: 18.h,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: "100 điểm",
                        style: CustomTextStyles.titleMediumGabaritoDeeppurple400
                            .copyWith(
                          fontSize: 18.h,
                          color: appTheme.deepPurpleA200,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                // Phần ngày kích hoạt
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Ngày kích hoạt: ",
                        style: TextStyle(
                          fontSize: 16.h,
                          color: appTheme.red400,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: "10/04/2025",
                        style: TextStyle(
                          fontSize: 16.h,
                          color: appTheme.red400,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
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
        Navigator.pushNamed(context, AppRoutes.listAddressScreen);
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
