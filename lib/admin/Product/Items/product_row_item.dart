import 'package:flutter/material.dart';
import '../../../model/product.dart';
import '../../../core/app_provider.dart';  // Import AppProvider
import '../../../core/utils/responsive.dart';  // Import Responsive
import 'package:provider/provider.dart';   // Import Provider
import '../../../controller/product_controller.dart';  // Import ProductController
import '../../../widgets/custom_image_view.dart';  // Import CustomImageView



/// Tạo TableRow dựa trên ProductModel được cung cấp
/// 
/// [context] Context hiện tại để lấy Theme
/// [index] Chỉ số của sản phẩm trong danh sách
/// [products] Danh sách các sản phẩm để hiển thị
/// 
/// Quan trọng: Hàm này và buildMobileProductItem nên sử dụng cùng một danh sách products để đảm bảo
/// tính nhất quán giữa chế độ xem desktop và mobile.
TableRow buildProductTableRow(
    BuildContext context, int index, List<ProductModel> products) {
  final product = products[index % products.length];
  final isAvailable = product.status == 'Có sẵn' || product.inStock;
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
      // Sản phẩm
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            children: [              Container(
                width: 48,
                height: 48,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CustomImageView(
                    imagePath: product.imageUrl.isNotEmpty 
                        ? product.imageUrl
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
                      product.id,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
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
      // Giá
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Text(
            "${product.price.toStringAsFixed(0)}đ",
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ),
      ),
      // Số lượng
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Text(
            product.quantity,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ),
      ),
      // Ngày nhập
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          child: Text(
            product.createdAt?.toString().substring(0, 16) ?? 'N/A',
            style: const TextStyle(
              fontSize: 13, // Tăng kích thước font
              height: 1.4, // Thêm line height để dòng cách nhau
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      // Trạng thái
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16), // Tăng padding
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6), // Tăng padding của badge
            decoration: BoxDecoration(
              color: isAvailable ? Colors.green.shade100 : Colors.red.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              product.status,
              style: TextStyle(
                fontSize: 13, // Tăng kích thước font
                fontWeight: FontWeight.w500, // Làm đậm hơn
                color: isAvailable ? Colors.green : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      // Hành động
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16), // Tăng padding
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [              IconButton(
                icon: const Icon(Icons.visibility_outlined,
                    size: 20), // Tăng kích thước icon
                onPressed: () {
                  // Lưu ID sản phẩm hiện tại vào Provider để có thể truy xuất trong màn hình chi tiết
                  appProvider.setCurrentProductId(product.id);
                  // Chuyển đến màn hình chi tiết sản phẩm ở chế độ xem
                  appProvider.setCurrentScreen(2, isViewOnly: true); // Index 2 là ProductDetail
                },
                color: Colors.grey,
                padding: const EdgeInsets.all(4), // Thêm padding
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
                tooltip: 'Xem sản phẩm',
              ),
              const SizedBox(width: 8), // Thêm khoảng cách giữa các icon
              IconButton(                onPressed: () {
                  // Chuyển đến màn hình chi tiết sản phẩm ở chế độ sửa
                  appProvider.setCurrentScreen(2, isViewOnly: false); // Index 2 là ProductDetail
                  // Lưu ID sản phẩm hiện tại vào Provider để có thể truy xuất trong màn hình chi tiết
                  appProvider.setCurrentProductId(product.id);
                },
                icon: const Icon(Icons.edit_outlined,
                    size: 20), // Tăng kích thước icon
                color: Colors.grey,
                padding: const EdgeInsets.all(4), // Thêm padding
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
                tooltip: 'Sửa sản phẩm',
              ),
              const SizedBox(width: 8), // Thêm khoảng cách giữa các icon
              IconButton(
                icon: const Icon(Icons.delete_outlined,
                    size: 20), // Tăng kích thước icon
                onPressed: () => deleteProduct(context, product.id),
                color: Colors.grey,
                padding: const EdgeInsets.all(4), // Thêm padding
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

/// Xây dựng mục sản phẩm dạng mobile
/// 
/// [context] Context hiện tại để lấy Theme
/// [index] Chỉ số của sản phẩm trong danh sách
/// [product] Sản phẩm cần hiển thị
/// [isExpanded] Trạng thái mở rộng/thu gọn của item
/// [onExpandToggle] Callback khi người dùng bấm vào nút mở rộng/thu gọn
/// 
/// Quan trọng: Hàm này và buildProductTableRow nên sử dụng cùng một danh sách products để đảm bảo
/// tính nhất quán giữa chế độ xem desktop và mobile.
Widget buildMobileProductItem(
    BuildContext context, 
    int index, 
    ProductModel product,
    {bool isExpanded = false, 
    Function(int)? onExpandToggle}) {
  
  bool isAvailable = product.status == 'Có sẵn' || product.inStock;
  final appProvider = Provider.of<AppProvider>(context, listen: false);

  return Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade200),
      ),
    ),
    child: Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 24,
              child: Checkbox(
                value: false,
                onChanged: (value) {},
              ),
            ),            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CustomImageView(
                  imagePath: product.imageUrl.isNotEmpty 
                      ? product.imageUrl 
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
                    product.id,
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
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
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 76, bottom: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        'Giá',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      "${product.price.toStringAsFixed(0)}đ",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        'Số lượng',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      product.quantity,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        'Ngày nhập',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      product.createdAt?.toString().substring(0, 16) ?? 'N/A',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        'Trạng thái',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product.status,
                        style: TextStyle(
                          fontSize: 11,
                          color: isAvailable ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
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
                      children: [                        IconButton(
                          icon: const Icon(Icons.visibility_outlined, size: 20),
                          onPressed: () {
                            // Lưu ID sản phẩm hiện tại vào Provider để có thể truy xuất trong màn hình chi tiết
                            appProvider.setCurrentProductId(product.id);
                            // Chuyển đến màn hình chi tiết sản phẩm ở chế độ xem
                            appProvider.setCurrentScreen(2, isViewOnly: true); // Index 2 là ProductDetail
                          },
                          color: Colors.grey,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Xem sản phẩm',
                        ),
                        const SizedBox(width: 16),                        IconButton(                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: () {
                            // Chuyển đến màn hình chi tiết sản phẩm ở chế độ sửa
                            appProvider.setCurrentScreen(2, isViewOnly: false); // Index 2 là ProductDetail
                            // Lưu ID sản phẩm hiện tại vào Provider để có thể truy xuất trong màn hình chi tiết
                            appProvider.setCurrentProductId(product.id);
                          },
                          color: Colors.grey,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Sửa sản phẩm',
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete_outlined, size: 20),
                          onPressed: () => deleteProduct(context, product.id),
                          color: Colors.grey,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
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

/// Xây dựng bảng sản phẩm hoàn chỉnh với danh sách sản phẩm tùy chỉnh
/// 
/// [context] Context hiện tại để lấy Theme
/// [products] Danh sách các sản phẩm để hiển thị, nếu không cung cấp sẽ sử dụng dữ liệu mẫu
/// Widget hiển thị danh sách sản phẩm từ Firestore
class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final ProductController _productController = ProductController();
  bool _isLoading = true;
  List<ProductModel> _products = [];
  String _errorMessage = '';
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lấy danh mục được chọn từ Provider
    final appProvider = Provider.of<AppProvider>(context);
    
    // Load lại sản phẩm khi danh mục thay đổi
    _loadProducts(appProvider.selectedCategory);
  }

  void _loadProducts([String category = '']) {
    // Set loading state
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    // Stream sẽ được sử dụng để lấy dữ liệu
    Stream<List<ProductModel>> productsStream;
    
    // Nếu có danh mục được chọn thì lọc theo danh mục
    if (category.isNotEmpty) {
      productsStream = _productController.getProductsByCategory(category);
    } else {
      // Ngược lại, lấy tất cả sản phẩm
      productsStream = _productController.getProducts();
    }
    
    // Lắng nghe stream và cập nhật state
    productsStream.listen(
      (products) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      },
      onError: (error) {
        setState(() {
          _errorMessage = 'Lỗi khi tải dữ liệu: $error';
          _isLoading = false;
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    // Lấy thông tin về danh mục từ Provider
    final appProvider = Provider.of<AppProvider>(context);
    final selectedCategory = appProvider.selectedCategory;
    final isMobile = Responsive.isMobile(context);
    
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải sản phẩm...'),
          ],
        )
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadProducts(selectedCategory),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
            const SizedBox(height: 16),            Text(
              selectedCategory.isEmpty 
                  ? 'Không có sản phẩm nào' 
                  : 'Không có sản phẩm nào trong danh mục ${_getCategoryDisplayName(selectedCategory)}',
              textAlign: TextAlign.center,
            ),
            if (selectedCategory.isNotEmpty)
              const SizedBox(height: 16),
            if (selectedCategory.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  appProvider.resetSelectedCategory();
                },
                child: const Text('Hiển thị tất cả sản phẩm'),
              ),
          ],
        )
      );
    }

    // Hiển thị sản phẩm theo chế độ xem
    return isMobile 
        ? Column(
            children: List.generate(
              _products.length,
              (index) => buildMobileProductItem(
                context, 
                index, 
                _products[index],
                isExpanded: false,
                onExpandToggle: (index) {},
              ),
            ),
          )
        : buildProductTable(context, products: _products);
  }
}

/// Phương thức xóa sản phẩm
Future<void> deleteProduct(BuildContext context, String productId) async {
  final ProductController productController = ProductController();
  
  // Hiển thị dialog xác nhận
  bool confirmed = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Xác nhận xóa'),
      content: const Text('Bạn có chắc chắn muốn xóa sản phẩm này không?'),
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
    bool success = await productController.deleteProduct(productId);
    
    // Đóng dialog loading
    Navigator.pop(context);
    
    // Hiển thị thông báo kết quả
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success 
          ? 'Xóa sản phẩm thành công' 
          : 'Xóa sản phẩm thất bại'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  } catch (e) {
    // Đóng dialog loading
    Navigator.pop(context);
    
    // Hiển thị thông báo lỗi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lỗi khi xóa sản phẩm: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// Phương thức helper để hiển thị tên danh mục thân thiện với người dùng
String _getCategoryDisplayName(String category) {
  switch(category.toLowerCase()) {
    case 'Laptop':
      return "Laptop";
    case 'mouse':
      return "Chuột";
    case 'monitor':
      return "Màn hình";
    case 'pc':
      return "PC";
    default:
      return category.toUpperCase();
  }
}

Table buildProductTable(BuildContext context, {List<ProductModel>? products}) {
  final productList = products ?? [];
  
  return Table(
    columnWidths: const {
      0: FixedColumnWidth(40), // Checkbox
      1: FlexColumnWidth(3), // Sản phẩm
      2: FlexColumnWidth(1), // Giá
      3: FlexColumnWidth(1), // Số lượng
      4: FlexColumnWidth(1), // Ngày nhập
      5: FlexColumnWidth(1), // Trạng thái
      6: FlexColumnWidth(1), // Hành động
    },
    children: List.generate(
      productList.length,
      (index) => buildProductTableRow(context, index, productList),
    ),
  );
}
