import 'package:flutter/material.dart';
import 'package:gear_zone/component/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _emailFocus.addListener(() => setState(() {}));
    _passwordFocus.addListener(() => setState(() {}));
    _confirmPasswordFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required FocusNode focusNode,
    bool isPassword = false,
  }) {
    bool isFocused = focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isFocused ? ksecondaryColor : Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          focusNode: focusNode,
          obscureText: isPassword,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: isFocused ? ksecondaryColor : Colors.grey,
            ),
            hintText: hint,
            filled: true,
            fillColor: kbackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isFocused ? ksecondaryColor : Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: ksecondaryColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ksecondaryColor,
      body: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/images/imagesecond.png', height: 120),
              const SizedBox(width: 10),
              Image.asset('lib/images/imagefirst.png', height: 120),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: kbackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return kGradientAuth.createShader(bounds);
                        },
                        child: const Text(
                          "Đăng ký",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildTextField(
                      label: "Email",
                      hint: "Nhập email",
                      icon: Icons.email_outlined,
                      focusNode: _emailFocus,
                    ),
                    const SizedBox(height: 15),

                    _buildTextField(
                      label: "Mật khẩu",
                      hint: "Nhập mật khẩu",
                      icon: Icons.lock_outline,
                      focusNode: _passwordFocus,
                      isPassword: true,
                    ),
                    const SizedBox(height: 15),

                    _buildTextField(
                      label: "Xác nhận lại",
                      hint: "Nhập lại mật khẩu",
                      icon: Icons.lock_outline,
                      focusNode: _confirmPasswordFocus,
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kbuttonColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text(
                          "Đăng ký",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: "Đã có tài khoản? ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: "Đăng nhập ngay",
                                style: TextStyle(
                                  color: Color(0xFF894FC8),
                                  fontSize: 16,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
