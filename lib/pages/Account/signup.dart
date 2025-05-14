import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../controller/auth_controller.dart';
import 'package:provider/provider.dart';
import '../../controller/cart_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Brand color
  final Color brandColor = Color(0xFF894FC8);

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode(); // Thêm cho tên hiển thị
  final FocusNode _phoneFocus = FocusNode(); // Thêm cho số điện thoại

  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController =
      TextEditingController(); // Thêm controller tên
  final TextEditingController _phoneController =
      TextEditingController(); // Thêm controller SĐT

  // Password visibility state
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  @override
  void initState() {
    super.initState();

    _emailFocus.addListener(_handleFocusChange);
    _passwordFocus.addListener(_handleFocusChange);
    _confirmPasswordFocus.addListener(_handleFocusChange);
    _nameFocus.addListener(_handleFocusChange);
    _phoneFocus.addListener(_handleFocusChange);
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
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
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
            obscureText: isPassword ? (obscureText ?? true) : false,
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
            suffix: isPassword
                ? GestureDetector(
                    onTap: onTogglePasswordVisibility,
                    child: Container(
                      margin: EdgeInsets.only(right: 10.h),
                      child: Icon(
                        obscureText! ? Icons.visibility_off : Icons.visibility,
                        color: obscureText ? Colors.grey.shade400 : brandColor,
                        size: 22,
                      ),
                    ),
                  )
                : null,
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
  }  // Phương thức đăng ký người dùng
  Future<void> _registerUser(BuildContext context) async {
    // Kiểm tra xác thực form
    if (!_formKey.currentState!.validate()) {
      // Form không hợp lệ
      return;
    }
    
    final authController = Provider.of<AuthController>(context, listen: false);
    final cartController = Provider.of<CartController>(context, listen: false);
    
    // Gọi controller để xử lý đăng ký
    final success = await authController.registerWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      cartController: cartController,
      context: context,
    );
    
    if (success) {
      // Hiển thị thông báo thành công nếu có
      if (authController.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authController.successMessage!),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
        // Chuyển đến màn hình thêm địa chỉ thay vì trang chủ
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.addAddressScreen,
        (route) => false,
        arguments: {'fromRegistration': true},
      );
    }
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
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 70.h, vertical: 30.h),
                        physics: BouncingScrollPhysics(),
                        child: _buildSignupForm(context),
                      )),
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
            // Phần form đăng ký
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
    final authController = Provider.of<AuthController>(context);

    return Form(
      key: _formKey,
      child: Column(
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
            label: "Họ và tên",
            hint: "Nhập họ và tên",
            icon: Icons.person_outline,
            controller: _nameController,
            focusNode: _nameFocus,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập họ và tên';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          _buildTextField(
            label: "Số điện thoại",
            hint: "Nhập số điện thoại",
            icon: Icons.phone_android_outlined,
            controller: _phoneController,
            focusNode: _phoneFocus,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập số điện thoại';
              }
              if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                return 'Số điện thoại không hợp lệ';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mật khẩu';
              }
              if (value.length < 6) {
                return 'Mật khẩu phải có ít nhất 6 ký tự';
              }
              return null;
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng xác nhận mật khẩu';
              }
              if (value != _passwordController.text) {
                return 'Mật khẩu xác nhận không khớp';
              }
              return null;
            },
          ),
          if (authController.error != null)
            Padding(
              padding: EdgeInsets.only(top: 16.h),
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
                  : () => _registerUser(context),
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
                      "Đăng ký",
                      style: TextStyle(
                        fontSize: 18.h,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
            ),
          ),          SizedBox(height: 30.h),
          Center(
            child: GestureDetector(
              onTap: () {                // Hủy màn hình hiện tại và chuyển qua màn hình đăng nhập
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
              child: Container(
                child: RichText(
                  text: TextSpan(
                    text: "Đã có tài khoản? ",
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 15.h,
                    ),
                    children: [
                      TextSpan(
                        mouseCursor: SystemMouseCursors.click,
                        text: "Đăng nhập ngay",
                        style: TextStyle(
                          color: brandColor,
                          fontSize: 15.h,
                          fontWeight: FontWeight.bold,
                          decorationColor: brandColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
