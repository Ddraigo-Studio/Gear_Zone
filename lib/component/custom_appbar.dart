import 'package:flutter/material.dart';
import 'menu_drawer.dart'; // Import file mới tạo

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double opacity;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({
    Key? key,
    required this.opacity,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(44, 111, 30, 118).withOpacity(opacity),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "GEARZONE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            // Sử dụng widget CustomAppBarIcons để hiển thị các icon hành động
            CustomAppBarIcons(
              onSearch: () {
                // Hành động tìm kiếm
              },
              onCart: () {
                // Hành động giỏ hàng
              },
              onMenu: () {
                // Mở Drawer thông qua scaffoldKey
                scaffoldKey.currentState?.openDrawer();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
