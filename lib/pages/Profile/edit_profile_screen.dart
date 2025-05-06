import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable
class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  TextEditingController nameInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController phoneInputController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                _buildProfileHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(16.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildNameInput(context),
                          SizedBox(height: 26.h),
                          _buildEmailInput(context),
                          SizedBox(height: 26.h),
                          _buildPhoneInput(context),
                          SizedBox(height: 70.h),
                          _buildSaveButton(context),
                          SizedBox(height: 12.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildProfileHeader(BuildContext context) {
    return SizedBox(
      height: 356.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgBgEditProfile,
            height: 356.h,
            width: double.maxFinite,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(
                left: 24.h,
                top: 16.h,
                right: 24.h,
              ),
              child: Column(
                spacing: 56,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomAppBar(
                    height: 40.h,
                    leadingWidth: 40.h,
                    leading: AppbarLeadingIconbutton(
                      imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
                    ),
                    centerTitle: true,
                    title: AppbarTitle(
                      text: "Hồ sơ của tôi",
                    ),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgProfile,
                    height: 90.h,
                    width: 92.h,
                    radius: BorderRadius.circular(
                      44.h,
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
  Widget _buildNameInput(BuildContext context) {
    return CustomTextFormField(
      controller: nameInputController,
      hintText: "Gilbert Jones",
      hintStyle: CustomTextStyles.bodyLargeBalooBhaijaanGray700,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(10.h, 14.h, 8.h, 14.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgLockGray500012x24,
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
  Widget _buildEmailInput(BuildContext context) {
    return CustomTextFormField(
      controller: emailInputController,
      hintText: "Gilbertjones001@gmail.com",
      hintStyle: CustomTextStyles.bodyLargeBalooBhaijaanGray700,
      textInputType: TextInputType.emailAddress,
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
  Widget _buildPhoneInput(BuildContext context) {
    return CustomTextFormField(
      controller: phoneInputController,
      hintText: "121-224-7890 |",
      hintStyle: CustomTextStyles.bodyLargeBalooBhaijaanGray700,
      textInputAction: TextInputAction.done,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(10.h, 14.h, 8.h, 14.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgCall,
          height: 22.h,
          width: 24.h,
          fit: BoxFit.contain,
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 56.h,
      ),
      contentPadding: EdgeInsets.fromLTRB(10.h, 12.h, 12.h, 12.h),
      borderDecoration: TextFormFieldStyleHelper.outlinePrimaryTL10,
    );
  }

  /// Section Widget
  Widget _buildSaveButton(BuildContext context) {
    return CustomElevatedButton(
      height: 44.h,
      text: "Lưu",
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      leftIcon: Container(
        margin: EdgeInsets.only(right: 12.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgDownload,
          height: 24.h,
          width: 24.h,
          fit: BoxFit.contain,
        ),
      ),
      buttonStyle: CustomButtonStyles.fillPrimaryTL22,
      buttonTextStyle: CustomTextStyles.bodyLargeBalooBhaijaanWhiteA700,
    );
  }

}
