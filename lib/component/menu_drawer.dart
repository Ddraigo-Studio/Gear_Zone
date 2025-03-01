import 'package:flutter/material.dart';

class CustomAppBarIcons extends StatelessWidget {
  final VoidCallback onSearch;
  final VoidCallback onCart;
  final VoidCallback onMenu;

  const CustomAppBarIcons({
    Key? key,
    required this.onSearch,
    required this.onCart,
    required this.onMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: onSearch,
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart, color: Colors.white),
          onPressed: onCart,
        ),
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: onMenu,
        ),
      ],
    );
  }
}
