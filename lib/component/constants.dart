import 'package:flutter/material.dart';

var myDefaultBackground = Colors.grey[300];

PreferredSizeWidget myAppBar() {
  return PreferredSize(
    preferredSize: Size.fromHeight(80),
     // Chiều cao AppBar
    child: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1F1F21), // Màu nền của AppBar
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo bên trái + Menu
            Row(
              children: [
                // Logo PHLOX
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyan, width: 2), // Viền cyan
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "PHLOX",
                    style: TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 20),
                // Menu Items
                menuItem("Home"),
                menuItem("About", isSelected: true),
                menuItem("Contact"),
                menuItem("Shop"),
                menuItem("Blog"),
              ],
            ),

            // Thông tin liên hệ bên phải
            Row(
              children: [
                Icon(Icons.email, color: Colors.white, size: 16),
                SizedBox(width: 5),
                Text("info@phlox.pro", style: TextStyle(color: Colors.grey[400])),
                SizedBox(width: 10),
                VerticalDivider(color: Colors.white30, thickness: 1, width: 20),
                Icon(Icons.phone, color: Colors.white, size: 16),
                SizedBox(width: 5),
                Text("909 25468 546", style: TextStyle(color: Colors.grey[400])),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// Widget tạo menu item
Widget menuItem(String title, {bool isSelected = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Text(
      title,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.grey,
        fontSize: 16,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );
}

var myDrawer = Drawer(
      backgroundColor: Colors.grey[300],
      child: Column(
        children: const [
          DrawerHeader(child: Icon(Icons.favorite)),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Dasboard'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ]
      )
    );
