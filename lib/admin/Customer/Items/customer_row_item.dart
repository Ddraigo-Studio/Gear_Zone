import 'package:flutter/material.dart';
import '../../../model/user.dart';
import '../../../core/app_provider.dart';
import '../../../core/utils/responsive.dart';
import 'package:provider/provider.dart';
import '../../../controller/user_controller.dart';
import 'package:intl/intl.dart';

// Helper function để lấy địa chỉ mặc định của người dùng
String _getDefaultAddress(UserModel customer) {
  if (customer.addressList.isEmpty) {
    return 'Không có địa chỉ';
  }
  
  if (customer.defaultAddressId != null) {
    for (var address in customer.addressList) {
      if (address['id'] == customer.defaultAddressId) {
        return '${address['address']}, ${address['ward']}, ${address['district']}, ${address['province']}';
      }
    }
  }
  
  // Nếu không tìm thấy địa chỉ mặc định, trả về địa chỉ đầu tiên
  var firstAddress = customer.addressList.first;
  return '${firstAddress['address']}, ${firstAddress['ward']}, ${firstAddress['district']}, ${firstAddress['province']}';
}

TableRow buildCustomerTableRow(
    BuildContext context, int index, List<UserModel> customers) {
  final customer = customers[index % customers.length];
  final isBanned = customer.isBanned ?? false;
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
      // Thông tin khách hàng
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16, horizontal: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: isMobile ? 16 : 20,
                backgroundColor: Colors.grey[200],
                backgroundImage: customer.photoURL != null && customer.photoURL!.isNotEmpty 
                    ? NetworkImage(customer.photoURL!) 
                    : null,
                child: customer.photoURL == null || customer.photoURL!.isEmpty 
                    ? const Icon(Icons.person, color: Colors.grey) 
                    : null,
              ),
              SizedBox(width: isMobile ? 8 : 12),
              Expanded(
                child: Column(                  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      customer.email,
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 13,
                        color: isBanned ? Colors.grey : Colors.grey[800],
                        decoration: isBanned ? TextDecoration.lineThrough : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      customer.name,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 13,
                        fontWeight: FontWeight.w500,
                        color: isBanned ? Colors.grey : Colors.black,
                      ),
                      maxLines: isMobile ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Địa chỉ mặc định
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
          alignment: Alignment.centerLeft,
          child: Text(
            _getDefaultAddress(customer),
            style: TextStyle(
              fontSize: isMobile ? 11 : 13,
              color: isBanned ? Colors.grey : Colors.grey[800],
              decoration: isBanned ? TextDecoration.lineThrough : null,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ),
      // Số điện thoại
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
          alignment: Alignment.center,
          child: Text(
            customer.phoneNumber,
            style: TextStyle(
              fontSize: isMobile ? 11 : 13,
              color: isBanned ? Colors.grey : Colors.grey[800],
              decoration: isBanned ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ),
      // Ngày đăng ký
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateFormat('dd/MM/yyyy').format(customer.createdAt),
                style: TextStyle(fontSize: isMobile ? 11 : 13),
              ),
              Text(
                DateFormat('HH:mm:ss').format(customer.createdAt),
                style: TextStyle(fontSize: isMobile ? 10 : 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      // Trạng thái
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 12, 
              vertical: isMobile ? 4 : 6
            ),
            decoration: BoxDecoration(
              color: isBanned ? Colors.red[50] : Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isBanned ? Colors.red.shade300 : Colors.green.shade300,
                width: 1,
              ),
            ),
            child: Text(
              isBanned ? 'Đã cấm' : 'Hoạt động',
              style: TextStyle(
                fontSize: isMobile ? 10 : 12,
                fontWeight: FontWeight.w500,
                color: isBanned ? Colors.red.shade700 : Colors.green.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),      // Hành động
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 0 : 12),
          alignment: Alignment.center,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: isMobile ? 0 : 4,
            children: [
              IconButton(
                icon: Icon(Icons.visibility_outlined, size: isMobile ? 16 : 18),
                onPressed: () {
                  appProvider.setCurrentCustomerId(customer.uid);
                  appProvider.setCurrentScreen(AppScreen.customerDetail, isViewOnly: true);
                },
                color: Colors.grey,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 18,
                tooltip: 'Xem chi tiết',
              ),
              IconButton(
                icon: Icon(Icons.edit_outlined, size: isMobile ? 16 : 18),
                onPressed: () {
                  appProvider.setCurrentCustomerId(customer.uid);
                  appProvider.setCurrentScreen(AppScreen.customerDetail, isViewOnly: false);
                },
                color: Colors.grey,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact, 
                splashRadius: 18,
                tooltip: 'Chỉnh sửa',
              ),
              IconButton(
                icon: Icon(
                  isBanned ? Icons.check_circle_outline : Icons.block_outlined, 
                  size: isMobile ? 16 : 18
                ),
                onPressed: () => showBanUserDialog(context, customer),
                color: isBanned ? Colors.orange.shade300 : Colors.red.shade300,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 18,
                tooltip: isBanned ? 'Bỏ cấm' : 'Cấm người dùng',
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget buildMobileCustomerItem(
    BuildContext context, int index, UserModel customer,
    {bool isExpanded = false, Function(int)? onExpandToggle}) {
  bool isBanned = customer.isBanned ?? false;
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
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
              ),         
              const SizedBox(width: 8),   
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[200],
                backgroundImage: customer.photoURL != null && customer.photoURL!.isNotEmpty 
                    ? NetworkImage(customer.photoURL!) 
                    : null,
                child: customer.photoURL == null || customer.photoURL!.isEmpty 
                    ? const Icon(Icons.person, color: Colors.grey) 
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [                    
                    Text(
                      customer.email,
                      style: TextStyle(
                        fontSize: 13,
                        color: isBanned ? Colors.grey : Colors.grey[600],
                        decoration: isBanned ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      customer.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isBanned ? Colors.grey : Colors.black,
                      ),
                      maxLines: 1,
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
                      width: 100,
                      child: Text(
                        'ID',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        customer.uid,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).primaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Text(
                        'Số điện thoại',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      customer.phoneNumber,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Text(
                        'Ngày đăng ký',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy').format(customer.createdAt),
                          style: const TextStyle(fontSize: 13),
                        ),
                        Text(
                          DateFormat('HH:mm:ss').format(customer.createdAt),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Text(
                        'Địa chỉ mặc định',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _getDefaultAddress(customer),
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Text(
                        'Trạng thái',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isBanned ? Colors.red[50] : Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isBanned ? Colors.red.shade300 : Colors.green.shade300,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        isBanned ? 'Đã cấm' : 'Hoạt động',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isBanned ? Colors.red.shade700 : Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
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
                            appProvider.setCurrentCustomerId(customer.uid);
                            appProvider.setCurrentScreen(AppScreen.customerDetail, isViewOnly: true);
                          },
                          color: Colors.grey,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Xem chi tiết',
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: () {
                            appProvider.setCurrentCustomerId(customer.uid);
                            appProvider.setCurrentScreen(AppScreen.customerDetail, isViewOnly: false);
                          },
                          color: Colors.grey,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Chỉnh sửa',
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: Icon(
                            isBanned ? Icons.check_circle_outline : Icons.block_outlined,
                            size: 20,
                          ),
                          onPressed: () => showBanUserDialog(context, customer),
                          color: isBanned ? Colors.orange.shade300 : Colors.red.shade300,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                          tooltip: isBanned ? 'Bỏ cấm' : 'Cấm người dùng',
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

class CustomerListView extends StatefulWidget {
  final List<UserModel> customers;

  const CustomerListView({
    super.key,
    required this.customers,
  });

  @override
  State<CustomerListView> createState() => _CustomerListViewState();
}


class _CustomerListViewState extends State<CustomerListView> {
  List<UserModel> _customers = [];
  final String _errorMessage = '';
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _customers = widget.customers;
  }
  
  @override
  void didUpdateWidget(CustomerListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.customers != oldWidget.customers) {
      setState(() {
        _customers = widget.customers;
      });
    }
  }
  
  // Theo dõi các mục đã được mở rộng
  final Set<int> _expandedItems = {};

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
  
  // Xây dựng phần header cho chế độ xem di động
  Widget _buildMobileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF6F6F6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
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
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Thông tin khách hàng',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),
          
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    if (widget.customers != _customers) {
      _customers = widget.customers;
      _isLoading = false;
    }

    if (_isLoading) {
      return const Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Đang tải khách hàng...'),
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
              onPressed: () {},
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }
    
    if (_customers.isEmpty) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Không có khách hàng nào',
            textAlign: TextAlign.center,
          ),
        ],
      ));
    }

    // Hiển thị danh sách khách hàng theo chế độ xem (mobile/desktop)
    return isMobile
        ? Container(
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
            ),            child: Column(
              children: [
                _buildMobileHeader(), // Thêm header cho chế độ xem di động
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _customers.length,
                  itemBuilder: (context, index) => buildMobileCustomerItem(
                    context,
                    index,
                    _customers[index],
                    isExpanded: _expandedItems.contains(index),
                    onExpandToggle: _toggleExpanded,
                  ),
                ),
              ],
            ),
          )
        : buildCustomerTable(context, customers: _customers);
  }
}

// Hiển thị dialog xác nhận cấm/bỏ cấm người dùng
Future<void> showBanUserDialog(BuildContext context, UserModel customer) async {
  final isBanned = customer.isBanned ?? false;
  final UserController userController = UserController();
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(isBanned ? 'Bỏ cấm người dùng' : 'Cấm người dùng'),
      content: Text(
        isBanned
            ? 'Bạn có chắc chắn muốn bỏ cấm người dùng ${customer.name} không?'
            : 'Bạn có chắc chắn muốn cấm người dùng ${customer.name} không? Họ sẽ không thể đăng nhập vào hệ thống.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            try {
              await userController.banUser(customer.uid, !isBanned);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isBanned ? 'Đã bỏ cấm người dùng ${customer.name}' : 'Đã cấm người dùng ${customer.name}',
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: isBanned ? Colors.green : Colors.red,
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lỗi: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          child: Text(
            isBanned ? 'Bỏ cấm' : 'Cấm',
            style: TextStyle(
              color: isBanned ? Colors.orange : Colors.red,
            ),
          ),
        ),
      ],
    ),
  );
}

Table buildCustomerTable(BuildContext context, {List<UserModel>? customers}) {
  final customerList = customers ?? [];
  
  return Table(
    columnWidths: const {
      0: FixedColumnWidth(40), // Checkbox
      1: FlexColumnWidth(3), // Thông tin khách hàng (email/tên)
      2: FlexColumnWidth(3), // Địa chỉ mặc định
      3: FlexColumnWidth(1.5), // Số điện thoại
      4: FlexColumnWidth(1.5), // Ngày đăng ký
      5: FlexColumnWidth(1), // Trạng thái
      6: FlexColumnWidth(1), // Hành động
    },
    children: [
      // Header row
      TableRow(
        decoration: const BoxDecoration(
          color: Color(0xffF6F6F6),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
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
          // Thông tin khách hàng
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Thông tin khách hàng',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),
          // Địa chỉ mặc định
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Địa chỉ mặc định',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),
          // Số điện thoại
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Số điện thoại',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Ngày đăng ký
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Ngày đăng ký',
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
      // Data rows
      ...List.generate(
        customerList.length,
        (index) => buildCustomerTableRow(context, index, customerList),
      ),
    ],
  );
}
