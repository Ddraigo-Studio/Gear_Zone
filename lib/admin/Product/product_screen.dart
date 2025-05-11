import 'package:flutter/material.dart';
import 'package:gear_zone/admin/Product/product_add_screen.dart';
import 'package:provider/provider.dart';
import 'Items/product_row_item.dart';
import '../../../core/app_provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {  @override
  Widget build(BuildContext context) {
    // Lắng nghe thay đổi từ Provider là bắt buộc để cập nhật giao diện khi danh mục thay đổi
    Provider.of<AppProvider>(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page title
          const Text(
            'Danh sách sản phẩm',
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
                child: const Text(
                  'Sản phẩm',
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
                  'Laptop',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
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
            ),
            child: Column(
              children: [
                Row(
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
                      ),                        child: TextButton.icon(
                        onPressed: () {
                          // Thay đổi màn hình hiện tại sang ProductAddScreen (index 4)
                          final appProvider = Provider.of<AppProvider>(context, listen: false);
                          appProvider.setCurrentScreen(4);
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
                const SizedBox(height: 24),
                Container(
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
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                              children: [
                                // Checkbox
                                Container(
                                  alignment: Alignment.center,
                                  child: Checkbox(
                                    value: false,
                                    onChanged: (value) {},
                                  ),
                                ),
                                // Sản phẩm
                                Text(
                                  'Sản phẩm',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                                // Giá
                                Text(
                                  'Giá',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                // Số lượng
                                Text(
                                  'Số lượng',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Ngày tạo',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                // Trạng thái
                                Text(
                                  'Trạng thái',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                // Hành động
                                Text(
                                  'Hành động',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),                      // Sử dụng ProductListView để hiển thị sản phẩm từ Firestore
                      const ProductListView(),                      // Pagination
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Consumer<AppProvider>(
                              builder: (context, appProvider, _) {                                String category = appProvider.selectedCategory;
                                String displayName = "";
                                
                                // Ánh xạ tên hiển thị thân thiện với người dùng
                                switch(category.toLowerCase()) {
                                  case 'laptop':
                                    displayName = "Laptop";
                                    break;
                                  case 'mouse':
                                    displayName = "Chuột";
                                    break;
                                  case 'monitor':
                                    displayName = "Màn hình";
                                    break;
                                  case 'pc':
                                    displayName = "PC";
                                    break;
                                  default:
                                    displayName = category;
                                }
                                
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
                              }
                            ),
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
                                border: Border.all(color: Colors.grey.shade300),
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
                                  side: BorderSide(color: Colors.grey.shade300),
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
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Products table
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
