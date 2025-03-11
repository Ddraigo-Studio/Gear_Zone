import 'package:flutter/material.dart';
import 'package:gear_zone/pages/Home/home_page.dart';
import 'package:gear_zone/pages/Account/register.dart';
import 'component/bottom_nav_bar.dart';




void main() {
  runApp( const MyApp());
}  
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SignUpPage(),
      ),
      
    );
  }
}




