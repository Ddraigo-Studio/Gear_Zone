import 'package:flutter/material.dart';
import 'package:gear_zone/controller/product_controller.dart';
import 'package:gear_zone/model/product.dart';
import 'package:provider/provider.dart';
import 'Items/product_row_item.dart';
import '../../../core/app_provider.dart';
import '../../../core/utils/responsive.dart';
import '../../../widgets/admin_widgets/breadcrumb.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    // Lắng nghe thay đổi từ Provider để cập nhật giao diện khi danh mục thay đổi
    final appProvider = Provider.of<AppProvider>(context);
    final selectedCategory = appProvider.selectedCategory;
    final productController = ProductController();    // Kiểm tra xem thiết bị hiện tại có phải là mobile hay không
    final isMobile = Responsive.isMobile(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          // Page title
          Row(
            children: [
              Text(
                selectedCategory.isEmpty
                    ? 'Danh sách sản phẩm'
                    : 'Sản phẩm - $selectedCategory',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (selectedCategory.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    // Reset danh mục đã chọn
                    appProvider.resetSelectedCategory();
                  },
                )
            ],
          ),
            // Breadcrumb
          Breadcrumb(
            items: [
              BreadcrumbBuilder.dashboard(context),
              BreadcrumbBuilder.products(context),
              if (selectedCategory.isNotEmpty)
                BreadcrumbBuilder.productCategory(context, selectedCategory),
            ],
          ),
          const SizedBox(height: 24),
          // Search and filters
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
            ),            child: Column(
              children: [
                // Use a responsive layout for search and filters
                isMobile
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
                                hintText: 'Tìm kiếm ID, tên sản phẩm',
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
                              // Add new product button
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: const Color(0xFF7C3AED),
                                  ),
                                  child: TextButton.icon(                                    onPressed: () {
                                      // Chuyển đến màn hình thêm sản phẩm
                                      final appProvider =
                                          Provider.of<AppProvider>(context, listen: false);
                                      appProvider.setCurrentScreen(AppScreen.productAdd);
                                    },
                                    icon: const Icon(Icons.add,
                                        color: Colors.white, size: 18),
                                    label: const Text(
                                      'Sản phẩm mới',
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
                                  hintText: 'Tìm kiếm ID, tên sản phẩm',
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
                            child: TextButton.icon(                              onPressed: () {
                                // Thay đổi màn hình hiện tại sang ProductAddScreen
                                final appProvider =
                                    Provider.of<AppProvider>(context, listen: false);
                                appProvider.setCurrentScreen(AppScreen.productAdd);
                              },
                              icon: const Icon(Icons.add,
                                  color: Colors.white, size: 18),
                              label: const Text(
                                'Sản phẩm mới',
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
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryTab(context, 'LapTop (50)',
                          isSelected: true),
                      _buildCategoryTab(context, 'Máy tính bàn (26)'),
                      _buildCategoryTab(context, 'Chuột (121)'),
                      _buildCategoryTab(context, 'Linh kiện (21)'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),                // Hiển thị dữ liệu sản phẩm từ Firestore
                StreamBuilder<List<ProductModel>>(
                  stream: selectedCategory.isEmpty
                      ? productController.getProducts()
                      : productController
                          .getProductsByCategory(selectedCategory),
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

                    final products = snapshot.data ?? [];
                    if (products.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const Icon(Icons.inventory_2_outlined,
                                  size: 48, color: Colors.grey),
                              const SizedBox(height: 16),
                              Text(
                                selectedCategory.isEmpty
                                    ? 'Không có sản phẩm nào'
                                    : 'Không có sản phẩm nào trong danh mục $selectedCategory',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );                    }
                    
                    // Kiểm tra thiết bị di động và hiển thị giao diện phù hợp
                    if (isMobile) {
                      // Mobile view - danh sách dọc các sản phẩm với khả năng mở rộng
                      return ProductListView();
                    }

                    // Desktop view - bảng sản phẩm
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
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(
                              color: Color(0xffF6F6F6),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Table(
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              columnWidths: const {
                                0: FixedColumnWidth(40), // Checkbox
                                1: FlexColumnWidth(3), // Sản phẩm
                                2: FlexColumnWidth(1), // Giá
                                3: FlexColumnWidth(1), // Số lượng
                                4: FlexColumnWidth(1), // Ngày nhập
                                5: FlexColumnWidth(1), // Trạng thái
                                6: FlexColumnWidth(1), // Hành động
                              },
                              children: [
                                TableRow(
                                  decoration: const BoxDecoration(
                                    color: Color(0xffF6F6F6),
                                  ),
                                  children: [                                    // Checkbox
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      alignment: Alignment.center,
                                      child: Checkbox(
                                        value: false,
                                        onChanged: (value) {},
                                      ),
                                    ),
                                    // Sản phẩm
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text(
                                        'Sản phẩm',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    // Giá
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text(
                                        'Giá',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),                                    // Số lượng
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text(
                                        'Số lượng',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                                    // Trạng thái
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text(
                                        'Trạng thái',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),                                    // Hành động
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                                ...List.generate(
                                  products.length,
                                  (index) => buildProductTableRow(
                                      context, index, products),
                                ),
                              ],
                            ),
                          ), // Pagination
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Consumer<AppProvider>(
                                    builder: (context, appProvider, _) {
                                  String category =
                                      appProvider.selectedCategory;
                                  String displayName =
                                      category; // Sử dụng trực tiếp tên danh mục

                                  String categoryInfo = category.isEmpty
                                      ? "Tất cả sản phẩm"
                                      : "Danh mục: $displayName";

                                  return Text(
                                    categoryInfo,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  );
                                }),
                                const Spacer(),
                                Text(
                                  'Trang trên',
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

  Widget _buildCategoryTab(BuildContext context, String title,
      {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Theme.of(context).primaryColor : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
