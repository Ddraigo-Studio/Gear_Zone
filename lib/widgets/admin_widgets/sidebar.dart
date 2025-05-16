

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gear_zone/core/app_export.dart';
import 'package:gear_zone/core/app_provider.dart';
import 'package:gear_zone/controller/category_controller.dart';
import 'package:gear_zone/controller/product_controller.dart';
import 'package:gear_zone/model/category.dart';
import 'package:provider/provider.dart';
import 'package:gear_zone/core/utils/responsive.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebardState();
}

class _SidebardState extends State<Sidebar> {
  final CategoryController _categoryController = CategoryController();
  bool _isProductsExpanded = false;
  
  @override
  void initState() {
    super.initState();
    // Kiểm tra xem có nên mở mục sản phẩm khi khởi tạo không
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      if (appProvider.currentScreen == AppScreen.productList ||
          appProvider.currentScreen == AppScreen.productDetail ||
          appProvider.currentScreen == AppScreen.productAdd ||
          appProvider.selectedCategory.isNotEmpty) {
        setState(() {
          _isProductsExpanded = true;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: isMobile ? double.infinity : 250,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  child: Image.asset(
                    'assets/images/img_logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Company',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      'GearZone Store',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Make the menu items scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section title
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Text(
                      'TỔNG QUAN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.dashboard_outlined,
                    title: 'Bảng điều khiển',
                    screen: AppScreen.dashboard,
                    currentScreen: appProvider.currentScreen,
                  ),

                  FutureBuilder<int>(
                    future: CategoryController().getCategoriesCount(),
                    builder: (context, snapshot) {
                      final categoryCount = snapshot.data?.toString() ?? "0";
                      return _buildMenuItem(
                        context,
                        icon: Icons.category_outlined,
                        title: 'Danh mục sản phẩm',
                        screen: AppScreen.categoryList,
                        currentScreen: appProvider.currentScreen,
                        detail: categoryCount,
                      );
                    },
                  ),

                  _buildProductsMenu(context, appProvider),

                  _buildMenuItem(
                    context,
                    icon: Icons.card_giftcard_rounded,
                    title: 'Voucher',
                    screen: AppScreen.customerList, // Tạm thời dùng màn hình khách hàng, sau này có thể thay bằng voucher
                    currentScreen: appProvider.currentScreen,
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.receipt_outlined,
                    title: 'Đơn hàng',
                    screen: AppScreen.dashboard, // Tạm thời dùng màn hình Dashboard vì chưa có màn hình đơn hàng
                    currentScreen: appProvider.currentScreen,
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.people_outline,
                    title: 'Khách hàng',
                    screen: AppScreen.customerList,
                    currentScreen: appProvider.currentScreen,
                  ),

                  const Divider(height: 32),

                  // Tools section
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Text(
                      'CÔNG CỤ',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Cài đặt',
                    screen: AppScreen.dashboard, // Tạm thời sử dụng dashboard vì chưa có màn hình cài đặt
                    currentScreen: appProvider.currentScreen,
                  ),
                  
                  _buildMenuItem(
                    context,
                    icon: Icons.chat_outlined,
                    title: 'Hộp thoại',
                    screen: AppScreen.dashboard, // Tạm thời sử dụng dashboard vì chưa có màn hình hộp thoại
                    currentScreen: appProvider.currentScreen,
                  ),
                ],
              ),
            ),
          ),

          // User profile section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFEEEEEE), width: 1
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'assets/images/img_user_3.png',
                    fit: BoxFit.cover,
                  ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Admin GearZone',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Quản trị viên',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 13,
                  width: 13,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Tạo menu sản phẩm riêng biệt với các tiểu mục
  Widget _buildProductsMenu(BuildContext context, AppProvider appProvider) {
    final isSelected = appProvider.currentScreen == AppScreen.productList ||
                       appProvider.currentScreen == AppScreen.productDetail ||
                       appProvider.currentScreen == AppScreen.productAdd;
    final themeColor = Theme.of(context).primaryColor;
    
    return FutureBuilder<int>(
      future: ProductController().getTotalProductCount(),
      builder: (context, snapshot) {
        final productCount = snapshot.data?.toString() ?? "0";
        
        return Column(
          children: [
            // Phần tiêu đề menu sản phẩm
            InkWell(
              onTap: () {
                // Xử lý sự kiện khi nhấp vào tiêu đề menu sản phẩm
                appProvider.setCurrentScreen(AppScreen.productList);
                appProvider.resetSelectedCategory();
                appProvider.setCurrentProductId('');
                
                if (Responsive.isMobile(context)) {
                  Navigator.pop(context);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFF2F6FF) : Colors.transparent,
                  border: Border(
                    left: BorderSide(
                      color: isSelected ? themeColor : Colors.transparent,
                      width: 4,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 18,
                      color: isSelected ? themeColor : Colors.grey[600],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Sản phẩm',
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? themeColor : Colors.black87,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    const Spacer(),
                    // Số lượng sản phẩm
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        productCount,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // Nút mở/đóng danh mục con
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isProductsExpanded = !_isProductsExpanded;
                        });
                      },
                      child: Icon(
                        _isProductsExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Phần danh sách các danh mục sản phẩm
            if (_isProductsExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Consumer<AppProvider>(
                  builder: (context, appProvider, _) {
                    String selectedCategory = appProvider.selectedCategory;
                    
                    return StreamBuilder<List<CategoryModel>>(
                      stream: _categoryController.getCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: SizedBox(
                                width: 20, 
                                height: 20, 
                                child: CircularProgressIndicator(strokeWidth: 2)
                              ),
                            ),
                          );
                        }
                        
                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Lỗi: ${snapshot.error}',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        
                        final categories = snapshot.data ?? [];
                        
                        if (categories.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Không có danh mục nào'),
                          );
                        }
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: categories.map((category) {
                            final categoryName = category.categoryName;
                            
                            return _buildCategoryItem(
                              context,
                              categoryName,
                              displayName: categoryName,
                              isActive: selectedCategory.toLowerCase() == categoryName.toLowerCase()
                            );
                          }).toList(),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        );
      }
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    AppScreen? screen,
    int? index,
    required dynamic currentScreen,
    String? detail,
  }) {
    final isSelected = screen != null 
        ? screen == currentScreen 
        : index == currentScreen;
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    return InkWell(
      onTap: () {
        if (screen != null) {
          appProvider.setCurrentScreen(screen);
        } else if (index != null) {
          // Legacy support for index-based navigation
          appProvider.setCurrentScreenByIndex(index);
        }
        if (Responsive.isMobile(context)) {
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF2F6FF) : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 4,
            ),
          )
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (detail != null) ...[
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryItem(BuildContext context, String title, {String? displayName, bool isActive = false}) {
    final themeColor = Theme.of(context).primaryColor;
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final productController = ProductController();
    
    return FutureBuilder<int>(
      future: productController.countProductsByCategory(title),
      builder: (context, snapshot) {
        final productCount = snapshot.data ?? 0;
        
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Log category selection for debugging
              print('Chọn danh mục: "$title"');
              
              // Đặt danh mục được chọn vào Provider
              appProvider.setSelectedCategory(title);
              
              if (appProvider.currentProductId.isNotEmpty) {
                appProvider.setCurrentProductId('');
                appProvider.setCurrentScreen(AppScreen.productList, isViewOnly: false);
              } else {
                appProvider.setCurrentScreen(AppScreen.productList);
              }
              
              if (Responsive.isMobile(context)) {
                Navigator.pop(context);
              }
            },
            splashColor: Colors.transparent,
            highlightColor: themeColor.withOpacity(0.1),
            child: Row(
              children: [
                SvgPicture.asset(
                  'icons/icon_line.svg',
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    isActive ? themeColor : Colors.deepPurple[400] ?? Colors.grey, 
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  displayName ?? title,
                  style: TextStyle(
                    fontSize: 14,
                    color: isActive ? themeColor : Colors.deepPurple[400] ?? Colors.grey, 
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    productCount.toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

