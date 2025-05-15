import 'package:flutter/material.dart';
import 'package:gear_zone/controller/category_controller.dart';
import 'package:gear_zone/model/category.dart';
import 'package:provider/provider.dart';
import 'Items/category_row_item.dart';
import '../../../core/app_provider.dart';
import '../../../core/utils/responsive.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // Theo dõi các mục đã được mở rộng
  Set<int> _expandedItems = {};

  // Xử lý mở rộng/thu gọn cho mục mobile
  void _toggleExpanded(int index) {
    setState(() {
      if (_expandedItems.contains(index)) {
        _expandedItems.remove(index);
      } else {
        _expandedItems.add(index);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Lắng nghe thay đổi từ Provider để cập nhật giao diện
    final appProvider = Provider.of<AppProvider>(context);
    final categoryController = CategoryController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page title
          const Text(
            'Danh mục sản phẩm',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Breadcrumb
          Row(
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Bảng điều khiển',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Danh mục sản phẩm',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),          // Search and filters
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Use a responsive layout for search and filters
                Responsive.isMobile(context)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Search field - full width on mobile
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.grey.shade50,
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Tìm kiếm tên danh mục',
                                prefixIcon: const Icon(Icons.search,
                                    color: Colors.grey, size: 20),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade400, fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Action buttons in a row
                          Row(
                            children: [
                              // Filter button
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Color(0xFF7C3AED)),
                                  ),
                                  child: TextButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.filter_list,
                                        color: Color(0xFF7C3AED), size: 18),
                                    label: const Text(
                                      'Lọc',
                                      style: TextStyle(
                                          color: Color(0xFF7C3AED), fontSize: 14),
                                    ),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Add new category button
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: const Color(0xFF7C3AED),
                                  ),
                                  child: TextButton.icon(
                                    onPressed: () {
                                      // Chuyển đến màn hình thêm danh mục
                                      appProvider.setCurrentScreen(5);
                                    },
                                    icon: const Icon(Icons.add,
                                        color: Colors.white, size: 18),
                                    label: const Text(
                                      'Danh mục mới',
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.grey.shade50,
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Tìm kiếm tên danh mục',
                                  prefixIcon: const Icon(Icons.search,
                                      color: Colors.grey, size: 20),
                                  border: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  hintStyle: TextStyle(
                                      color: Colors.grey.shade400, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFF7C3AED)),
                            ),
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.filter_list,
                                  color: Color(0xFF7C3AED), size: 18),
                              label: const Text(
                                'Lọc',
                                style:
                                    TextStyle(color: Color(0xFF7C3AED), fontSize: 14),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 32),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: const Color(0xFF7C3AED),
                            ),
                            child: TextButton.icon(
                              onPressed: () {
                                // Chuyển đến màn hình thêm danh mục
                                appProvider.setCurrentScreen(5);
                              },
                              icon: const Icon(Icons.add,
                                  color: Colors.white, size: 18),
                              label: const Text(
                                'Danh mục mới',
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 24),                // Hiển thị dữ liệu danh mục từ Firestore
                StreamBuilder<List<CategoryModel>>(
                  stream: categoryController.getCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('Lỗi: ${snapshot.error}'),
                        ),
                      );
                    }

                    final categories = snapshot.data ?? [];
                    if (categories.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const Icon(Icons.category_outlined,
                                  size: 48, color: Colors.grey),
                              const SizedBox(height: 16),
                              const Text(
                                'Không có danh mục nào',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    }                    // Khi ở chế độ mobile, sử dụng buildMobileCategoryItem thay vì bảng truyền thống
                    final isMobile = Responsive.isMobile(context);
                    
                    if (isMobile) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: List.generate(
                            categories.length,
                            (index) => buildMobileCategoryItem(
                              context, 
                              index, 
                              categories[index],
                              isExpanded: _expandedItems.contains(index),
                              onExpandToggle: _toggleExpanded,
                            ),
                          ),
                        ),
                      );
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(
                              color: Color(0xffF6F6F6),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),                            child: Column(
                              children: [
                                // Table header
                                Table(
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  columnWidths: const {
                                    0: FixedColumnWidth(40), // Checkbox
                                    1: FlexColumnWidth(3), // Danh mục
                                    2: FlexColumnWidth(1), // Ngày tạo
                                    3: FlexColumnWidth(1), // Hành động
                                  },
                                  children: [
                                    TableRow(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffF6F6F6),
                                      ),
                                      children: [
                                        // Checkbox
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          alignment: Alignment.center,
                                          child: Checkbox(
                                            value: false,
                                            onChanged: (value) {},
                                          ),
                                        ),
                                        // Danh mục
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Text(
                                            'Danh mục',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade700,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        // Ngày tạo
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Text(
                                            'Ngày tạo',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade700,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        // Hành động
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Text(
                                            'Hành động',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade700,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                
                                // Table body
                                buildCategoryTable(context, categories: categories),
                              ],
                            ),
                          ),                          // Pagination - Responsive layout
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Responsive.isMobile(context)
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Category count
                                      Text(
                                        'Tổng số: ${categories.length} danh mục',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Page controls
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Trang',
                                            style: TextStyle(
                                              fontSize: 14, 
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey.shade300),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text('1',
                                                    style: TextStyle(fontSize: 14)),
                                                const SizedBox(width: 4),
                                                const Icon(Icons.keyboard_arrow_down,
                                                    size: 16),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            icon: const Icon(Icons.keyboard_arrow_left),
                                            onPressed: () {},
                                            style: IconButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: const Size(32, 32),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                                side: BorderSide(
                                                    color: Colors.grey.shade300),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            icon: const Icon(Icons.keyboard_arrow_right),
                                            onPressed: () {},
                                            style: IconButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: const Size(32, 32),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                                side: BorderSide(
                                                    color: Colors.grey.shade300),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ) 
                                : Row(
                                    children: [
                                      Text(
                                        'Tổng số: ${categories.length} danh mục',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Trang',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text('1',
                                                style: TextStyle(fontSize: 14)),
                                            const SizedBox(width: 4),
                                            const Icon(Icons.keyboard_arrow_down,
                                                size: 16),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.keyboard_arrow_left),
                                        onPressed: () {},
                                        style: IconButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                            side: BorderSide(
                                                color: Colors.grey.shade300),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.keyboard_arrow_right),
                                        onPressed: () {},
                                        style: IconButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                            side: BorderSide(
                                                color: Colors.grey.shade300),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
