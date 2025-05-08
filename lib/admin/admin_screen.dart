import 'package:flutter/material.dart';
import '../core/utils/responsive.dart';
import '../widgets/admin_widgets/sidebar.dart';
import '../core/app_provider.dart';
import 'package:provider/provider.dart';
import 'Dashboard/dashboard_screen.dart';
import 'Product/product_screen.dart';
import 'Product/product_detail_screen.dart';
import 'Customer/customer_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show sidebar only on desktop
            if (Responsive.isDesktop(context)) const Sidebar(),

            // Main content area
            Expanded(
              child: Container(
                color: Color(0xffF6F6F6),
                child: Column(
                  children: [
                    // Header with search bar and notifications
                    if (!Responsive.isMobile(context)) _buildHeader(context),

                    // Main content
                    Expanded(
                      child: Consumer<AppProvider>(
                          builder: (context, appProvider, _) {
                        return _buildCurrentScreen(appProvider.currentScreen);
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Show drawer on mobile
      drawer:
          Responsive.isDesktop(context) ? null : const Drawer(child: Sidebar()),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Search bar
          Expanded(
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[500], size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Notification badges
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {},
              ),
              Positioned(
                right: 5,
                top: 2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {},
              ),
              Positioned(
                right: 6,
                top: 2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '5',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen(int screenIndex) {
    switch (screenIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const ProductScreen();
      case 2:
        return const ProductDetail();
      case 3:
        return const CustomerScreen();
      default:
        return const DashboardScreen();
    }
  }
}
