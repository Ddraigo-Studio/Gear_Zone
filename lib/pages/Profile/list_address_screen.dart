import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';

class ListAddressScreen extends StatelessWidget {
  const ListAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray100,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(
            left: 16.h,
            top: 58.h,
            right: 16.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [_buildAddressListColumn(context)],
          ),
        ),
      ),
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
      title: AppbarSubtitleTwo(
        text: "Thông tin nhận hàng",
      ),
    );
  }

  /// Section Widget
  Widget _buildAddressListColumn(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 10,
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 18.h,
            ),
            decoration: AppDecoration.fillWhiteA.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Text(
                        "Nhà",
                        style: CustomTextStyles.titleMediumGabaritoPrimary,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16.h),
                        padding: EdgeInsets.symmetric(horizontal: 10.h),
                        decoration: AppDecoration.outlineRedA200.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder5,
                        ),
                        child: Text(
                          "Mặc định",
                          textAlign: TextAlign.center,
                          style: CustomTextStyles.titleMediumGabaritoRedA200,
                        ),
                      ),
                      Spacer(),
                      CustomImageView(
                        imagePath: ImageConstant.imgTablerEdit,
                        height: 24.h,
                        width: 26.h,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h,),
                SizedBox(
                  width: double.maxFinite,
                  child: Divider(
                    endIndent: 4.h,
                  ),
                ),
                SizedBox(height: 8.h,),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCompanyAddressRow(
                    context,
                    drsanjoseOne: "Dr. San Jose, South ",
                    p09385336256One: " (09385336256)"
                  ),
                ),
                SizedBox(height: 2.h,),
                Text(
                  "2715 Ash Dr. San Jose, South Dakota 83475",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.titleMediumBalooBhai2Gray900,
                ),
                SizedBox(height: 2.h,)
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 18.h,
            ),
            decoration: AppDecoration.fillWhiteA.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Công ty",
                        style: CustomTextStyles.titleMediumGabaritoPrimary,
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgTablerEdit,
                        height: 24.h,
                        width: 26.h,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Divider(
                    endIndent: 4.h,
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCompanyAddressRow(
                    context,
                    drsanjoseOne: "Dr. San Jose, South ",
                    p09385336256One: " (09385336256) ",
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "2715 Ash Dr. San Jose, South Dakota 83475",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.titleMediumBalooBhai2Gray900,
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 18.h,
              vertical: 8.h,
            ),
            decoration: AppDecoration.fillWhiteA.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder5,
            ),
            child: Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Divider(),
                ),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 124.h,
                        child: Text(
                          "Thêm địa chỉ mới",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyles.bodyLargePrimary,
                        ),
                      ),
                      CustomIconButton(
                        height: 24.h,
                        width: 24.h,
                        padding: EdgeInsets.all(2.h),
                        decoration: IconButtonStyleHelper.none,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgGgAdd,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyAddressRow(
    BuildContext context, {
    required String drsanjoseOne,
    required String p09385336256One,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 136.h,
          child: Text(
            drsanjoseOne,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: appTheme.gray900,
            ),
          ),
        ),
        Container(
          width: 92.h,
          margin: EdgeInsets.only(left: 10.h),
          child: Text(
            p09385336256One,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.bodyMediumGray50001.copyWith(
              color: appTheme.gray50001,
            ),
          ),
        ),
      ],
    );
  }

}
