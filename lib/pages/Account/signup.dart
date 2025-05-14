import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/custom_text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Brand color
  final Color brandColor = Color(0xFF894FC8);

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Password visibility state
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  @override
  void initState() {
    super.initState();

    _emailFocus.addListener(_handleFocusChange);
    _passwordFocus.addListener(_handleFocusChange);
    _confirmPasswordFocus.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required FocusNode focusNode,
    TextEditingController? controller,
    bool isPassword = false,
    bool? obscureText,
    VoidCallback? onTogglePasswordVisibility,
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
          color: Colors.white,
          child: CustomTextFormField(
            controller: controller,
            focusNode: focusNode,
            obscureText: isPassword ? (obscureText ?? true) : false,
            fillColor: Colors.white,
            filled: true,
            hintText: hint,
            prefix: Container(
              margin: EdgeInsets.fromLTRB(12.h, 12.h, 8.h, 12.h),
              child: Icon(
                icon,
                color: isFocused ? brandColor : Colors.grey.shade400,
                size: 22,
              ),
            ),
            suffix: isPassword
                ? GestureDetector(
                    onTap: onTogglePasswordVisibility,
                    child: Container(
                      margin: EdgeInsets.only(right: 10.h),
                      child: Icon(
                        obscureText! ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey.shade400,
                        size: 22,
                      ),
                    ),
                  )
                : null,
            borderDecoration: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isFocused ? brandColor : Colors.grey.shade400,
                width: 1,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            textStyle: TextStyle(fontSize: 16),
            hintStyle: TextStyle(
              color: Colors.grey,
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
        body: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.h, vertical: 30.h),
                color: Colors.white,
                child: _buildSignupForm(context),
              ),
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
                child: Center(
                  child: CustomImageView(
                    imagePath: 'assets/images/img_logo_2.png',
                    height: 250.h,
                    width: 250.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            
          ],
        ),
      );
    } else {
      // Layout mobile
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Phần trên sử dụng ảnh nền từ assets
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/img_bg_login.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: CustomImageView(
                  imagePath: 'assets/images/img_logo_2.png',
                  height: 130.h,
                  width: 130.h,
                ),
              ),
            ),
            // Phần dưới là form
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 20.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.h),
                    topRight: Radius.circular(30.h),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: _buildSignupForm(context),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  // Widget chung để xây dựng form đăng ký cho cả desktop và mobile
  Widget _buildSignupForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Đăng ký",
            style: TextStyle(
              fontSize: 32.h,
              fontWeight: FontWeight.bold,
              color: brandColor,
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
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          label: "Mật khẩu",
          hint: "Nhập mật khẩu",
          icon: Icons.lock_outline,
          controller: _passwordController,
          focusNode: _passwordFocus,
          isPassword: true,
          obscureText: _obscurePassword,
          onTogglePasswordVisibility: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          label: "Xác nhận lại",
          hint: "Nhập lại mật khẩu",
          icon: Icons.lock_outline,
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocus,
          isPassword: true,
          obscureText: _obscureConfirmPassword,
          onTogglePasswordVisibility: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
        SizedBox(height: 35.h),
        Container(
          width: double.infinity,
          height: 55.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.h),
            boxShadow: [
              BoxShadow(
                color: brandColor.withOpacity(0.25),
                blurRadius: 8.h,
                offset: Offset(0, 4.h),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: brandColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.h),
              ),
            ),
            child: Text(
              "Đăng ký",
              style: TextStyle(
                fontSize: 18.h,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 30.h),
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: RichText(
              text: TextSpan(
                text: "Đã có tài khoản? ",
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 15.h,
                ),
                children: [
                  TextSpan(
                    text: "Đăng nhập ngay",
                    style: TextStyle(
                      color: brandColor,
                      fontSize: 15.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
