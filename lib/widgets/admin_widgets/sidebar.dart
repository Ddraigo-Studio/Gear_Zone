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
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final CategoryController _categoryController = CategoryController();
  
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
            margin: const EdgeInsets.all(8),
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
                    index: 0,
                    currentIndex: appProvider.currentScreen,
                  ),

                  FutureBuilder<int>(
                    future: CategoryController().getCategoriesCount(),
                    builder: (context, snapshot) {
                      final categoryCount = snapshot.data?.toString() ?? "0";
                      return _buildMenuItem(
                        context,
                        icon: Icons.category_outlined,
                        title: 'Danh mục sản phẩm',
                        index: 3, // Đổi thành index 3 để phù hợp với cấu trúc mới
                        currentIndex: appProvider.currentScreen,
                        detail: categoryCount,
                      );
                    },
                  ),

                  FutureBuilder<int>(
                    future: ProductController().getTotalProductCount(),
                    builder: (context, snapshot) {
                      final productCount = snapshot.data?.toString() ?? "0";
                      return _buildNestedMenuItem(
                        context,
                        icon: Icons.inventory_2_outlined,
                        title: 'Sản phẩm',
                        index: 1,  // Đổi thành index 1
                        currentIndex: appProvider.currentScreen,
                        detail: productCount,
                      );
                    }
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.card_giftcard_rounded,
                    title: 'Voucher',
                    index: 6,  // Cập nhật index
                    currentIndex: appProvider.currentScreen,
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.receipt_outlined,
                    title: 'Đơn hàng',
                    index: 8,  // Cập nhật index
                    currentIndex: appProvider.currentScreen,
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.people_outline,
                    title: 'Khách hàng',
                    index: 9,  // Cập nhật index
                    currentIndex: appProvider.currentScreen,
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
                    index: 10,  // Cập nhật index
                    currentIndex: appProvider.currentScreen,
                  ),
                  
                  _buildMenuItem(
                    context,
                    icon: Icons.chat_outlined,
                    title: 'Hộp thoại',
                    index: 11,  // Cập nhật index
                    currentIndex: appProvider.currentScreen,
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

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
    required int currentIndex,
    String? detail,
  }) {
    final isSelected = index == currentIndex;
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    return InkWell(
      onTap: () {
        appProvider.setCurrentScreen(index);
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

  Widget _buildNestedMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
    required int currentIndex,
    String? detail,
  }) {
    final isSelected = index == currentIndex;
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final themeColor = Theme.of(context).primaryColor;
    
    // Thêm FutureBuilder để lấy số lượng sản phẩm từ Firestore
    final categoryCount = detail ?? "0";

    return Theme(
      // Sử dụng Theme để loại bỏ đường viền màu đen của ExpansionTile
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        expansionTileTheme: ExpansionTileThemeData(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent)
          ),
        ),
      ),
      child: ExpansionTile(
        onExpansionChanged: (isExpanded) {
          if (isExpanded) {
            appProvider.setCurrentScreen(1);
            // Khi chọn menu chính "Sản phẩm", hiển thị tất cả sản phẩm
            // Reset cả category và productId
            appProvider.resetSelectedCategory();
            appProvider.setCurrentProductId(''); // Reset ID sản phẩm để hiển thị danh sách thay vì chi tiết
            if (Responsive.isMobile(context)) {
              Navigator.pop(context);
            }
          }
        },
        initiallyExpanded: isSelected,
        tilePadding: EdgeInsets.symmetric(horizontal: 16.h,),
        leading: Icon(
          icon, 
          size: 18, 
          color: isSelected ? themeColor : Colors.grey[600],
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? themeColor : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (detail != null)
              Container(
                margin: const EdgeInsets.only(right: 8),
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
            Icon(
              Icons.expand_more,
              size: 18,
              color: Colors.grey[600],
            ),
          ],
        ),
        iconColor: themeColor,
        collapsedIconColor: Colors.grey[600],
        children: [
          // Load danh mục từ Firestore
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Consumer<AppProvider>(
              builder: (context, appProvider, _) {
                // Lấy danh mục đã chọn từ AppProvider để hiển thị trạng thái active
                String selectedCategory = appProvider.selectedCategory.toLowerCase();
                
                // Stream builder để hiển thị danh mục từ Firestore
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
                        final categoryId = category.id.toLowerCase();
                        final categoryName = category.categoryName;
                        
                        return _buildNestedSubMenuItem(
                          context,
                          categoryName,  // Sử dụng categoryName thay vì categoryId
                          displayName: categoryName,
                          isActive: selectedCategory == categoryName  // So sánh với categoryName
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNestedSubMenuItem(BuildContext context, String title, {String? displayName, bool isActive = false}) {
    // Màu tím chủ đạo của ứng dụng khi active
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
              // Đặt danh mục được chọn vào Provider
              appProvider.setSelectedCategory(title);
              
              // Kiểm tra nếu đang ở chế độ xem chi tiết sản phẩm
              if (appProvider.currentProductId.isNotEmpty) {
                // Trước tiên reset ID sản phẩm để không còn ở chế độ xem chi tiết nữa
                appProvider.setCurrentProductId('');
                // Reset trạng thái xem
                appProvider.setCurrentScreen(2, isViewOnly: false);
              } else {
                // Giữ nguyên màn hình sản phẩm (index 2)
                appProvider.setCurrentScreen(2);
              }
              
              // Nếu đang ở mobile thì đóng drawer
              if (Responsive.isMobile(context)) {
                Navigator.pop(context);
              }
            },
            splashColor: Colors.transparent,
            highlightColor: themeColor.withOpacity(0.1),
            child: Row(
              children: [
                // Sử dụng SvgPicture.asset thay thế Container
                SvgPicture.asset(
                  'icons/icon_line.svg',
                  fit: BoxFit.cover,
                  // Thay đổi màu của SVG tùy theo trạng thái active
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
