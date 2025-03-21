import 'package:flutter/material.dart';
import '../../core/app_export.dart';
// import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/appbar_subtitle_three.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable
class AddressNewScreen extends StatelessWidget {
  AddressNewScreen({super.key});

  TextEditingController nameInputController = TextEditingController();

  TextEditingController phoneInputController = TextEditingController();

  List<String> dropdownItemList = ["Item One", "Item Two", "Item Three"];

  List<String> dropdownItemList1 = ["Item One", "Item Two", "Item Three"];

  List<String> dropdownItemList2 = ["Item One", "Item Two", "Item Three"];

  TextEditingController addressInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
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
                    top: 32.h,
                    right: 16.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          spacing: 16,
                          children: [
                            _buildNameInput(context),
                            _buildPhoneInput(context),
                            CustomDropDown(
                              icon: Container(
                                margin: EdgeInsets.only(left: 16.h),
                                child: CustomImageView(
                                  imagePath:
                                      ImageConstant.imgIconsaxBrokenArrowdown2,
                                  height: 24.h,
                                  width: 24.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              iconSize: 24.h,
                              hintText: "Tỉnh",
                              items: dropdownItemList,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.h,
                                vertical: 10.h,
                              ),
                            ),
                            CustomDropDown(
                              icon: Container(
                                margin: EdgeInsets.only(left: 16.h),
                                child: CustomImageView(
                                  imagePath:
                                      ImageConstant.imgIconsaxBrokenArrowdown2,
                                  height: 24.h,
                                  width: 24.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              iconSize: 24.h,
                              hintText: "Quận/huyện",
                              items: dropdownItemList1,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.h,
                                vertical: 10.h,
                              ),
                            ),
                            CustomDropDown(
                              icon: Container(
                                margin: EdgeInsets.only(left: 16.h),
                                child: CustomImageView(
                                  imagePath:
                                      ImageConstant.imgIconsaxBrokenArrowdown2,
                                  height: 24.h,
                                  width: 24.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              iconSize: 24.h,
                              hintText: "Phường/ Thị xã",
                              items: dropdownItemList2,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.h,
                                vertical: 10.h,
                              ),
                            ),
                            _buildAddressInput(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildCompletionSection(context),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 64.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
        margin: EdgeInsets.only(
          left: 24.h,
          top: 8.h,
          bottom: 8.h,
        ),
      ),
      centerTitle: true,
      title: AppbarSubtitleThree(
        text: "Nhập địa chỉ",
      ),
    );
  }

  /// Section Widget
  Widget _buildNameInput(BuildContext context) {
    return CustomTextFormField(
      controller: nameInputController,
      hintText: "Họ và tên",
      hintStyle: CustomTextStyles.bodyLargeGray900,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 10.h,
      ),
    );
  }

    /// Section Widget
  Widget _buildPhoneInput(BuildContext context) {
    return CustomTextFormField(
      controller: phoneInputController,
      hintText: "Số điện thoại",
      hintStyle: CustomTextStyles.bodyLargeGray900,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 10.h,
      ),
    );
  }

  /// Section Widget
  Widget _buildAddressInput(BuildContext context) {
    return CustomTextFormField(
      controller: addressInputController,
      hintText: "Số nhà, tên đường ...",
      hintStyle: CustomTextStyles.bodyLargeGray900,
      textInputAction: TextInputAction.done,
      maxLines: 4,
      contentPadding: EdgeInsets.fromLTRB(12.h, 10.h, 12.h, 12.h),
    );
  }

  /// Section Widget
  Widget _buildCompleteButton(BuildContext context) {
    return CustomElevatedButton(
      height: 52.h,
      text: "Hoàn thành",
      buttonTextStyle: theme.textTheme.titleLarge!,
    );
  }

  /// Section Widget
  Widget _buildCompletionSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 24.h,
        vertical: 16.h,
      ),
      decoration: AppDecoration.fillWhiteA,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildCompleteButton(context)],
      ),
    );
  }


}
