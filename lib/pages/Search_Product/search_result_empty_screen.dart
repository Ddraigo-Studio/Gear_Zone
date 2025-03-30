import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton_one.dart';
import '../../widgets/app_bar/appbar_title_searchview.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';

// ignore_for_file: must_be_immutable
class SearchResultEmptyScreen extends StatelessWidget {
  SearchResultEmptyScreen({super.key});

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppbar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(46.h),
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgSearch1,
                height: 100.h,
                width: 102.h,
              ),
              Text(
                "Xin lỗi, chúng tôi không tìm thấy sản phẩm bạn yêu cầu",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTextStyles.headlineSmallBalooBhai,
              ),
              CustomElevatedButton(
                height: 62.h,
                text: "Tiếp tục mua sắm",
                margin: EdgeInsets.symmetric(horizontal: 48.h),
                buttonStyle: CustomButtonStyles.fillPrimaryTL30,
                buttonTextStyle: CustomTextStyles.titleLargeBalooBhaijaan,
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 56.h,
      leading: AppbarLeadingIconbuttonOne(
        imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 8.h,
          bottom: 8.h,
        ),
      ),
      title: SizedBox(
        width: double.maxFinite,
        child: AppbarTitleSearchview(
          margin: EdgeInsets.only(left: 16.h),
          hintText: "Jacket",
          controller: searchController,
        ),
      ),
      actions: [
        AppbarTrailingIconbuttonOne(
          imagePath: ImageConstant.imgFilter,
          height: 44.h,
          width: 44.h,
          margin: EdgeInsets.only(
            top: 5.h,
            right: 17.h,
            bottom: 6.h,
          ),
        ),
      ],
    );
  }

}
