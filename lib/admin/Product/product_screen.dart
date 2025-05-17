import 'package:flutter/material.dart';
import 'package:gear_zone/controller/product_controller.dart';
import 'package:gear_zone/model/product.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Added import

import '../../../core/app_provider.dart';
import '../../../core/utils/responsive.dart';
import '../../../widgets/admin_widgets/breadcrumb.dart';
import '../../../widgets/pagination_widget.dart';
import '../../controller/category_controller.dart';
import '../../model/category.dart';
import 'Items/product_row_item.dart' as product_items;

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductController _productController = ProductController();
  
  // Biến tìm kiếm
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  
  // Thông tin phân trang
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasNextPage = false;
  bool _hasPreviousPage = false;
  int _totalItems = 0;
  final int _itemsPerPage = 20;
  List<ProductModel> _products = [];
  bool _isLoading = true;
  String _errorMessage = '';
  
  // Phương thức xóa sản phẩm
  Future<void> _deleteProduct(String productId) async {
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
      bool success = await _productController.deleteProduct(productId);

      // Đóng dialog loading
      Navigator.pop(context);

      if (success) {
        // Tải lại danh sách sản phẩm sau khi xóa thành công
        _loadProducts();
        
        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xóa sản phẩm thành công'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Hiển thị thông báo thất bại
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xóa sản phẩm thất bại'),
            backgroundColor: Colors.red,
          ),
        );
      }
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

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }
  // Lưu trữ danh mục đã chọn để theo dõi thay đổi
  String _previousSelectedCategory = '';
    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appProvider = Provider.of<AppProvider>(context);
    
    // Kiểm tra nếu cần tải lại danh sách sản phẩm
    if (appProvider.reloadProductList) {
      _loadProducts();
      appProvider.setReloadProductList(false);
    }
    
    // Kiểm tra nếu danh mục được chọn thay đổi
    final currentSelectedCategory = appProvider.selectedCategory;
    if (_previousSelectedCategory != currentSelectedCategory) {
      print('Danh mục đã thay đổi: "$_previousSelectedCategory" -> "$currentSelectedCategory"');
      _previousSelectedCategory = currentSelectedCategory;
      // Reset về trang đầu tiên và tải lại sản phẩm theo danh mục mới
      setState(() => _currentPage = 1);
      _loadProducts();
    }
  }  // Load sản phẩm với phân trang
  Future<void> _loadProducts() async {
    // Đặt trạng thái đang tải
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final selectedCategory = appProvider.selectedCategory;
      
      Map<String, dynamic> result;
      
      if (_searchQuery.isNotEmpty) {
        // Tìm kiếm sản phẩm
        result = await _productController.searchProductsPaginated(
          _searchQuery,
          page: _currentPage, 
          limit: _itemsPerPage
        );
      } else if (selectedCategory.isEmpty) {
        // Lấy tất cả sản phẩm nếu không có danh mục được chọn
        result = await _productController.getProductsPaginated(
          page: _currentPage, 
          limit: _itemsPerPage
        );
      } else {
        // Lấy sản phẩm theo danh mục
        result = await _productController.getProductsByCategoryPaginated(
          selectedCategory,
          page: _currentPage, 
          limit: _itemsPerPage
        );      }
      
      // Kiểm tra xem kết quả có dữ liệu hay không
      if (!result.containsKey('products')) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Không nhận được dữ liệu hợp lệ từ server';
        });
        print('Lỗi: Kết quả trả về không hợp lệ');
        return;
      }
      
      final productsList = result['products'] as List<ProductModel>;
      print('Đã nhận được dữ liệu: ${productsList.length} sản phẩm');
      
      // Cập nhật state với dữ liệu mới
      setState(() {
        _products = result['products'];
        _totalItems = result['total'];
        _totalPages = result['totalPages'] > 0 ? result['totalPages'] : 1;
        _currentPage = result['currentPage'];
        _hasNextPage = result['hasNextPage'];
        _hasPreviousPage = result['hasPreviousPage'];
        _isLoading = false;
        _errorMessage = '';
      });
      
      // In log để debug
      print('Đã tải ${_products.length} sản phẩm');
      print('Tổng số: $_totalItems, Trang: $_currentPage/$_totalPages');
      
      if (_products.isEmpty && _totalItems > 0 && _currentPage > 1) {
        // Nếu không có sản phẩm nào được trả về nhưng có tổng số sản phẩm > 0
        // và đang không ở trang đầu tiên, có thể trang hiện tại không tồn tại
        // -> Quay lại trang đầu tiên
        print('Không có sản phẩm ở trang $_currentPage, quay lại trang đầu tiên');
        setState(() {
          _currentPage = 1;
        });
        _loadProducts();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Lỗi khi tải dữ liệu: $e';
      });
      print('Lỗi khi tải sản phẩm: $e');
    }
  }

  // Xử lý khi thay đổi trang
  void _handlePageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _loadProducts();
  }
  
  // Xây dựng TableRow cho sản phẩm
  TableRow buildProductTableRow(BuildContext context, int index, List<ProductModel> products) {
    final product = products[index];
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return TableRow(
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.white : const Color(0xffFAFAFA),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      children: [
        // Cột checkbox
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          alignment: Alignment.center,
          child: Checkbox(
            value: false,
            onChanged: (value) {},
          ),
        ),        // Cột thông tin sản phẩm
        product_items.buildProductTableRow(context, index, [product]).children[1],
        
        // Cột giá
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            currencyFormatter.format(product.price), // Updated price formatting
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        // Cột số lượng
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            product.quantity.toString(), // Ensure quantity is string
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        
        // Cột ngày tạo
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          alignment: Alignment.center, // Center the Column
          child: product.createdAt != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy').format(product.createdAt!),
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      DateFormat('HH:mm:ss').format(product.createdAt!),
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : const Text(
                  'N/A',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
        ),
        
        // Cột trạng thái
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: product.inStock
                  ? Colors.green.shade50
                  : Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              product.inStock ? 'Còn hàng' : 'Hết hàng',
              style: TextStyle(
                color: product.inStock ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
          // Cột hành động
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nút xem chi tiết
              IconButton(
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(),
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  // Chuyển đến màn hình chi tiết sản phẩm
                  final appProvider =
                      Provider.of<AppProvider>(context, listen: false);
                  appProvider.setCurrentProductId(product.id);
                  appProvider.setCurrentScreen(AppScreen.productDetail, isViewOnly: true);
                },
                icon: const Icon(Icons.visibility_outlined, size: 20, color: Colors.grey),
                tooltip: 'Xem chi tiết',
              ),
              
              // Nút chỉnh sửa
              IconButton(
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(),
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  // Chuyển đến màn hình chỉnh sửa sản phẩm
                  final appProvider =
                      Provider.of<AppProvider>(context, listen: false);
                  appProvider.setCurrentProductId(product.id);
                  appProvider.setCurrentScreen(AppScreen.productDetail);
                },
                icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.grey),
                tooltip: 'Chỉnh sửa',
              ),
              
              // Nút xóa sản phẩm
              IconButton(
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(),
                visualDensity: VisualDensity.compact,
                onPressed: () => _deleteProduct(product.id),
                icon: const Icon(Icons.delete_outlined, size: 20, color: Colors.red),
                tooltip: 'Xóa sản phẩm',
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe thay đổi từ Provider để cập nhật giao diện khi danh mục thay đổi
    final appProvider = Provider.of<AppProvider>(context);
    final selectedCategory = appProvider.selectedCategory;
    
    // Kiểm tra xem thiết bị hiện tại có phải là mobile hay không
    final isMobile = Responsive.isMobile(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page title
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
                    // Reset về trang đầu khi thay đổi danh mục
                    setState(() => _currentPage = 1);
                    _loadProducts();
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
            ),
            child: Column(
              children: [
                // Use a responsive layout for search and filters
                isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [                          // Search field - full width on mobile
                          Container(
                            height: 40,                            
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.white,
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                  _currentPage = 1; // Reset về trang 1 khi tìm kiếm
                                });
                                // Gọi lại phương thức tải sản phẩm với từ khóa tìm kiếm
                                _loadProducts();
                              },
                              decoration: InputDecoration(
                                hintText: 'Tìm kiếm ID, tên sản phẩm',
                                prefixIcon: const Icon(Icons.search,
                                    color: Colors.grey, size: 20),
                                prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade400, fontSize: 14),
                              ),
                              textAlignVertical: TextAlignVertical.center,
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
                                    border: Border.all(color: const Color(0xFF7C3AED)),
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
                                  child: TextButton.icon(
                                    onPressed: () {
                                      // Chuyển đến màn hình thêm sản phẩm
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
                              height: 40,                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.white,
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                    _currentPage = 1; // Reset về trang 1 khi tìm kiếm
                                  });
                                  // Gọi lại phương thức tải sản phẩm với từ khóa tìm kiếm
                                  _loadProducts();
                                },
                                decoration: InputDecoration(
                                  hintText: 'Tìm kiếm ID, tên sản phẩm',
                                  prefixIcon: const Icon(Icons.search,
                                      color: Colors.grey, size: 20),
                                  prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  hintStyle: TextStyle(
                                      color: Colors.grey.shade400, fontSize: 14),
                                ),
                                textAlignVertical: TextAlignVertical.center,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFF7C3AED)),
                            ),
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.filter_list,
                                  color: Color(0xFF7C3AED), size: 18),
                              label: const Text(
                                'Lọc',
                                style: TextStyle(color: Color(0xFF7C3AED), fontSize: 14),
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
                                // Thay đổi màn hình hiện tại sang ProductAddScreen
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
                const SizedBox(height: 16),                // Danh mục có thể cuộn ngang
                FutureBuilder<Map<String, int>>(
                  // Tính toán số lượng sản phẩm theo từng danh mục
                  future: _getCategoryCounts(),
                  builder: (context, snapshot) {
                    // Ẩn widget nếu đang tải hoặc có lỗi
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }
                    
                    final categoryCounts = snapshot.data!;
                    final appProvider = Provider.of<AppProvider>(context);
                    
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Tab tất cả sản phẩm
                          _buildCategoryTab(
                            context, 
                            'Tất cả (${_totalItems})', 
                            isSelected: appProvider.selectedCategory.isEmpty,
                            onTap: () {
                              appProvider.resetSelectedCategory();
                              setState(() => _currentPage = 1);
                              _loadProducts();
                            },
                          ),                          // Tạo tab cho mỗi danh mục
                          ...categoryCounts.entries.map((entry) {
                            final category = entry.key;
                            final count = entry.value;
                            return _buildCategoryTab(
                              context, 
                              '$category ($count)', 
                              isSelected: appProvider.selectedCategory == category,
                              onTap: () {
                                print('Chọn danh mục: $category');
                                // Sử dụng đúng tên danh mục (không phải ID) để lọc sản phẩm
                                appProvider.setSelectedCategory(category);
                                setState(() => _currentPage = 1);
                                _loadProducts();
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                
                // Hiển thị dữ liệu sản phẩm
                _isLoading 
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _errorMessage.isNotEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('Lỗi: $_errorMessage'),
                        ),
                      )                    
                      : _products.isEmpty
                      ? Center(
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
                        )                      : isMobile                        // Mobile view với ProductListView và phân trang
                        ? Column(
                            children: [
                              // Sử dụng ProductListView từ product_items cho UI đẹp hơn
                              // Truyền danh sách sản phẩm đã được phân trang
                              product_items.ProductListView(products: _products),
                              
                              // Phân trang cho mobile view
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Column(
                                  children: [
                                    // Hiển thị thông tin số lượng
                                    Text(
                                      'Tổng: $_totalItems sản phẩm | Trang $_currentPage/$_totalPages',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    
                                    // Widget phân trang cho mobile
                                    PaginationWidget(
                                      currentPage: _currentPage,
                                      totalPages: _totalPages,
                                      hasNextPage: _hasNextPage,
                                      hasPreviousPage: _hasPreviousPage,
                                      onPageChanged: _handlePageChanged,
                                      isMobile: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        // Desktop view - bảng sản phẩm
                        : Container(
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
                                        children: [
                                          // Checkbox
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
                                          ),
                                          // Số lượng
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
                                          // Ngày tạo
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
                                          ),
                                          // Hành động
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
                                        _products.length,
                                        (index) => buildProductTableRow(context, index, _products),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Phân trang
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Tổng: $_totalItems sản phẩm | Hiển thị ${_products.length} mục',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const Spacer(),
                                      
                                      // Widget phân trang
                                      PaginationWidget(
                                        currentPage: _currentPage,
                                        totalPages: _totalPages,
                                        hasNextPage: _hasNextPage,
                                        hasPreviousPage: _hasPreviousPage,
                                        onPageChanged: _handlePageChanged,
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
        ],
      ),
    );
  }  // Lấy số lượng sản phẩm theo từng danh mục
  Future<Map<String, int>> _getCategoryCounts() async {
    final Map<String, int> categoryCounts = {};
    
    try {
      // Lấy danh sách tất cả các danh mục từ CategoryController
      final categoryController = CategoryController();
      final categories = await categoryController.getCategories().first;
      
      // Nếu không có danh mục nào, sử dụng danh sách cố định
      if (categories.isEmpty) {
        final List<String> defaultCategories = [
          'Laptop', 'PC', 'Chuột', 'Bàn phím', 'Tai nghe', 'Màn hình', 'Laptop Gaming'
        ];
        
        // Đếm số lượng sản phẩm cho mỗi danh mục mặc định
        for (String category in defaultCategories) {
          final count = await _productController.countProductsByCategory(category);
          categoryCounts[category] = count;
        }
      } else {
        // Đếm số lượng sản phẩm cho mỗi danh mục từ Firestore
        for (CategoryModel category in categories) {
          final count = await _productController.countProductsByCategory(category.categoryName);
          categoryCounts[category.categoryName] = count;
        }
      }
      
      print('Đã tải số lượng sản phẩm theo danh mục: ${categoryCounts.length} danh mục');
      return categoryCounts;
    } catch (e) {
      print('Lỗi khi lấy số lượng sản phẩm theo danh mục: $e');
      return {};
    }
  }

  // Xây dựng tab danh mục
  Widget _buildCategoryTab(BuildContext context, String title, {bool isSelected = false, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: onTap,
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
