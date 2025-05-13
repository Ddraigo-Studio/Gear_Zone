import 'package:flutter/material.dart';

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
    const purpleColor = Color(0xFF894FC8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isFocused ? purpleColor : const Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isFocused ? purpleColor : Colors.transparent,
              width: 1.5,
            ),
            color: const Color(0xFFF5F5F5),
          ),
          child: TextField(
            focusNode: focusNode,
            obscureText: isPassword,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: isFocused ? purpleColor : Colors.grey,
                size: 22,
              ),
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Phần trên sử dụng ảnh nền từ assets
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/img_bg_login.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/images/imagefirst.png', height: 150),
                  const SizedBox(height: 5),
                  const Text(
                    'GEAR ZONE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'LOVELIVE TEAM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [                    const Center(
                      child: Text(
                        "Đăng ký",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF894FC8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

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
                    const SizedBox(height: 20),                    const SizedBox(height: 15),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF894FC8),
                          elevation: 0,
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
                    const SizedBox(height: 30),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: "Đã có tài khoản? ",
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 16,
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
