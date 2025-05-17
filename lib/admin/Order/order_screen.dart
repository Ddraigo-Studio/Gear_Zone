import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gear_zone/core/app_provider.dart';
import 'package:gear_zone/controller/order_controller.dart';
import 'package:gear_zone/model/order.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderController _orderController = OrderController();
  String _selectedStatus = '';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _statusOptions = [
    {'value': '', 'label': 'Tất cả', 'color': Colors.grey},
    {'value': 'Chờ xử lý', 'label': 'Chờ xử lý', 'color': Colors.orange},
    {'value': 'Đã xác nhận', 'label': 'Đã xác nhận', 'color': Colors.purple},
    {'value': 'Đang giao', 'label': 'Đang giao', 'color': Colors.blue},
    {'value': 'Đã nhận', 'label': 'Đã nhận', 'color': Colors.green},
    {'value': 'Trả hàng', 'label': 'Trả hàng', 'color': Colors.amber},
    {'value': 'Đã hủy', 'label': 'Đã hủy', 'color': Colors.red},
  ];

  @override
  void initState() {
    super.initState();
    // Kiểm tra xem có cần tải lại danh sách không
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      if (appProvider.reloadOrderList) {
        appProvider.setReloadOrderList(false);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
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

            // Orders list
            Expanded(
              child: _buildOrdersList(context),
            ),
          ],
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
                'Danh sách đơn hàng',
                style: TextStyle(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<int>(
                future: _orderController.getOrdersCount(),
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;
                  return Text(
                    '$count đơn hàng',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: isMobile ? 12 : 14,
                    ),
                  );
                },
              ),
            ],
          ),
        ),        // Đã chuyển thanh tìm kiếm xuống cùng hàng với bộ lọc
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    final isMobile = Responsive.isMobile(context);    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thanh tìm kiếm cho mobile
        if (isMobile)
          Container(
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
                hintText: 'Tìm kiếm đơn hàng...',
                prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey),
                prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        if (isMobile) const SizedBox(height: 16),
        
        // Thanh tìm kiếm desktop và bộ lọc trạng thái
        Row(
          children: [
            // Thanh tìm kiếm (chỉ hiển thị ở desktop view)            
            if (!isMobile) 
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
                      hintText: 'Tìm kiếm đơn hàng...',
                      prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey),
                      prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Status filters
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _statusOptions.map((status) {
            return FilterChip(
              label: Text(status['label']),
              selected: _selectedStatus == status['value'],
              onSelected: (selected) {
                setState(() {
                  _selectedStatus = selected ? status['value'] : '';
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: (status['color'] as Color).withOpacity(0.2),
              checkmarkColor: status['color'] as Color,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOrdersList(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    return StreamBuilder<List<OrderModel>>(
      stream: _selectedStatus.isEmpty
          ? _orderController.getOrders()
          : _orderController.getOrdersByStatus(_selectedStatus),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Đã có lỗi xảy ra: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        final orders = snapshot.data ?? [];
        
        // Áp dụng bộ lọc tìm kiếm
        final filteredOrders = _searchQuery.isEmpty
            ? orders
            : orders.where((order) => 
                order.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                order.userName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                order.userPhone.contains(_searchQuery)
              ).toList();

        if (filteredOrders.isEmpty) {
          return const Center(
            child: Text(
              'Không có đơn hàng nào',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return isMobile
            ? _buildMobileOrdersList(filteredOrders, appProvider)
            : _buildDesktopOrdersList(filteredOrders, appProvider);
      },
    );
  }

  Widget _buildMobileOrdersList(List<OrderModel> orders, AppProvider appProvider) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final statusColor = _getStatusColor(order.status);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              appProvider.setCurrentOrderId(order.id);
              appProvider.setCurrentScreen(AppScreen.orderDetail, isViewOnly: true);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '#${order.id.substring(0, 8)}...',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: statusColor, width: 1),
                        ),
                        child: Text(
                          order.status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Khách hàng: ${order.userName}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ngày đặt: ${DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Divider(height: 16, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${order.items.length} sản phẩm',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        currencyFormat.format(order.total),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Thanh toán: ${order.isPaid ? "Đã thanh toán" : "Chưa thanh toán"}',
                        style: TextStyle(
                          fontSize: 12,
                          color: order.isPaid ? Colors.green : Colors.red,
                        ),
                      ),
                      Text(
                        order.paymentMethod,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _buildDesktopOrdersList(List<OrderModel> orders, AppProvider appProvider) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );

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
      child: Column(
        children: [
          // Table header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Mã đơn hàng',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Khách hàng',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Số lượng',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Ngày đặt',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Tổng tiền',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Thanh toán',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Trạng thái',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: Text(
                    'Thao tác',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Table divider
          Divider(height: 1, color: Colors.grey[300]),

          // Table data
          Expanded(
            child: ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[300],
              ),
              itemBuilder: (context, index) {
                final order = orders[index];
                final statusColor = _getStatusColor(order.status);
                
                return InkWell(
                  onTap: () {
                    appProvider.setCurrentOrderId(order.id);
                    appProvider.setCurrentScreen(AppScreen.orderDetail, isViewOnly: true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Mã đơn hàng
                        Expanded(
                          flex: 2,
                          child: Text(
                            '#${order.id}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        // Khách hàng
                        Expanded(
                          flex: 2,
                          child: Text(order.userName),
                        ),
                        
                        // Số lượng
                        Expanded(
                          flex: 1,
                          child: Text('${order.items.length} SP'),
                        ),
                        
                        // Ngày đặt
                        Expanded(
                          flex: 2,
                          child: Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate),
                          ),
                        ),
                        
                        // Tổng tiền
                        Expanded(
                          flex: 2,
                          child: Text(
                            currencyFormat.format(order.total),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        // Thanh toán
                        Expanded(
                          flex: 1,
                          child: Text(
                            order.isPaid ? 'Đã thanh toán' : 'Chưa thanh toán',
                            style: TextStyle(
                              color: order.isPaid ? Colors.green : Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        
                        // Trạng thái
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: statusColor, width: 1),
                            ),
                            child: Text(
                              order.status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        
                        // Thao tác
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility, size: 18),
                                onPressed: () {
                                  appProvider.setCurrentOrderId(order.id);
                                  appProvider.setCurrentScreen(AppScreen.orderDetail, isViewOnly: true);
                                },
                                tooltip: 'Xem chi tiết',
                                splashRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Chờ xử lý':
        return Colors.orange;
      case 'Đã xác nhận':
        return Colors.purple;
      case 'Đang giao':
        return Colors.blue;
      case 'Đã nhận':
        return Colors.green;
      case 'Trả hàng':
        return Colors.amber;
      case 'Đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
