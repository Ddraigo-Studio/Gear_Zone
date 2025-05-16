import 'package:flutter/material.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import 'package:gear_zone/controller/customer_controller.dart';
import 'package:gear_zone/model/user.dart';
import '../../widgets/pagination_widget.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final CustomerController _customerController = CustomerController();
  
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
  }

  // Load khách hàng với phân trang
  Future<void> _loadCustomers() async {
    setState(() => _isLoading = true);
    
    try {
      final result = await _customerController.getCustomersPaginated(
        page: _currentPage, 
        limit: _itemsPerPage
      );
      
      setState(() {
        _customers = result['customers'];
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
        _errorMessage = 'Lỗi khi tải khách hàng: $e';
      });
    }
  }

  // Xử lý khi thay đổi trang
  void _handlePageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _loadCustomers();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page title
          const Text(
            'Khách hàng',
            style: TextStyle(
              fontSize: 24,
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
                    fontSize: 14,
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
                  'Khách hàng',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Filter and add customer
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
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Lọc'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm khách hàng'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Customers table
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
                // Hiển thị dữ liệu khách hàng
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
                    : _customers.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                const Icon(Icons.person_off_outlined,
                                    size: 48, color: Colors.grey),
                                const SizedBox(height: 16),
                                const Text(
                                  'Không có khách hàng nào',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            if (!isMobile)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      child: Checkbox(
                                        value: false,
                                        onChanged: (value) {},
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Tên khách hàng',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Liên hệ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Địa chỉ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        'Hành động',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            // Table rows - sử dụng dữ liệu thực từ Firestore
                            ...List.generate(
                              _customers.length,
                              (index) => isMobile
                                  ? _buildMobileCustomerItem(context, _customers[index])
                                  : _buildDesktopCustomerRow(context, _customers[index]),
                            ),
                          ],
                        ),
                
                // Phân trang
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        'Tổng: $_totalItems khách hàng | Hiển thị ${_customers.length} mục',
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
    );
  }
  
  // Custom widgets to display customer data
  Widget _buildDesktopCustomerRow(BuildContext context, UserModel customer) {
    final defaultAddress = customer.addressList.isNotEmpty 
        ? customer.addressList.firstWhere(
            (addr) => addr['id'] == customer.defaultAddressId,
            orElse: () => customer.addressList.first)
        : {'street': 'N/A', 'city': 'N/A', 'state': 'N/A', 'zipCode': 'N/A'};
    
    final addressText = '${defaultAddress['street']}, ${defaultAddress['city']}, ${defaultAddress['state']} ${defaultAddress['zipCode']}';
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Checkbox(
              value: false,
              onChanged: (value) {},
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.uid,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  customer.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.email,
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  customer.phoneNumber,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              addressText,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(
            width: 120, // Increased from 100 to 120 to accommodate the buttons
            child: Row(
              mainAxisSize: MainAxisSize.min, // Set to min to avoid expansion
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility_outlined, size: 18), // Reduced size
                  onPressed: () {},
                  color: Colors.grey,
                  padding: const EdgeInsets.all(4), // Reduced padding
                  constraints: const BoxConstraints(), // Remove default constraints
                  visualDensity: VisualDensity.compact, // More compact
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18), // Reduced size
                  onPressed: () {},
                  color: Colors.grey,
                  padding: const EdgeInsets.all(4), // Reduced padding
                  constraints: const BoxConstraints(), // Remove default constraints
                  visualDensity: VisualDensity.compact, // More compact
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outlined, size: 18), // Reduced size
                  onPressed: () {},
                  color: Colors.grey,
                  padding: const EdgeInsets.all(4), // Reduced padding
                  constraints: const BoxConstraints(), // Remove default constraints
                  visualDensity: VisualDensity.compact, // More compact
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCustomerItem(BuildContext context, UserModel customer) {
    final defaultAddress = customer.addressList.isNotEmpty 
        ? customer.addressList.firstWhere(
            (addr) => addr['id'] == customer.defaultAddressId,
            orElse: () => customer.addressList.first)
        : {'street': 'N/A', 'city': 'N/A', 'state': 'N/A', 'zipCode': 'N/A'};
    
    final addressText = '${defaultAddress['street']}, ${defaultAddress['city']}, ${defaultAddress['state']} ${defaultAddress['zipCode']}';
    
    // Thật ra nên dùng state để quản lý trạng thái mở rộng, hiện giờ để đơn giản cài mặc định đóng
    const bool isExpanded = false;
    
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
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.uid,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      customer.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                ),
                onPressed: () {
                  // Nên cập nhật state ở đây để mở rộng item
                },
              ),
            ],
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 48, bottom: 16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          'Liên hệ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.email,
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              customer.phoneNumber,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          'Địa chỉ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          addressText,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 80),
                      IconButton(
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        onPressed: () {},
                        color: Colors.grey,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        onPressed: () {},
                        color: Colors.grey,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outlined, size: 18),
                        onPressed: () {},
                        color: Colors.grey,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
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
}
