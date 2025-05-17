import 'package:flutter/material.dart';
import '../../../model/category.dart';
import '../../../core/app_provider.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../widgets/custom_image_view.dart';
import 'package:provider/provider.dart';
import '../../../controller/category_controller.dart';

/// Tạo TableRow dựa trên CategoryModel được cung cấp
/// 
/// [context] Context hiện tại để lấy Theme
/// [index] Chỉ số của danh mục trong danh sách
/// [categories] Danh sách các danh mục để hiển thị
TableRow buildCategoryTableRow(
    BuildContext context, int index, List<CategoryModel> categories) {
  final category = categories[index];
  final appProvider = Provider.of<AppProvider>(context, listen: false);
  final isMobile = Responsive.isMobile(context);

  return TableRow(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade200),
      ),
    ),
    children: [
      // Checkbox
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
          alignment: Alignment.center,
          child: SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: false,
              onChanged: (value) {},
            ),
          ),
        ),
      ),
      // Danh mục
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            children: [
              Container(
                width: isMobile ? 40 : 48,
                height: isMobile ? 40 : 48,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),                  child: CustomImageView(
                    key: ValueKey('category_list_${category.id}'),
                    imagePath: category.imagePath.isNotEmpty 
                        ? category.imagePath
                        : 'assets/images/img_logo.png',
                    height: isMobile ? 40 : 48,
                    width: isMobile ? 40 : 48,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.id,
                      style: TextStyle(
                        fontSize: isMobile ? 10 : 13,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.categoryName,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Ngày tạo
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          child: Text(
            formatDate(category.ceatedAt),
            style: TextStyle(
              fontSize: isMobile ? 12 : 13,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      // Hành động
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility_outlined, size: 20),
                onPressed: () {
                  // Xem chi tiết danh mục
                  appProvider.setCurrentCategoryId(category.id);
                  appProvider.setCurrentScreen(AppScreen.categoryDetail, isViewOnly: true);
                },
                color: Colors.grey,
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
                tooltip: 'Xem danh mục',
              ),
              SizedBox(width: isMobile ? 4 : 8),
              IconButton(
                onPressed: () {
                  // Sửa danh mục
                  appProvider.setCurrentCategoryId(category.id);
                  appProvider.setCurrentScreen(AppScreen.categoryDetail, isViewOnly: false);
                },
                icon: const Icon(Icons.edit_outlined, size: 20),
                color: Colors.grey,
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
                tooltip: 'Sửa danh mục',
              ),
              SizedBox(width: isMobile ? 4 : 8),
              IconButton(
                icon: const Icon(Icons.delete_outlined, size: 20),
                onPressed: () => deleteCategory(context, category.id),
                color: Colors.grey,
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
                tooltip: 'Xóa danh mục',
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

/// Xây dựng mục danh mục dạng mobile
/// 
/// [context] Context hiện tại để lấy Theme
/// [index] Chỉ số của danh mục trong danh sách
/// [category] Danh mục cần hiển thị
/// [isExpanded] Trạng thái mở rộng/thu gọn của item
/// [onExpandToggle] Callback khi người dùng bấm vào nút mở rộng/thu gọn
Widget buildMobileCategoryItem(
    BuildContext context, 
    int index, 
    CategoryModel category,
    {bool isExpanded = false, 
    Function(int)? onExpandToggle}) {
  
  final appProvider = Provider.of<AppProvider>(context, listen: false);

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade200),
      ),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
              ),            
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),                  child: CustomImageView(
                    key: ValueKey('category_mobile_${category.id}'),
                    imagePath: category.imagePath.isNotEmpty 
                        ? category.imagePath 
                        : 'assets/images/img_logo.png',
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.id,
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      category.categoryName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20,
                ),
                onPressed: () {
                  if (onExpandToggle != null) {
                    onExpandToggle(index);
                  }
                },
              ),
            ],
          ),
        ),
        if (isExpanded)
          Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.only(left: 76, bottom: 16, top: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        'Ngày tạo',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      formatDate(category.ceatedAt),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        'Hành động',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility_outlined, size: 20),
                          onPressed: () {
                            // Xem chi tiết danh mục
                            appProvider.setCurrentCategoryId(category.id);
                            appProvider.setCurrentScreen(AppScreen.categoryDetail, isViewOnly: true);
                          },
                          color: Colors.grey,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Xem danh mục',
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: () {
                            // Sửa danh mục
                            appProvider.setCurrentCategoryId(category.id);
                            appProvider.setCurrentScreen(AppScreen.categoryDetail, isViewOnly: false);
                          },
                          color: Colors.grey,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Sửa danh mục',
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete_outlined, size: 20),
                          onPressed: () => deleteCategory(context, category.id),
                          color: Colors.red.shade300,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

/// Phương thức xóa danh mục
Future<void> deleteCategory(BuildContext context, String categoryId) async {
  final CategoryController categoryController = CategoryController();
  final appProvider = Provider.of<AppProvider>(context, listen: false);
  
  // Hiển thị dialog xác nhận
  bool confirmed = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Xác nhận xóa'),
      content: const Text('Bạn có chắc chắn muốn xóa danh mục này? Lưu ý rằng các sản phẩm thuộc danh mục này có thể không hiển thị đúng.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Xóa', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  ) ?? false;

  if (!confirmed) return;

  // Hiển thị loading
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  try {
    bool success = await categoryController.deleteCategory(categoryId);
    
    // Đóng dialog loading
    Navigator.pop(context);
    
    // Hiển thị thông báo kết quả    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success 
          ? 'Xóa danh mục thành công' 
          : 'Xóa danh mục thất bại'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

      // Đảm bảo quay lại màn hình danh sách danh mục sau khi xóa
    if (success) {
      // Đặt cờ tải lại danh sách thành true trước khi chuyển màn hình
      appProvider.setReloadCategoryList(true);
      appProvider.setCurrentScreen(AppScreen.categoryList);
    }
  } catch (e) {
    // Đóng dialog loading
    Navigator.pop(context);
    
    // Hiển thị thông báo lỗi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lỗi khi xóa danh mục: $e'),
        backgroundColor: Colors.red,
      ),
    );  }
}

/// Xây dựng bảng danh mục hoàn chỉnh với danh sách danh mục tùy chỉnh
/// 
/// [context] Context hiện tại để lấy Theme
/// [categories] Danh sách các danh mục để hiển thị
Table buildCategoryTable(BuildContext context, {List<CategoryModel>? categories}) {
  final categoryList = categories ?? [];
  
  return Table(
    columnWidths: const {
      0: FixedColumnWidth(40), // Checkbox
      1: FlexColumnWidth(3), // Danh mục
      2: FlexColumnWidth(1), // Ngày tạo
      3: FlexColumnWidth(1), // Hành động
    },
    children: List.generate(
      categoryList.length,
      (index) => buildCategoryTableRow(context, index, categoryList),
    ),
  );
}

/// Widget hiển thị danh sách danh mục ở chế độ mobile
/// Quản lý trạng thái mở rộng nội bộ để tránh reload toàn bộ màn hình
class CategoryListView extends StatefulWidget {
  final List<CategoryModel> categories;

  const CategoryListView({
    super.key,
    required this.categories,
  });

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  // Theo dõi các mục đã được mở rộng
  final Set<int> _expandedItems = {};
  
  // Xử lý mở rộng/thu gọn cho từng mục
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
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) => buildMobileCategoryItem(
          context, 
          index, 
          widget.categories[index],
          isExpanded: _expandedItems.contains(index),
          onExpandToggle: _toggleExpanded,
        ),
      ),
    );
  }
}
