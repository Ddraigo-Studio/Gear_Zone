import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../Setting/setting_screen.dart';
import 'home_initial_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Mảng các màn hình ứng với từng index
  final List<Widget> _screens = [
    HomeInitialPage(),
    DefaultWidget(), // Bạn có thể thay thế với màn hình thích hợp
    DefaultWidget(),
    SettingsScreen(), // Trang Setting
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.maxFinite,
        child: _buildBottomBar(context),
      ),
    );
  }

  // Tạo Bottom Navigation Bar
  Widget _buildBottomBar(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {
          setState(() {
            _currentIndex = type.index; // Chuyển đổi giữa các màn hình
          });
        },
      ),
    );
  }
}
