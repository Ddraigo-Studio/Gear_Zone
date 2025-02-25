import 'package:flutter/material.dart';


class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet; 
  final Widget desktop;  

  const ResponsiveLayout({
    super.key, 
    required this.mobile, 
    this.tablet, 
    required this.desktop
  });

  static bool isMobile(BuildContext context) => 
    MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) => 
    MediaQuery.of(context).size.width < 1080 && 
    MediaQuery.of(context).size.width >= 600;
  
  static bool isDesktop(BuildContext context) => 
    MediaQuery.of(context).size.width >= 1280;
  @override
  Widget build(BuildContext context) {
    if(isMobile(context)){
      return mobile;
    } else if(isTablet(context) && tablet != null){
      return tablet!;
    } else {
      return desktop;
    }
  }
}