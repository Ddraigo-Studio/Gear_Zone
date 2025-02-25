import 'package:flutter/material.dart';
import 'package:gear_zone/responsive/responsive_layout.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: builMobile(),
      tablet: buildTablet(),
      desktop: buildDesktop(),
    );
  }
  
  Widget builMobile() => Container(
    color: Colors.red,
    child: Center(
      child: Text('Mobile'),
    ),
  );

  Widget buildTablet() => Container(
    color: Colors.blue,
    child: Center(
      child: Text('Tablet'),
    ),
  );

  Widget buildDesktop() => Container(
    color: Colors.green,
    child: Center(
      child: Text('Desktop'),
    ),
  );

}