import 'package:flutter/material.dart';

class ResponsiveHomeLayout extends StatelessWidget {
  final Widget child;

  const ResponsiveHomeLayout({
    super.key,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {    // Responsive layout that takes full width
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: child,
    );
  }
}
