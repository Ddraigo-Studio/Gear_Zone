import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gear_zone/core/app_provider.dart';
import 'package:gear_zone/controller/user_controller.dart';
import 'package:gear_zone/model/user.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import 'package:intl/intl.dart';
import 'package:gear_zone/widgets/pagination_widget.dart';
import 'package:gear_zone/widgets/admin_widgets/breadcrumb.dart';
import 'Items/customer_row_item.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final UserController _userController = UserController();
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Thông tin phân trang
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasNextPage = false;
  bool _hasPreviousPage = false;
  int _totalItems = 0;
  final int _itemsPerPage = 20;
  List<UserModel> _customers = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      if (appProvider.reloadCustomerList) {
        appProvider.setReloadCustomerList(false);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Load customers with pagination
  Future<void> _loadCustomers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      Map<String, dynamic> result;
      
      if (_searchQuery.isEmpty) {
        // Get all customers with pagination
        result = await _userController.getUsersPaginated(
          page: _currentPage, 
          limit: _itemsPerPage
        );
      } else {
        // Search customers with pagination
        result = await _userController.searchUsersPaginated(
          _searchQuery,
          page: _currentPage, 
          limit: _itemsPerPage
        );
      }
      
      // Check if result contains valid data
      if (!result.containsKey('users')) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Không nhận được dữ liệu hợp lệ từ server';
        });
        return;
      }
      
      // Update state with new data
      setState(() {
        _customers = result['users'];
        _totalItems = result['total'];
        _totalPages = result['totalPages'] > 0 ? result['totalPages'] : 1;
        _currentPage = result['currentPage'];
        _hasNextPage = result['hasNextPage'];
        _hasPreviousPage = result['hasPreviousPage'];
        _isLoading = false;
        _errorMessage = '';
      });
      
      // If no customers are returned but there is a total count > 0
      // and we're not on page 1, go back to page 1
      if (_customers.isEmpty && _totalItems > 0 && _currentPage > 1) {
        setState(() {
          _currentPage = 1;
        });
        _loadCustomers();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Lỗi khi tải dữ liệu: $e';
      });
    }
  }

  // Handle page change
  void _handlePageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _loadCustomers();
  }

  Widget _buildBreadcrumbs(BuildContext context) {
    return Breadcrumb(
      items: [
        BreadcrumbBuilder.dashboard(context),
        BreadcrumbBuilder.customers(context),
      ],
    );
  }

  Widget _buildPageTitleAndCount(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Text(
      'Danh sách khách hàng',
      style: TextStyle(
        fontSize: isMobile ? 20 : 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSearchFilterAddNewSection(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final primaryColor = Color(0xFF7C3AED); // Purple color

    Widget searchField = Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _searchController,          decoration: InputDecoration(
            hintText: 'Tìm kiếm khách hàng...',
            prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey),
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          ),
          onChanged: _onSearchQueryChanged,
      ),
    );

    Widget filterButton = Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton.icon(
        onPressed: () { /* TODO: Implement filter */ },
        icon: Icon(Icons.filter_list, size: 18, color: primaryColor),
        label: Text('Lọc', style: TextStyle(color: primaryColor, fontSize: 14)),
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: 16),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );

    // Nút "Khách hàng mới" đã được loại bỏ theo yêu cầu

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          searchField,
          const SizedBox(height: 12),
          filterButton, // Hiển thị nút lọc với chiều rộng đầy đủ
        ],
      );
    } else { // Desktop
      return Row(
        children: [
          Expanded(flex: 3, child: searchField),
          const SizedBox(width: 12),
          filterButton,
        ],
      );
    }
  }

  Widget _buildCustomersList(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _isLoading 
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              )
            : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Đã có lỗi xảy ra: $_errorMessage',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                )
              : _customers.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_off_outlined, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                              ? 'Không có người dùng nào'
                              : 'Không tìm thấy người dùng nào',
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                : CustomerListView(customers: _customers),
          
          // Phân trang
          if (!_isLoading && _customers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: isMobile
                ? Column(
                    children: [
                      // Hiển thị thông tin số lượng
                      Text(
                        'Tổng: $_totalItems người dùng | Trang $_currentPage/$_totalPages',
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
                  )
                : Row(
                    children: [
                      Text(
                        'Tổng: $_totalItems người dùng | Hiển thị ${_customers.length} mục',
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
    );
  }

  // When search query changes
  void _onSearchQueryChanged(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 1; // Reset to page 1 when search changes
    });
    _loadCustomers();
  }
  
  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPageTitleAndCount(context),
              const SizedBox(height: 24),
              _buildBreadcrumbs(context),
              const SizedBox(height: 16),
              _buildSearchFilterAddNewSection(context),
              const SizedBox(height: 24),
              _buildCustomersList(context),
            ],
          ),
        ),
      ),
    );
  }
}
