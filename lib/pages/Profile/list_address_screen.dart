import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/custom_icon_button.dart';
import '../../controller/auth_controller.dart';
import '../../model/user.dart';

class ListAddressScreen extends StatefulWidget {
  const ListAddressScreen({super.key});

  @override
  State<ListAddressScreen> createState() => _ListAddressScreenState();
}

class _ListAddressScreenState extends State<ListAddressScreen> {
  @override
  Widget build(BuildContext context) {
    // Lấy thông tin người dùng từ AuthController
    final authController = Provider.of<AuthController>(context);
    final UserModel? userModel = authController.userModel;

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
              children: [_buildAddressListColumn(context, userModel)],
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
          Navigator.pushNamed(context, AppRoutes.addAddressScreen).then((_) {
            // Làm mới màn hình khi quay lại từ trang thêm địa chỉ mới
            setState(() {});
          });
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
  Widget _buildAddressListColumn(BuildContext context, UserModel? userModel) {
    // Nếu không có người dùng đăng nhập hoặc không có địa chỉ
    if (userModel == null || userModel.addressList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100.h),
            Icon(
              Icons.location_off_outlined,
              size: 80.h,
              color: appTheme.deepPurpleA200.withOpacity(0.7),
            ),
            SizedBox(height: 16.h),
            Text(
              "Bạn chưa có địa chỉ nào",
              style: TextStyle(
                color: appTheme.gray900,
                fontSize: 18.h,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Thêm địa chỉ để sử dụng cho đơn hàng của bạn",
              style: TextStyle(
                color: appTheme.gray600,
                fontSize: 14.h,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 10,
        children: [
          // Hiển thị danh sách địa chỉ
          ...userModel.addressList.map((address) {
            final bool isDefault = address['id'] == userModel.defaultAddressId;
            final String title = address['title'] ?? "Địa chỉ";
            final String name = address['name'] ?? "";
            final String phoneNumber = address['phoneNumber'] ?? "";
            final String fullAddress = address['fullAddress'] ?? "";

            return Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(bottom: 10.h),
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
                          title,
                          style: CustomTextStyles.titleMediumGabaritoPrimary,
                        ),
                        if (isDefault)
                          Container(
                            margin: EdgeInsets.only(left: 16.h),
                            padding: EdgeInsets.symmetric(horizontal: 10.h),
                            decoration: AppDecoration.outlineRedA200.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder5,
                            ),
                            child: Text(
                              "Mặc định",
                              textAlign: TextAlign.center,
                              style:
                                  CustomTextStyles.titleMediumGabaritoRedA200,
                            ),
                          ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.editAddressScreen,
                              arguments: {'address': address},
                            ).then((updated) {
                              if (updated == true) {
                                setState(() {
                                  // Refresh khi quay lại từ trang chỉnh sửa
                                });
                              }
                            });
                          },
                          child: CustomImageView(
                            imagePath: ImageConstant.imgTablerEdit,
                            height: 24.h,
                            width: 26.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
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
                      name: name,
                      phoneNumber: phoneNumber,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    fullAddress,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.titleMediumBalooBhai2Gray700,
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            );
          }).toList(),

          // Thêm địa chỉ mới
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
        Navigator.pushNamed(context, AppRoutes.addAddressScreen).then((_) {
          // Làm mới màn hình khi quay lại từ trang thêm địa chỉ
          setState(() {});
        });
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
        Flexible(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.titleMediumBalooBhai2Gray900.copyWith(
              color: appTheme.gray900,
            ),
          ),
        ),
        if (phoneNumber.isNotEmpty)
          Container(
            margin: EdgeInsets.only(left: 10.h),
            child: Text(
              phoneNumber.startsWith("0") ? phoneNumber : "($phoneNumber)",
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
