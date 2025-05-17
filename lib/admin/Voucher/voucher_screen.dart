import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gear_zone/core/app_provider.dart';
import 'package:gear_zone/controller/voucher_controller.dart';
import 'package:gear_zone/model/voucher.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import 'package:gear_zone/widgets/pagination_widget.dart';
import 'Items/voucher_row_item.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  final VoucherController _voucherController = VoucherController();
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Pagination variables
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasNextPage = false;
  bool _hasPreviousPage = false;
  int _totalItems = 0;
  final int _itemsPerPage = 20;
  List<Voucher> _vouchers = [];
  bool _isLoading = true;
  String _errorMessage = '';
  

  @override
  void initState() {
    super.initState();
    _loadVouchers(); // Load vouchers with pagination on init
    
    // Kiểm tra xem có cần tải lại danh sách không
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      if (appProvider.reloadVoucherList) {
        appProvider.setReloadVoucherList(false);
        _loadVouchers(); // Reload vouchers when reloadVoucherList is true
      }
    });
  }
  
  // Load vouchers with pagination
  Future<void> _loadVouchers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      Map<String, dynamic> result;
      
      if (_searchQuery.isNotEmpty) {
        // TODO: Implement search with pagination if needed
        result = await _voucherController.getVouchersPaginated(
          page: _currentPage,
          limit: _itemsPerPage
        );
      } else {
        // Get all vouchers with pagination
        result = await _voucherController.getVouchersPaginated(
          page: _currentPage,
          limit: _itemsPerPage
        );
      }
      
      // Check if result contains valid data
      if (!result.containsKey('vouchers')) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Không nhận được dữ liệu hợp lệ từ server';
        });
        print('Lỗi: Kết quả trả về không hợp lệ');
        return;
      }
      
      final vouchersList = result['vouchers'] as List<Voucher>;
      print('Đã nhận được dữ liệu: ${vouchersList.length} phiếu giảm giá');
      
      // Update state with new data
      setState(() {
        _vouchers = result['vouchers'];
        _totalItems = result['totalItems'];
        _totalPages = result['totalPages'] > 0 ? result['totalPages'] : 1;
        _currentPage = result['currentPage'];
        _hasNextPage = result['hasNextPage'];
        _hasPreviousPage = result['hasPreviousPage'];
        _isLoading = false;
        _errorMessage = '';
      });
      
      // Debug log
      print('Đã tải ${_vouchers.length} phiếu giảm giá');
      print('Tổng số: $_totalItems, Trang: $_currentPage/$_totalPages');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Lỗi khi tải dữ liệu: $e';
      });
      print('Lỗi khi tải phiếu giảm giá: $e');
    }
  }

  // Handle page change
  void _handlePageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _loadVouchers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);    return Scaffold(
      backgroundColor: Colors.transparent,
      // Removed floating action button
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header and search bar
              _buildHeader(context),
              const SizedBox(height: 16),
              
              // Filters and actions
              _buildFilters(context),
              const SizedBox(height: 16),

              // Vouchers list
              _buildVouchersList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Danh sách phiếu giảm giá',
                style: TextStyle(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              StreamBuilder<int>(
                stream: Stream.fromFuture(_voucherController.getVouchersCount()),
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;
                  return Text(
                    '$count phiếu giảm giá',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: isMobile ? 12 : 14,
                    ),
                  );
                },
              ),
            ],
          ),
        ),        // Đã chuyển thanh tìm kiếm xuống cùng hàng với nút thêm voucher
      ],
    );
  }  Widget _buildFilters(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [        
        if (isMobile)
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm mã giảm giá...',
                      prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey),
                      prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _currentPage = 1; // Reset to first page when searching
                      });
                      _loadVouchers(); // Reload vouchers with new search query
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF7C3AED),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    appProvider.setCurrentScreen(AppScreen.voucherAdd);
                  },
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  label: const Text('Thêm', style: TextStyle(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        if (isMobile) const SizedBox(height: 16),
          if (!isMobile) Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [            // Thanh tìm kiếm (chỉ hiển thị ở desktop view)              
          Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm mã giảm giá...',
                    prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey),
                    prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _currentPage = 1; // Reset to first page when searching
                    });
                    _loadVouchers(); // Reload vouchers with new search query
                  },
                ),
              ),
            ),
            
            // Khoảng cách giữa thanh tìm kiếm và nút thêm
            const SizedBox(width: 16),
            // Add a "New Voucher" button
            Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFF7C3AED), // Purple color như trong CustomerScreen
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  appProvider.setCurrentScreen(AppScreen.voucherAdd);
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                label: const Text('Thêm mã giảm giá mới', style: TextStyle(fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }  
  Widget _buildVouchersList(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    // Show loading indicator or error message if needed
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          'Đã có lỗi xảy ra: $_errorMessage',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    // Áp dụng bộ lọc tìm kiếm
    final filteredVouchers = _searchQuery.isEmpty
        ? _vouchers
        : _vouchers.where((v) => 
            v.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            v.id.toLowerCase().contains(_searchQuery.toLowerCase())
          ).toList();

    if (filteredVouchers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Icon(Icons.card_giftcard, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Không có phiếu giảm giá nào',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // Mobile view với danh sách và phân trang
    if (isMobile) {
      return Column(
        children: [
          // Danh sách vouchers cho mobile view
          _buildMobileVouchersList(filteredVouchers, appProvider),
          
          // Phân trang cho mobile view
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                // Hiển thị thông tin số lượng
                Text(
                  'Tổng: $_totalItems phiếu giảm giá | Trang $_currentPage/$_totalPages',
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
      );
    }
    // Desktop view - bảng vouchers
    else {
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
            // Bảng voucher với danh sách từ voucher_row_item.dart
            _buildDesktopVouchersList(filteredVouchers, appProvider),
            
            // Phân trang
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'Tổng: $_totalItems phiếu giảm giá | Hiển thị ${filteredVouchers.length} mục',
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
  }
  Widget _buildMobileVouchersList(List<Voucher> vouchers, AppProvider appProvider) {
    final List<bool> expandedItems = List.generate(vouchers.length, (_) => false);

    return StatefulBuilder(
      builder: (context, setState) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vouchers.length,
          itemBuilder: (context, index) {
            return buildMobileVoucherItem(
              context, 
              index, 
              vouchers[index],
              isExpanded: expandedItems[index],
              onExpandToggle: (idx) {
                setState(() {
                  expandedItems[idx] = !expandedItems[idx];
                });
              },
            );
          },
        );
      }
    );
  }
  Widget _buildDesktopVouchersList(List<Voucher> vouchers, AppProvider appProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(0.5), // Checkbox
          1: FlexColumnWidth(2.5), // Mã giảm giá
          2: FlexColumnWidth(1.5), // Giá trị giảm giá
          3: FlexColumnWidth(1), // Lượt sử dụng
          4: FlexColumnWidth(1.5), // Ngày tạo
          5: FlexColumnWidth(1), // Trạng thái
          6: FlexColumnWidth(1.5), // Thao tác
        },
        children: [
          // Header row
          TableRow(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            children: [
              // Checkbox header
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  padding: const EdgeInsets.all(16),
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
              // Mã giảm giá header
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Mã giảm giá',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
              // Giá trị header
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Giá trị',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Lượt sử dụng header
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Lượt sử dụng',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Ngày tạo header
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Ngày tạo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Trạng thái header
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Trạng thái',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Thao tác header
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Thao tác',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          // Data rows using custom voucher row items
          for (int i = 0; i < vouchers.length; i++)
            buildVoucherTableRow(context, i, vouchers),
        ],
      ),
    );
  }
  // Using deleteVoucher function from voucher_row_item.dart instead
}
