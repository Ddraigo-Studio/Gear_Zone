import 'package:flutter/material.dart';

var myDefaultBackground = Colors.grey[300];

var myAppBar = AppBar(
  backgroundColor: const Color.fromARGB(255, 220, 144, 144),
);

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
