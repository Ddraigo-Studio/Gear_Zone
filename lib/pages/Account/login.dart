import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../controller/auth_controller.dart';
import 'package:provider/provider.dart';
import '../../controller/cart_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Brand color
  final Color brandColor = Color(0xFF894FC8);
  
  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Password visibility state
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    _emailFocus.addListener(_handleFocusChange);
    _passwordFocus.addListener(_handleFocusChange);
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  // Phương thức đăng nhập người dùng
  Future<void> _loginUser(BuildContext context) async {
    // Kiểm tra xác thực form
    if (!_formKey.currentState!.validate()) {
      // Form không hợp lệ
      return;
    }
    
    final authController = Provider.of<AuthController>(context, listen: false);
    final cartController = Provider.of<CartController>(context, listen: false);
    
    // Gọi controller để xử lý đăng nhập
    final success = await authController.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
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
      
      // Chuyển đến trang chủ (phương thức từ controller)
      authController.navigateToHomeScreen(context);
    }
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
                    padding: EdgeInsets.symmetric(horizontal: 70.h, vertical: 30.h),
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
                    child: _buildLoginForm(context)),
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
            // Phần form đăng nhập
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
                  child: _buildLoginForm(context),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  // Widget chung để xây dựng form đăng nhập cho cả desktop và mobile
  Widget _buildLoginForm(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Đăng nhập",
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
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
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(              
              onTap: () {
                // View chỉ gọi đến controller để xử lý - chờ tính năng quên mật khẩu
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Tính năng đang được phát triển"),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: Text(
                "Quên mật khẩu?",
                style: TextStyle(
                  color: brandColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.h,
                ),
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
                : () => _loginUser(context),
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
                  "Đăng nhập",
                  style: TextStyle(
                    fontSize: 18.h,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
            ),
          ),          
          SizedBox(height: 30.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.h),
                  height: 1,
                  color: Colors.grey.shade300,
                ),
              ),
              Text(
                "Hoặc đăng nhập bằng",
                style: TextStyle(
                  fontSize: 15.h,
                  color: Color(0xFF666666),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.h),
                  height: 1,
                  color: Colors.grey.shade300,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),          
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(                
                icon: "assets/images/ic_google.png", 
                onPressed: () {
                  // View chỉ gọi đến controller để xử lý - chờ tính năng được thêm vào controller
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Tính năng đang được phát triển"),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
              ),
              SizedBox(width: 16.h),
              _buildSocialButton(                
                icon: "assets/images/ic_facebook.png", 
                onPressed: () {
                  // View chỉ gọi đến controller để xử lý - chờ tính năng được thêm vào controller
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Tính năng đang được phát triển"),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
              ),
              SizedBox(width: 20.h),
              _buildSocialButton(                
                icon: "assets/images/ic_apple.png", 
                onPressed: () {
                  // View chỉ gọi đến controller để xử lý - chờ tính năng được thêm vào controller
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Tính năng đang được phát triển"),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 30.h),
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                ),
              ),
              child: GestureDetector(                
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.signup);
                },
                child: RichText(
                  text: TextSpan(
                    text: "Chưa có tài khoản? ",
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 15.h,
                    ),
                    children: [
                      TextSpan(
                        text: "Đăng ký ngay",
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
  Widget _buildSocialButton({
    required String icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Image.asset(
          icon, 
          height: 30.h,
          width: 30.h,
        ),
      ),
    );
  }
}