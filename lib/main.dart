import 'package:flutter/material.dart';
import 'package:gear_zone/pages/Home/home_page.dart';




void main() {
  runApp( const MyApp());
}  
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: HomePage(),
    );
  }
}




