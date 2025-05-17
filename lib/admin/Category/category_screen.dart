import 'package:flutter/material.dart';
import 'package:gear_zone/controller/category_controller.dart';
import 'package:gear_zone/model/category.dart';
import 'package:provider/provider.dart';
import 'Items/category_row_item.dart';
import '../../core/app_provider.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/admin_widgets/breadcrumb.dart';
import '../../widgets/pagination_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryController _categoryController = CategoryController();
  
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
  List<CategoryModel> _categories = [];
  bool _isLoading = true;
  String _errorMessage = '';
  @override
  void initState() {
    super.initState();
    _loadCategories();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appProvider = Provider.of<AppProvider>(context);
    if (appProvider.reloadCategoryList) {
      _loadCategories();
      appProvider.setReloadCategoryList(false);
    }
  }
  // Load danh mục với phân trang
  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      Map<String, dynamic> result;
      
      if (_searchQuery.isNotEmpty) {
        // Tìm kiếm danh mục
        result = await _categoryController.searchCategoriesPaginated(
          _searchQuery,
          page: _currentPage, 
          limit: _itemsPerPage
        );
      } else {
        // Lấy tất cả danh mục
        result = await _categoryController.getCategoriesPaginated(
          page: _currentPage, 
          limit: _itemsPerPage
        );
      }
      
      setState(() {
        _categories = result['categories'];
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
        _errorMessage = 'Lỗi khi tải danh mục: $e';
      });
    }
  }

  // Xử lý khi thay đổi trang
  void _handlePageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe thay đổi từ Provider để cập nhật giao diện
    final appProvider = Provider.of<AppProvider>(context);
    final isMobile = Responsive.isMobile(context);

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
          Breadcrumb(
            items: [
              BreadcrumbBuilder.dashboard(context),
              BreadcrumbBuilder.categories(context),
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
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
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
                                      appProvider.setCurrentScreen(AppScreen.categoryAdd);
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
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
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
                                appProvider.setCurrentScreen(AppScreen.categoryAdd);
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
                const SizedBox(height: 24),
                
                // Hiển thị dữ liệu danh mục
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
                    : _categories.isEmpty
                      ? Center(
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
                        )                      : isMobile
                        // Mobile view - danh sách dọc các danh mục với phân trang
                        ? Column(
                            children: [
                              // Hiển thị danh sách danh mục
                              CategoryListView(categories: _categories),
                              
                              // Phân trang cho mobile view
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Column(
                                  children: [
                                    // Hiển thị thông tin số lượng
                                    Text(
                                      'Tổng: $_totalItems danh mục | Trang $_currentPage/$_totalPages',
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
                        // Desktop view - bảng danh mục
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
                                  child: Column(
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
                                      buildCategoryTable(context, categories: _categories),
                                    ],
                                  ),
                                ),
                                
                                // Phân trang
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Tổng: $_totalItems danh mục | Hiển thị ${_categories.length} mục',
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
}
