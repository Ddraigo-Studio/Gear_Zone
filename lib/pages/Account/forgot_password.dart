import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../controller/auth_controller.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Brand color
  final Color brandColor = Color(0xFF894FC8);

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _emailFocus = FocusNode();

  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Phương thức gửi email khôi phục mật khẩu
  Future<void> _resetPassword(BuildContext context) async {
    // Kiểm tra xác thực form
    if (!_formKey.currentState!.validate()) {
      // Form không hợp lệ
      return;
    }

    final authController = Provider.of<AuthController>(context, listen: false);

    // Gọi controller để xử lý khôi phục mật khẩu
    final success = await authController.sendPasswordResetEmail(
      email: _emailController.text.trim(),
    );

    if (success) {
      // Hiển thị dialog thông báo thành công
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: Column(
              children: [
                Icon(
                  Icons.email_outlined,
                  color: brandColor,
                  size: 50,
                ),
                SizedBox(height: 10.h),
                Text(
                  "Đã gửi email!",
                  style: TextStyle(
                    color: brandColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Chúng tôi đã gửi hướng dẫn khôi phục mật khẩu tới email của bạn. Vui lòng kiểm tra hộp thư và làm theo hướng dẫn.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.h,
                  ),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.h),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Quay lại đăng nhập",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required FocusNode focusNode,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    bool isFocused = focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isFocused ? brandColor : const Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Material(
          elevation: isFocused ? 2 : 0,
          shadowColor: brandColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          child: CustomTextFormField(
            controller: controller,
            focusNode: focusNode,
            fillColor: Colors.white,
            filled: true,
            hintText: hint,
            validator: validator,
            prefix: Container(
              margin: EdgeInsets.fromLTRB(12.h, 12.h, 8.h, 12.h),
              child: Icon(
                icon,
                color: isFocused ? brandColor : Colors.grey.shade400,
                size: 22,
              ),
            ),
            borderDecoration: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isFocused ? brandColor : Colors.grey.shade200,
                width: isFocused ? 1.5 : 1,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            textStyle: TextStyle(fontSize: 16),
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      // Layout desktop - 2 cột
      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 70.h, vertical: 30.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.h),
                          bottomLeft: Radius.circular(20.h),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: _buildForgotPasswordForm(context)),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/img_bg_login_des.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(15.h),
                          child: CustomImageView(
                            imagePath: 'assets/images/img_logo_2.png',
                            height: 180.h,
                            width: 180.h,
                            fit: BoxFit.contain,
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
      );
    } else {
      // Layout mobile
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Phần background
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/img_bg_login.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Phần logo
            Positioned(
              top: MediaQuery.of(context).size.height * 0.13,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(12.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: CustomImageView(
                    imagePath: 'assets/images/img_logo_2.png',
                    height: 100.h,
                    width: 100.h,
                  ),
                ),
              ),
            ),
            // Phần form quên mật khẩu
            Positioned(
              top: MediaQuery.of(context).size.height * 0.32,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 30.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.h),
                    topRight: Radius.circular(40.h),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: Offset(0, -5),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: _buildForgotPasswordForm(context),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  // Widget chung để xây dựng form quên mật khẩu cho cả desktop và mobile
  Widget _buildForgotPasswordForm(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: brandColor),
            onPressed: () => Navigator.pop(context),
          ),
          Center(
            child: Text(
              "Quên mật khẩu",
              style: TextStyle(
                fontSize: 32.h,
                fontWeight: FontWeight.bold,
                color: brandColor,
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Center(
            child: Text(
              "Nhập email của bạn để nhận hướng dẫn khôi phục mật khẩu",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.h,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          SizedBox(height: 30.h),
          _buildTextField(
            label: "Email",
            hint: "Nhập email",
            icon: Icons.email_outlined,
            controller: _emailController,
            focusNode: _emailFocus,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Email không hợp lệ';
              }
              return null;
            },
          ),
          if (authController.error != null)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                authController.error!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.h,
                ),
              ),
            ),
          SizedBox(height: 35.h),
          Container(
            width: double.infinity,
            height: 55.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.h),
              boxShadow: [
                BoxShadow(
                  color: brandColor.withOpacity(0.35),
                  blurRadius: 12.h,
                  offset: Offset(0, 6.h),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: authController.isLoading
                  ? null
                  : () => _resetPassword(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: brandColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.h),
                ),
              ),
              child: authController.isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Gửi hướng dẫn khôi phục",
                      style: TextStyle(
                        fontSize: 18.h,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 25.h),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              child: Text(
                "Quay lại đăng nhập",
                style: TextStyle(
                  color: brandColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
