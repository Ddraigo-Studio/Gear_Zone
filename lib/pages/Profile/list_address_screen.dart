import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
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
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 16.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [_buildAddressListColumn(context)],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.h),
        ),
        onPressed: () {
          // Xử lý khi nhấn nút thêm địa chỉ mới
          Navigator.pushNamed(context, AppRoutes.addAddressScreen);
        },
        backgroundColor: appTheme.deepPurpleA200,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 80.h,
      backgroundColor: Colors.white,
      centerTitle: true,
      shadowColor: Colors.black.withOpacity(0.4),
      elevation: 1,
      leading: IconButton(
        icon: AppbarLeadingImage(
          imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
          height: 25.h,
          width: 25.h,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
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
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Divider(
                    endIndent: 4.h,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildAddressRow(context,
                      name: "Dr. San Jose, South ",
                      phoneNumber: " (09385336256)"),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "2715 Ash Dr. San Jose, South Dakota 83475",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.titleMediumBalooBhai2Gray700,
                ),
                SizedBox(
                  height: 2.h,
                )
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
                  child: _buildAddressRow(
                    context,
                    name: "Dr. San Jose, South ",
                    phoneNumber: " (09385336256) ",
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "2715 Ash Dr. San Jose, South Dakota 83475",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.titleMediumBalooBhai2Gray700,
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
            child: _buildAddAddressRow(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAddAddressRow(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.addAddressScreen);
      },
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
                  child: Text(
                    "Thêm địa chỉ mới",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.titleMediumGabaritoPrimary,
                  ),
                ),
                CustomIconButton(
                  height: 25.h,
                  width: 25.h,
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
    );
  }

  Widget _buildAddressRow(
    BuildContext context, {
    required String name,
    required String phoneNumber,
  }) {
    return Row(
      children: [
        SizedBox(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.titleMediumBalooBhai2Gray900.copyWith(
              color: appTheme.gray900,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10.h),
          child: Text(
            phoneNumber,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.titleMediumBalooBhai2Gray900.copyWith(
              color: appTheme.gray50001,
            ),
          ),
        ),
      ],
    );
  }
}
