import 'package:flutter/material.dart';
import '../../../model/category.dart';
import '../../../core/app_provider.dart';
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
          padding: const EdgeInsets.symmetric(vertical: 16),
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
                width: 48,
                height: 48,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CustomImageView(
                    imagePath: category.imagePath.isNotEmpty 
                        ? category.imagePath
                        : 'assets/images/img_logo.png',
                    height: 48,
                    width: 48,
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
                        fontSize: 13,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.categoryName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
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
            category.ceatedAt.substring(0, 16),
            style: const TextStyle(
              fontSize: 13,
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
                icon: const Icon(Icons.visibility_outlined, size: 20),                onPressed: () {
                  // Xem chi tiết danh mục
                  appProvider.setCurrentCategoryId(category.id);
                  appProvider.setCurrentScreen(4, isViewOnly: true);
                },
                color: Colors.grey,
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
                tooltip: 'Xem danh mục',
              ),
              const SizedBox(width: 8),
              IconButton(                onPressed: () {
                  // Sửa danh mục
                  appProvider.setCurrentCategoryId(category.id);
                  appProvider.setCurrentScreen(4, isViewOnly: false);
                },
                icon: const Icon(Icons.edit_outlined, size: 20),
                color: Colors.grey,
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
                tooltip: 'Sửa danh mục',
              ),
              const SizedBox(width: 8),
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
      appProvider.setCurrentScreen(3);
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
    );
  }
}
