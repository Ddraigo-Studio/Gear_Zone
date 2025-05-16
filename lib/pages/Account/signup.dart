import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../controller/auth_controller.dart';

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

  // Focus nodes
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();

  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_handleFocusChange);
    _nameFocus.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _nameFocus.dispose();
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required FocusNode focusNode,
    required TextEditingController controller,
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

  void _proceedToAddress(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(
        context,
        AppRoutes.addAddressScreen,
        arguments: {
          'fromRegistration': true,
          'email': _emailController.text.trim(),
          'name': _nameController.text.trim(),
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    if (Responsive.isDesktop(context)) {
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
                      padding: EdgeInsets.symmetric(horizontal: 70.h, vertical: 30.h),
                      physics: BouncingScrollPhysics(),
                      child: _buildSignupForm(context),
                    ),
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
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
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
                  : () => _proceedToAddress(context),
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
                      "Tiếp theo",
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
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
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
      ),
    );
  }
}