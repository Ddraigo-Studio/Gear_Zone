import 'package:flutter/material.dart';
import '../../core/app_export.dart';
// import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable
class AddProfileScreen extends StatelessWidget {
  AddProfileScreen({super.key});

  TextEditingController nameInputController = TextEditingController();
  TextEditingController phoneInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              height: 760.h,
              width: double.maxFinite,
              padding: EdgeInsets.only(
                left: 24.h,
                top: 24.h,
                right: 24.h,
              ),
              child: Column(
                spacing: 20,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgLaptop1,
                    height: 200.h,
                    width: 200.h,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Tạo hồ sơ",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.headlineSmallBalooBhai,
                    ),
                  ),
                  _buildFormSection(context),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildButtonSection(context),
    );
  }

  /// Section Widget
  Widget _buildNameInput(BuildContext context) {
    return CustomTextFormField(
      controller: nameInputController,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(10.h, 14.h, 8.h, 14.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgLock,
          height: 22.h,
          width: 24.h,
          fit: BoxFit.contain,
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 58.h,
      ),
      contentPadding: EdgeInsets.fromLTRB(10.h, 12.h, 12.h, 12.h),
    );
  }

  /// Section Widget
  Widget _buildPhoneInput(BuildContext context) {
    return CustomTextFormField(
      controller: phoneInputController,
      hintText: "Nhập số điện thoại",
      hintStyle: CustomTextStyles.titleMediumBaloo2Gray500,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(10.h, 14.h, 8.h, 14.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgLockGray50001,
          height: 22.h,
          width: 24.h,
          fit: BoxFit.contain,
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 56.h,
      ),
      contentPadding: EdgeInsets.fromLTRB(10.h, 12.h, 12.h, 12.h),
    );
  }

  /// Section Widget
  Widget _buildPasswordInput(BuildContext context) {
    return CustomTextFormField(
      controller: passwordInputController,
      hintText: "Nhập lại mật khẩu",
      textInputAction: TextInputAction.done,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(10.h, 14.h, 8.h, 14.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgSettings,
          height: 22.h,
          width: 18.h,
          fit: BoxFit.contain,
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 58.h,
      ),
      contentPadding: EdgeInsets.fromLTRB(10.h, 12.h, 12.h, 12.h),
    );
  }

  /// Section Widget
  Widget _buildFormSection(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Họ tên",
            style: CustomTextStyles.bodyLargeBalooBhaijaanPrimary,
          ),
          SizedBox(height: 4.h),
          _buildNameInput(context),
          SizedBox(height: 12.h),
          Text(
            "Email",
            style: CustomTextStyles.bodyLargeBalooBhaijaanBlack900_1,
          ),
          SizedBox(height: 6.h),
          _buildPhoneInput(context),
          SizedBox(height: 12.h),
          Text(
            "Số điện thoại",
            style: CustomTextStyles.bodyLargeBalooBhaijaanBlack900,
          ),
          SizedBox(height: 6.h),
          _buildPasswordInput(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildContinueButton(BuildContext context) {
    return CustomElevatedButton(
      height: 52.h,
      text: "Tiếp tục",
      buttonTextStyle: theme.textTheme.titleLarge!,
    );
  }

  /// Section Widget
  Widget _buildButtonSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 24.h,
      ),
      decoration: AppDecoration.fillWhiteA,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildContinueButton(context)],
      ),
    );
  }
}



