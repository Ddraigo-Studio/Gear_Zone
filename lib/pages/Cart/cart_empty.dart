import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';

class EmptyCartScreen extends StatelessWidget {
  const EmptyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(54.h),
          child: Column(
            spacing: 24,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgParcel1,
                height: 100.h,
                width: 102.h,
              ),
              Text(
                "Chưa có sản phẩm nào trong giỏ hàng :<<<",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTextStyles.titleLargeBalooBhaijaanGray900,
              ),
              CustomElevatedButton(
                height: 54.h,
                width: 174.h,
                text: "Tiếp tục mua sắm",
                buttonStyle: CustomButtonStyles.outlineBlackTL262,
                buttonTextStyle: CustomTextStyles.bodyLargeWhiteA700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 64.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
        margin: EdgeInsets.only(
          left: 24.h,
          top: 8.h,
          bottom: 7.h,
        ),
      ),
      centerTitle: true,
      title: AppbarSubtitleOne(
        text: "Giỏ hàng",
      ),
    );
  }
}
