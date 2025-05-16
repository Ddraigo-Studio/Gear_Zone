import 'package:flutter/material.dart';
import '../../../model/product.dart';
import '../../../core/app_provider.dart'; // Import AppProvider
import '../../../core/utils/responsive.dart'; // Import Responsive
import 'package:provider/provider.dart'; // Import Provider
import '../../../controller/product_controller.dart'; // Import ProductController
import '../../../widgets/custom_image_view.dart'; // Import CustomImageView
import 'package:intl/intl.dart'; // Import intl cho định dạng ngày giờ

TableRow buildProductTableRow(
    BuildContext context, int index, List<ProductModel> products) {
  final product = products[index % products.length];
  final isAvailable = product.status == 'Có sẵn' || product.inStock;
  final appProvider = Provider.of<AppProvider>(context, listen: false);
  final isMobile = Responsive.isMobile(context); // Added isMobile

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
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16), // Responsive padding
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
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16, horizontal: 8), // Responsive padding
          child: Row(
            children: [
              Container(
                width: isMobile ? 40 : 48, // Responsive width
                height: isMobile ? 40 : 48, // Responsive height
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CustomImageView(
                    key: ValueKey('product_list_${product.id}'),
                    imagePath: product.imageUrl.isNotEmpty
                        ? product.imageUrl
                        : 'assets/images/img_logo.png',
                    height: isMobile ? 40 : 48, // Responsive height
                    width: isMobile ? 40 : 48, // Responsive width
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: isMobile ? 8 : 16), // Responsive spacing
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                  children: [
                    Text(
                      product.id,
                      style: TextStyle(
                        fontSize: isMobile ? 10 : 13, // Responsive font size
                        color: Theme.of(context).primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis, // Prevent overflow
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 13, // Responsive font size
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: isMobile ? 2 : 1, // Allow more lines on mobile
                      overflow: TextOverflow.ellipsis, // Prevent overflow
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
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16), // Responsive padding
          alignment: Alignment.center,
          child: Text(
            ProductModel.formatPrice(product.price),
            style: TextStyle(
              fontSize: isMobile ? 9 : 13, // Responsive font size
            ),
          ),
        ),
      ),
      // Số lượng
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16), // Responsive padding
          alignment: Alignment.center,
          child: Text(
            product.quantity.toString(), // Ensure quantity is a string
            style: TextStyle(
              fontSize: isMobile ? 9 : 13, // Responsive font size
            ),
          ),
        ),
      ),
      // Ngày nhập
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16), // Responsive padding
          alignment: Alignment.center,
          child: product.createdAt != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy').format(product.createdAt!),
                    style: TextStyle(fontSize: isMobile ? 9 : 13),
                  ),
                  Text(
                    DateFormat('HH:mm:ss').format(product.createdAt!),
                    style: TextStyle(fontSize: isMobile ? 9 : 13, color: Colors.grey),
                  ),
                ],
              )
            : const Text('N/A'),
        ),
      ),
      // Trạng thái
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16), // Responsive padding
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12, vertical: isMobile ? 4 : 6), // Responsive padding
            decoration: BoxDecoration(
              color: isAvailable ? Colors.green.shade100 : Colors.red.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              product.status,
              style: TextStyle(
                fontSize: isMobile ? 10 : 13, // Responsive font size
                fontWeight: FontWeight.w500, 
                color: isAvailable ? Colors.green.shade700 : Colors.red.shade700, // Darker text for better contrast
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
          padding: EdgeInsets.symmetric(vertical: isMobile ? 0 : 16), // Reduced vertical padding on mobile for actions
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Use min to prevent overflow if space is tight
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.visibility_outlined, size: isMobile ? 18 : 20), // Responsive icon size
                onPressed: () {
                  // Lưu ID sản phẩm hiện tại vào Provider để có thể truy xuất trong màn hình chi tiết
                  appProvider.setCurrentProductId(product.id);
                  // Chuyển đến màn hình chi tiết sản phẩm ở chế độ xem
                  appProvider.setCurrentScreen(AppScreen.productDetail,
                      isViewOnly: true);
                },
                color: Colors.grey,
                padding: EdgeInsets.all(isMobile ? 2 : 4), // Responsive padding
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
                tooltip: 'Xem sản phẩm',
              ),
              SizedBox(width: isMobile ? 2 : 8), // Responsive spacing
              IconButton(
                icon: Icon(Icons.edit_outlined, size: isMobile ? 18 : 20), // Responsive icon size
                onPressed: () {
                  // Chuyển đến màn hình chi tiết sản phẩm ở chế độ sửa
                  appProvider.setCurrentScreen(AppScreen.productDetail,
                      isViewOnly: false);
                  // Lưu ID sản phẩm hiện tại vào Provider để có thể truy xuất trong màn hình chi tiết
                  appProvider.setCurrentProductId(product.id);
                },
                color: Colors.grey,
                padding: EdgeInsets.all(isMobile ? 2 : 4), // Responsive padding
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
                tooltip: 'Sửa sản phẩm',
              ),
              SizedBox(width: isMobile ? 2 : 8), // Responsive spacing
              IconButton(
                icon: Icon(Icons.delete_outlined, size: isMobile ? 18 : 20), // Responsive icon size
                onPressed: () => deleteProduct(context, product.id),
                color: Colors.red.shade300,
                padding: EdgeInsets.all(isMobile ? 2 : 4), // Responsive padding
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
                tooltip: 'Xóa sản phẩm', // Added tooltip
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget buildMobileProductItem(
    BuildContext context, int index, ProductModel product,
    {bool isExpanded = false, Function(int)? onExpandToggle}) {
  bool isAvailable = product.status == 'Có sẵn' || product.inStock;
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
                  borderRadius: BorderRadius.circular(4),
                  child: CustomImageView(
                    key: ValueKey('product_mobile_${product.id}'),
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
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 24,
              ),
            ],
          ),
        ),
        if (isExpanded)
          Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.only(left: 76, right: 16, bottom: 16, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      ProductModel.formatPrice(product.price),
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
                      product.quantity.toString(),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.createdAt != null) ...[
                          Text(
                            DateFormat('dd/MM/yyyy').format(product.createdAt!),
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            DateFormat('HH:mm:ss').format(product.createdAt!),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ] else
                          const Text('N/A', style: TextStyle(fontSize: 14)),
                      ],
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
                          fontWeight: FontWeight.w500,
                          color: isAvailable
                              ? Colors.green.shade700
                              : Colors.red.shade700,
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
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility_outlined, size: 20),
                          onPressed: () {
                            // Lưu ID sản phẩm hiện tại vào Provider để có thể truy xuất trong màn hình chi tiết
                            appProvider.setCurrentProductId(product.id);
                            // Chuyển đến màn hình chi tiết sản phẩm ở chế độ xem
                            appProvider.setCurrentScreen(AppScreen.productDetail,
                                isViewOnly: true);
                          },
                          color: Colors.grey,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Xem sản phẩm',
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: () {
                            // Chuyển đến màn hình chi tiết sản phẩm ở chế độ sửa
                            appProvider.setCurrentProductId(product.id);
                            appProvider.setCurrentScreen(AppScreen.productDetail,
                                isViewOnly: false);
                          },
                          color: Colors.grey,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Sửa sản phẩm',
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete_outlined, size: 20),
                          onPressed: () => deleteProduct(context, product.id),
                          color: Colors.red.shade300,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Xóa sản phẩm',
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

class ProductListView extends StatefulWidget {
  final List<ProductModel>? products; // Thêm tham số để truyền danh sách sản phẩm từ bên ngoài

  const ProductListView({
    super.key,
    this.products,
  });

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
    // Nếu đã truyền danh sách sản phẩm từ bên ngoài thì dùng nó, không cần load lại
    if (widget.products != null) {
      _products = widget.products!;
      _isLoading = false;
    } else {
      _loadProducts();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Chỉ load lại sản phẩm khi không có danh sách được truyền vào từ bên ngoài
    if (widget.products == null) {
      // Lấy danh mục được chọn từ Provider
      final appProvider = Provider.of<AppProvider>(context);
      // Load lại sản phẩm khi danh mục thay đổi
      _loadProducts(appProvider.selectedCategory);
    }
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
    // Lấy thông tin về danh mục từ Provider
    final appProvider = Provider.of<AppProvider>(context);
    final selectedCategory = appProvider.selectedCategory;
    final isMobile = Responsive.isMobile(context);

    // Nếu có danh sách sản phẩm được truyền vào từ bên ngoài, cập nhật lại
    if (widget.products != null && widget.products != _products) {
      _products = widget.products!;
      _isLoading = false;
    }

    if (_isLoading) {
      return const Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Đang tải sản phẩm...'),
        ],
      ));
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
          const SizedBox(height: 16),
          Text(
            selectedCategory.isEmpty
                ? 'Không có sản phẩm nào'
                : 'Không có sản phẩm nào trong danh mục ${selectedCategory}',
            textAlign: TextAlign.center,
          ),
          if (selectedCategory.isNotEmpty) const SizedBox(height: 16),
          if (selectedCategory.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                appProvider.resetSelectedCategory();
              },
              child: const Text('Hiển thị tất cả sản phẩm'),
            ),
        ],
      ));
    }

    // Hiển thị sản phẩm theo chế độ xem
    return isMobile
        ? Container(
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
              itemCount: _products.length,
              itemBuilder: (context, index) => buildMobileProductItem(
                context,
                index,
                _products[index],
                isExpanded: _expandedItems.contains(index),
                onExpandToggle: _toggleExpanded,
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
      ) ??
      false;

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
        content:
            Text(success ? 'Xóa sản phẩm thành công' : 'Xóa sản phẩm thất bại'),
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
