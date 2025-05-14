import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../Profile/edit_profile_screen.dart';
import '../Profile/list_address_screen.dart';
import '../../controller/auth_controller.dart';
import '../../widgets/bottom_sheet/change_password_bottomsheet.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appTheme.deepPurple1003f,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: isDesktop ? 1200.0 : double.maxFinite,
              padding: isDesktop ? EdgeInsets.symmetric(horizontal: 20.h) : null,
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
    final bool isDesktop = Responsive.isDesktop(context);
    final authController = Provider.of<AuthController>(context);
    final userModel = authController.userModel;
    
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(isDesktop ? 32.h : 24.h),
          bottomRight: Radius.circular(isDesktop ? 32.h : 24.h),
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
                      image: userModel?.photoURL != null && userModel!.photoURL!.isNotEmpty
                          ? NetworkImage(userModel.photoURL!)
                          : AssetImage(ImageConstant.imgProfile) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  userModel?.name ?? "Chưa đăng nhập",
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
          SizedBox(height: 24.h),          // Thẻ thông tin với viền cong và nền trắng
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: Responsive.isDesktop(context) ? 200.h : 24.h),
            padding: EdgeInsets.symmetric(
              vertical: Responsive.isDesktop(context) ? 32.h : 24.h, 
              horizontal: Responsive.isDesktop(context) ? 24.h : 16.h
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Responsive.isDesktop(context) ? 24.h : 16.h),
              boxShadow: Responsive.isDesktop(context) ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                )
              ] : null,
            ),            child: Column(
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
                        text: "${userModel?.loyaltyPoints ?? 0} điểm",
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
                        text: userModel != null 
                            ? DateFormat('dd/MM/yyyy').format(userModel.createdAt)
                            : "Chưa kích hoạt",
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
    final bool isDesktop = Responsive.isDesktop(context);
    final authController = Provider.of<AuthController>(context);
    final userModel = authController.userModel;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 200.h : 30.h),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24.h : 12.h,
        vertical: isDesktop ? 16.h : 4.h,
      ),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: isDesktop ? BorderRadiusStyle.roundedBorder12 : BorderRadiusStyle.roundedBorder8,
        boxShadow: isDesktop ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ] : null,
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
                  userModel?.name ?? "Chưa đăng nhập",
                  style: CustomTextStyles.titleMediumGabaritoGray900Bold,
                ),
                Text(
                  userModel?.email ?? "Email chưa cung cấp",
                  style: CustomTextStyles.bodyLargeGray900,
                ),
                Text(
                  userModel?.phoneNumber ?? "Số điện thoại chưa cung cấp",
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
  }  Widget _buttonAddress(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    
    return CustomElevatedButton(
      height: isDesktop ? 60.h : 50.h,
      text: "Địa chỉ",
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 200.h : 24.h),
      leftIcon: Container(
        margin: EdgeInsets.only(right: isDesktop ? 15.h : 10.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgFa6SolidMapLocation,
          height: isDesktop ? 28.h : 24.h,
          width: isDesktop ? 28.h : 24.h,
          fit: BoxFit.contain,
        ),
      ),
      rightIcon: CustomImageView(
        imagePath: ImageConstant.imgIconsaxBrokenArrowright2,
        height: isDesktop ? 28.h : 24.h,
        width: isDesktop ? 30.h : 26.h,
      ),
      buttonStyle: CustomButtonStyles.fillWhiteA,
      buttonTextStyle: isDesktop 
          ? CustomTextStyles.titleMediumGabaritoGray900SemiBold.copyWith(fontSize: 18.h)
          : CustomTextStyles.titleMediumGabaritoGray900SemiBold,
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.listAddressScreen);
      },
    );
  }  Widget _buttonChangePassword(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    
    return CustomElevatedButton(
      height: isDesktop ? 60.h : 54.h,
      text: "Đổi mật khẩu",
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 200.h : 24.h),
      leftIcon: Container(
        margin: EdgeInsets.only(right: isDesktop ? 15.h : 10.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgTeenyiconspasswordoutline,
          height: isDesktop ? 26.h : 22.h,
          width: isDesktop ? 26.h : 22.h,
          fit: BoxFit.contain,
        ),
      ),
      rightIcon: CustomImageView(
        imagePath: ImageConstant.imgIconsaxBrokenArrowright2,
        height: isDesktop ? 28.h : 24.h,
        width: isDesktop ? 30.h : 26.h,
      ),
      buttonStyle: CustomButtonStyles.fillWhiteA,      buttonTextStyle: isDesktop 
          ? CustomTextStyles.titleMediumGabaritoGray900SemiBold.copyWith(fontSize: 18.h)
          : CustomTextStyles.titleMediumGabaritoGray900SemiBold,
      onPressed: () {
        ChangePasswordBottomSheet.show(context);
      },
    );
  }
  /// Section Widget
  Widget _buildSupportChatSection(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    
    return CustomElevatedButton(
      height: isDesktop ? 60.h : 54.h,
      text: "Trò chuyện với trung tâm hỗ trợ",
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 200.h : 24.h),
      leftIcon: Container(
        margin: EdgeInsets.only(right: isDesktop ? 15.h : 10.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgBxSupport,
          height: isDesktop ? 26.h : 22.h,
          width: isDesktop ? 26.h : 22.h,
          fit: BoxFit.contain,
        ),
      ),
      rightIcon: CustomImageView(
        imagePath: ImageConstant.imgIconsaxBrokenArrowright2,
        height: isDesktop ? 28.h : 24.h,
        width: isDesktop ? 30.h : 26.h,
      ),
      buttonStyle: CustomButtonStyles.fillWhiteA,
      buttonTextStyle: isDesktop 
          ? CustomTextStyles.titleMediumGabaritoGray900SemiBold.copyWith(fontSize: 18.h)
          : CustomTextStyles.titleMediumGabaritoGray900SemiBold,
    );
  }  Widget _buttonLogout(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final authController = Provider.of<AuthController>(context);
    
    return CustomElevatedButton(
      height: isDesktop ? 60.h : 50.h,
      text: "Đăng xuất",
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 200.h : 24.h),
      leftIcon: Container(
        margin: EdgeInsets.only(right: isDesktop ? 15.h : 10.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgThumbsup,
          height: isDesktop ? 28.h : 24.h,
          width: isDesktop ? 28.h : 24.h,
          fit: BoxFit.contain,
        ),
      ),
      buttonStyle: CustomButtonStyles.fillWhiteA,
      buttonTextStyle: isDesktop 
          ? CustomTextStyles.titleMediumGabaritoRed500SemiBold.copyWith(fontSize: 18.h)
          : CustomTextStyles.titleMediumGabaritoRed500SemiBold,
      onPressed: () async {
        // Hiển thị hộp thoại xác nhận trước khi đăng xuất
        bool confirm = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Xác nhận đăng xuất"),
              content: Text("Bạn có chắc chắn muốn đăng xuất?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("Hủy"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Đăng xuất"),
                ),
              ],
            );
          },
        ) ?? false;
        
        if (confirm) {
          await authController.signOut();
          // Chuyển về màn hình đăng nhập sau khi đăng xuất
          Navigator.pushNamedAndRemoveUntil(
            context, 
            AppRoutes.login, 
            (route) => false
          );
          
          // Hiển thị thông báo đăng xuất thành công
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Đăng xuất thành công"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }      },
    );
  }
}
