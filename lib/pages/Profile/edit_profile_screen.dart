import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController phoneInputController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Focus nodes để theo dõi trạng thái focus của các trường
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    
    // Thêm listener để cập nhật UI khi trạng thái focus thay đổi
    _nameFocus.addListener(() {
      setState(() {});
    });
    _emailFocus.addListener(() {
      setState(() {});
    });
    _phoneFocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Giải phóng focus nodes khi widget bị hủy
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    nameInputController.dispose();
    emailInputController.dispose();
    phoneInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, 
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        bottom: false, 
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(context),
                Container(
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
                      // Thêm padding ở cuối để đảm bảo có không gian cho bàn phím
                     
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Profile Header Widget
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 356.h,
      child: Stack(
        children: [
          // Background gradient image
          CustomImageView(
            imagePath: ImageConstant.imgBgEditProfile,
            width: double.maxFinite,
            height: 356.h,
            fit: BoxFit.contain,
          ),
          
          // AppBar được đặt ở đây, phía trên cùng
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.only(top: 16.h, left: 16.h, right: 16.h),
              child: Row(
                children: [
                  Container(
                    height: 48.h,
                    width: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: AppbarLeadingImage(
                        imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
                        height: 24.h,
                        width: 24.h,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.h, right: 48.h), // Để cân bằng với nút back
                        child: AppbarSubtitleTwo(
                          text: "Hồ sơ của tôi",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Profile image
          Positioned(
            top: 150.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 100.h,
                width: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3.h,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgProfile,
                    height: 100.h,
                    width: 100.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          
          // Camera icon
          Positioned(
            top: 220.h,
            left: MediaQuery.of(context).size.width / 2 + 20.h,
            child: Container(
              padding: EdgeInsets.all(8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                color: appTheme.deepPurpleA200,
                size: 20.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildNameInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: _nameFocus.hasFocus ? theme.colorScheme.primary : appTheme.gray50001,
          width: 1.h,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: nameInputController,
        focusNode: _nameFocus,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập họ tên';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "Nhập họ tên",
          hintStyle: CustomTextStyles.bodyLargeBalooBhaijaanGray700,
          errorStyle: CustomTextStyles.bodyLargeBalooBhaijaanGray700.copyWith(color: Colors.red, fontSize: 12.h),
          prefixIcon: Padding(
            padding: EdgeInsets.all(14.h),
            child: Icon(
              Icons.person_outline,
              size: 24.h,
              color: _nameFocus.hasFocus ? theme.colorScheme.primary : appTheme.gray50001,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.h),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
        style: CustomTextStyles.bodyLargeBalooBhaijaanGray900,
      ),
    );
  }

  /// Section Widget
  Widget _buildEmailInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: _emailFocus.hasFocus ? theme.colorScheme.primary : appTheme.gray50001,
          width: 1.h,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: emailInputController,
        focusNode: _emailFocus,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập email';
          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Email không hợp lệ';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "Nhập email",
          hintStyle: CustomTextStyles.bodyLargeBalooBhaijaanGray700,
          errorStyle: CustomTextStyles.bodyLargeBalooBhaijaanGray700.copyWith(color: Colors.red, fontSize: 12.h),
          prefixIcon: Padding(
            padding: EdgeInsets.all(14.h),
            child: Icon(
              Icons.email_outlined,
              size: 24.h,
              color: _emailFocus.hasFocus ? theme.colorScheme.primary : appTheme.gray50001,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.h),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
        style: CustomTextStyles.bodyLargeBalooBhaijaanGray900,
      ),
    );
  }

  /// Section Widget
  Widget _buildPhoneInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: _phoneFocus.hasFocus ? theme.colorScheme.primary : appTheme.gray50001,
          width: 1.h,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: phoneInputController,
        focusNode: _phoneFocus,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập số điện thoại';
          } else if (!RegExp(r'^\d{3}-\d{3}-\d{4}$').hasMatch(value) && 
                    !RegExp(r'^\d{10}$').hasMatch(value)) {
            return 'Số điện thoại không hợp lệ';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "Số điện thoại",
          hintStyle: CustomTextStyles.bodyLargeBalooBhaijaanGray700,
          errorStyle: CustomTextStyles.bodyLargeBalooBhaijaanGray700.copyWith(color: Colors.red, fontSize: 12.h),
          prefixIcon: Padding(
            padding: EdgeInsets.all(14.h),
            child: Icon(
              Icons.phone_outlined,
              size: 24.h,
              color: _phoneFocus.hasFocus ? theme.colorScheme.primary : appTheme.gray50001,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.h),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
        style: CustomTextStyles.bodyLargeBalooBhaijaanGray900,
      ),
    );
  }

  /// Section Widget
  Widget _buildSaveButton(BuildContext context) {
    return Container(
      height: 44.h,
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Thông tin đã được cập nhật'),
                backgroundColor: Colors.green,
              ),
            );
            
            
            Navigator.pop(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.deepPurpleA200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.h),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.save_alt,
              color: appTheme.whiteA700,
              size: 20.h,
            ),
            SizedBox(width: 12.h),
            Text(
              "Lưu",
              style: CustomTextStyles.bodyLargeBalooBhaijaanWhiteA700,
            ),
          ],
        ),
      ),
    );
  }
}
