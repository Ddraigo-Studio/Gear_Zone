import 'package:flutter/material.dart';
import 'package:gear_zone/controller/product_controller.dart';
import 'package:gear_zone/model/product.dart';
import 'package:provider/provider.dart';
import '../../../core/app_provider.dart';
import '../../../core/utils/responsive.dart';
import '../../../widgets/admin_widgets/breadcrumb.dart';
import '../../../widgets/pagination_widget.dart';
import 'Items/product_row_item.dart' as product_items;

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductController _productController = ProductController();
  
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

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appProvider = Provider.of<AppProvider>(context);
    if (appProvider.reloadProductList) {
      _loadProducts();
      appProvider.setReloadProductList(false);
    }
  }

  // Load sản phẩm với phân trang
  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    
    try {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final selectedCategory = appProvider.selectedCategory;
      
      Map<String, dynamic> result;
      
      if (selectedCategory.isEmpty) {
        result = await _productController.getProductsPaginated(
          page: _currentPage, 
          limit: _itemsPerPage
        );
      } else {
        result = await _productController.getProductsByCategoryPaginated(
          selectedCategory,
          page: _currentPage, 
          limit: _itemsPerPage
        );
      }
      
      setState(() {
        _products = result['products'];
        _totalItems = result['total'];
        _totalPages = result['totalPages'];
        _currentPage = result['currentPage'];
        _hasNextPage = result['hasNextPage'];
        _hasPreviousPage = result['hasPreviousPage'];
        _isLoading = false;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Lỗi khi tải dữ liệu: $e';
      });
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
            '${product.price.toStringAsFixed(0)} ₫',
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
            product.quantity,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        
        // Cột ngày tạo
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            product.createdAt != null
                ? '${product.createdAt!.day}/${product.createdAt!.month}/${product.createdAt!.year}'
                : 'N/A',
            style: const TextStyle(fontSize: 14),
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
                onPressed: () {
                  // Chuyển đến màn hình chi tiết sản phẩm
                  final appProvider =
                      Provider.of<AppProvider>(context, listen: false);
                  appProvider.setCurrentProductId(product.id);
                  appProvider.setCurrentScreen(AppScreen.productDetail, isViewOnly: true);
                },
                icon: const Icon(Icons.visibility_outlined, size: 20),
                tooltip: 'Xem chi tiết',
              ),
              
              // Nút chỉnh sửa
              IconButton(
                onPressed: () {
                  // Chuyển đến màn hình chỉnh sửa sản phẩm
                  final appProvider =
                      Provider.of<AppProvider>(context, listen: false);
                  appProvider.setCurrentProductId(product.id);
                  appProvider.setCurrentScreen(AppScreen.productDetail);
                },
                icon: const Icon(Icons.edit_outlined, size: 20),
                tooltip: 'Chỉnh sửa',
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
                        )
                      : isMobile
                        // Mobile view - danh sách dọc các sản phẩm
                        ? ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _products.length,
                            separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) {
                              final product = _products[index];
                              return ListTile(
                                leading: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: product.imageUrl.isNotEmpty
                                      ? Image.network(product.imageUrl, fit: BoxFit.cover)
                                      : Container(
                                          color: Colors.grey.shade200,
                                          child: const Icon(Icons.image_not_supported),
                                        ),
                                ),
                                title: Text(
                                  product.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${product.price.toStringAsFixed(0)} ₫'),
                                    Text(
                                      'SL: ${product.quantity}',
                                      style: TextStyle(color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () {
                                        // Show action menu
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) => Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: const Icon(Icons.visibility_outlined),
                                                title: const Text('Xem chi tiết'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  appProvider.setCurrentProductId(product.id);
                                                  appProvider.setCurrentScreen(AppScreen.productDetail, isViewOnly: true);
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(Icons.edit_outlined),
                                                title: const Text('Chỉnh sửa'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  appProvider.setCurrentProductId(product.id);
                                                  appProvider.setCurrentScreen(AppScreen.productDetail);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
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
  }

  Widget _buildCategoryTab(BuildContext context, String title, {bool isSelected = false}) {
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
