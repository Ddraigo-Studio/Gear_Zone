import 'package:flutter/material.dart';
import 'package:gear_zone/admin/Product/product_detail_screen.dart';
import '../core/utils/responsive.dart';
import '../widgets/admin_widgets/sidebar.dart';
import '../core/app_provider.dart';
import 'package:provider/provider.dart';
import 'Dashboard/dashboard_screen.dart';
import 'Product/product_screen.dart';
import 'Product/product_add_screen.dart';
import 'Customer/enhanced_customer_screen.dart';
import 'Customer/customer_detail_screen.dart';
import 'Category/category_screen.dart';
import 'Category/category_detail.dart';
import 'Category/category_add_screen.dart';
import 'Voucher/voucher_screen.dart';
import 'Voucher/voucher_detail_screen.dart';
import 'Voucher/voucher_add_screen.dart';
import 'Order/order_screen.dart';
import 'Order/order_detail_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Responsive.isMobile(context)
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              actions: [
                // Notifications with badge
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
            )
          : null,
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
      ),      // Show drawer on mobile
      // We remove the 'const' keyword to ensure the Sidebar is recreated each time the drawer is opened
      drawer:
          Responsive.isDesktop(context) ? null : Drawer(child: Sidebar()),
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
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          
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
  }  Widget _buildCurrentScreen(AppScreen screenIndex) {
    return Builder(
      builder: (context) {
        // Lấy trạng thái xem/sửa từ AppProvider
        final appProvider = Provider.of<AppProvider>(context, listen: false);
        
        switch (screenIndex) {          
          case AppScreen.dashboard:
            return const DashboardScreen();
            
          case AppScreen.productList:
            return const ProductScreen(); // Màn hình danh sách sản phẩm
            
          case AppScreen.productDetail:
            // Kiểm tra nếu có productId thì hiển thị chi tiết, nếu không thì hiển thị danh sách sản phẩm
            if (appProvider.currentProductId.isNotEmpty) {
              return ProductDetail(isViewOnly: appProvider.isViewOnlyMode);
            } else {
              // Hiển thị danh sách sản phẩm, có thể lọc theo danh mục nếu có
              return const ProductScreen();
            }
            
          case AppScreen.categoryList:
            return const CategoryScreen(); // Màn hình danh sách danh mục
            
          case AppScreen.categoryDetail:
            // Kiểm tra nếu có categoryId thì hiển thị chi tiết, nếu không thì hiển thị danh sách danh mục
            if (appProvider.currentCategoryId.isNotEmpty) {
              return CategoryDetail(
                categoryId: appProvider.currentCategoryId,
                isViewOnly: appProvider.isViewOnlyMode,
              );
            } else {
              return const CategoryScreen();
            }
            
          case AppScreen.categoryAdd:
            return const CategoryAddScreen(); // Màn hình thêm danh mục mới
            
          case AppScreen.customerList:
            return const EnhancedCustomerScreen(); // Màn hình quản lý khách hàng nâng cao
            
          case AppScreen.customerDetail:
            // Kiểm tra nếu có customerId thì hiển thị chi tiết, nếu không thì hiển thị danh sách khách hàng
            if (appProvider.currentCustomerId.isNotEmpty) {
              return CustomerDetailScreen(isViewOnly: appProvider.isViewOnlyMode);
            } else {
              return const EnhancedCustomerScreen();
            }
            
          case AppScreen.productAdd:
            return const ProductAddScreen(); // Màn hình thêm sản phẩm mới
            
          case AppScreen.voucherList:
            return const VoucherScreen(); // Màn hình danh sách phiếu giảm giá
            
          case AppScreen.voucherDetail:
            // Kiểm tra nếu có voucherId thì hiển thị chi tiết, nếu không thì hiển thị danh sách voucher
            if (appProvider.currentVoucherId.isNotEmpty) {
              return VoucherDetailScreen(isViewOnly: appProvider.isViewOnlyMode);
            } else {
              return const VoucherScreen();
            }
            
          case AppScreen.voucherAdd:
            return const VoucherAddScreen(); // Màn hình thêm phiếu giảm giá mới
            
          case AppScreen.orderList:
            return const OrderScreen(); // Màn hình danh sách đơn hàng
            
          case AppScreen.orderDetail:
            // Kiểm tra nếu có orderId thì hiển thị chi tiết, nếu không thì hiển thị danh sách đơn hàng
            if (appProvider.currentOrderId.isNotEmpty) {
              return OrderDetailScreen(isViewOnly: appProvider.isViewOnlyMode);
            } else {
              return const OrderScreen();
            }
            
          default:
            return const DashboardScreen();
        }
      }
    );
  }
}
