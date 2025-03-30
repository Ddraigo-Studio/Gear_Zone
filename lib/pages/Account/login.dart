import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gear_zone/component/colors.dart';
import 'package:gear_zone/pages/Home/home_initial_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; // Biến để hiển thị loading khi đăng nhập

  // Hàm xử lý đăng nhập Firebase
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Nếu đăng nhập thành công -> Chuyển qua trang Home
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeInitialPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Đăng nhập thất bại!";
      if (e.code == 'user-not-found') {
        message = "Không tìm thấy tài khoản!";
      } else if (e.code == 'wrong-password') {
        message = "Sai mật khẩu!";
      }

      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ksecondaryColor,
      body: Column(
        children: [
          const SizedBox(height: 40),
          // Ảnh logo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/images/imagefirst.png', height: 120),
              const SizedBox(width: 10),
              Image.asset('lib/images/imagesecond.png', height: 120),
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
                    // Tiêu đề đăng nhập
                    Center(
                      child: Text(
                        "Đăng nhập",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Ô nhập Email
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Ô nhập Mật khẩu
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Mật khẩu",
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nút Đăng nhập
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kbuttonColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "Đăng nhập",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
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
