import 'package:flutter/material.dart';
import 'package:gear_zone/component/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<StatefulWidget> createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        width: 390,
        height: 844,
        decoration: BoxDecoration(
          color: const Color(0xff733bdc),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Stack(
          children: [
            Positioned(
              left: -20,
              width: 217,
              top: 59,
              height: 155,
              child: Image.asset('images/sign_in_2.png', width: 217, height: 155, fit: BoxFit.cover),
            ),
            Positioned(
              left: 170,
              width: 252,
              top: 13,
              height: 180,
              child: Image.asset('images/sign_in_1.png', width: 252, height: 180, fit: BoxFit.cover),
            ),
            Positioned(
              left: 0,
              width: 390,
              bottom: 0,
              height: 630,
              child: Container(
                width: 390,
                height: 630,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  boxShadow: const [BoxShadow(color: Color(0x3f000000), offset: Offset(0, -3), blurRadius: 4)],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, top: 30, right: 24, bottom: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Đăng ký',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.balooBhai2(
                          fontSize: 32, 
                          letterSpacing: -0.41,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..shader = linearColor.createShader(Rect.fromLTWH(0, 0, 400, 70)),
                          
                        ),
                        maxLines: 9999,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color(0xff733bdc),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xfff4f4f4),
                                    prefixIcon: Icon(Icons.email, color: primaryColor),
                                    hintText: 'Nhập email',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: const Color(0xcc8e6cee), width: 2),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Mật khẩu',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color(0xdd000000),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xfff4f4f4),
                                    prefixIcon: Icon(Icons.lock, color: const Color(0xff894fc8)),
                                    hintText: 'Nhập mật khẩu',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Xác nhận lại',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: confirmPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xfff4f4f4),
                                    prefixIcon: Icon(Icons.lock, color: const Color(0xff894fc8)),
                                    hintText: 'Nhập lại mật khẩu',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff8e6cee),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 11),
                                child: Center(
                                  child: Text(
                                    'Đăng ký',
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 18,
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Đã có tài khoản? ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: const Color(0xff000000),
                                      // fontFamily: 'Gabarito-Bold',
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Đăng nhập ngay',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: primaryColor,
                                      // fontFamily: 'Gabarito-Bold',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
