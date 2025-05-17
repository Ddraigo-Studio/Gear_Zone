import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gear_zone/core/app_provider.dart';
import 'package:gear_zone/controller/order_controller.dart';
import 'package:gear_zone/model/order.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatefulWidget {
  final bool isViewOnly;
  
  const OrderDetailScreen({
    super.key,
    this.isViewOnly = true,
  });

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final OrderController _orderController = OrderController();
  bool _isLoading = false;
  OrderModel? _order;  String _selectedStatus = 'Chờ xử lý';

  final List<String> _statusOptions = [
    'Chờ xử lý',
    'Đã xác nhận',
    'Đang giao',
    'Đã nhận',
    'Trả hàng',
    'Đã hủy',
  ];

  @override
  void initState() {
    super.initState();
    _loadOrderData();
  }

  Future<void> _loadOrderData() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    if (appProvider.currentOrderId.isEmpty) {
      Navigator.pop(context); // Trở về nếu không có ID
      return;
    }
    
    setState(() {
      _isLoading = true;
    });

    try {
      final order = await _orderController.getOrderById(appProvider.currentOrderId);
      if (order != null) {
        setState(() {
          _order = order;
          _selectedStatus = order.status;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Lỗi khi tải dữ liệu: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateOrderStatus() async {
    if (_order == null) return;

    setState(() {
      _isLoading = true;
    });

    try {      await _orderController.updateOrderStatus(_order!.id, _selectedStatus);
      
      // Cập nhật trạng thái thanh toán nếu đã nhận hàng
      if (_selectedStatus == 'Đã nhận' && !_order!.isPaid) {
        await _orderController.updatePaymentStatus(_order!.id, true);
      }
      
      _showSuccessSnackBar('Đã cập nhật trạng thái đơn hàng.');

      // Tải lại dữ liệu
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      appProvider.setReloadOrderList(true);
      
      // Tải lại thông tin đơn hàng
      await _loadOrderData();

    } catch (e) {
      _showErrorSnackBar('Lỗi khi cập nhật: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _order == null
              ? const Center(child: Text('Không tìm thấy đơn hàng'))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header and breadcrumb
                      _buildHeader(context),
                      const SizedBox(height: 24),

                      // Order details
                      isMobile
                          ? _buildMobileOrderDetails()
                          : _buildDesktopOrderDetails(),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                appProvider.setCurrentScreen(AppScreen.orderList);
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            Text(
              'Chi tiết đơn hàng',
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (!isMobile && _order != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  appProvider.setCurrentScreen(AppScreen.orderList);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Danh sách đơn hàng',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: Colors.grey[700],
              ),
              const SizedBox(width: 8),
              Text(
                'Đơn hàng #${_order!.id}',
                style: TextStyle(
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildMobileOrderDetails() {
    if (_order == null) return Container();

    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status and actions card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trạng thái đơn hàng',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        value: _selectedStatus,
                        items: _statusOptions.map((String status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedStatus = newValue;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _updateOrderStatus,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Cập nhật'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Đã thanh toán: ${_order!.isPaid ? "Có" : "Chưa"}',
                  style: TextStyle(
                    color: _order!.isPaid ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  'Phương thức: ${_order!.paymentMethod}',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Order info
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thông tin đơn hàng',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Mã đơn hàng: #${_order!.id}'),
                const SizedBox(height: 8),
                Text('Ngày đặt: ${DateFormat('dd/MM/yyyy HH:mm').format(_order!.orderDate)}'),
                const SizedBox(height: 8),
                if (_order!.voucherId != null && _order!.voucherId!.isNotEmpty)
                  Text('Mã giảm giá: ${_order!.voucherId}'),
                if (_order!.note != null && _order!.note!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Ghi chú: ${_order!.note}'),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Customer info
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thông tin khách hàng',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Tên khách hàng: ${_order!.userName}'),
                const SizedBox(height: 8),
                Text('Số điện thoại: ${_order!.userPhone}'),
                const SizedBox(height: 8),
                Text('Địa chỉ giao hàng: ${_order!.shippingAddress}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Order items
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Danh sách sản phẩm',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _order!.items.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final item = _order!.items[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: item.productImage != null && item.productImage!.isNotEmpty
                          ? SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.network(
                                item.productImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
                                  );
                                },
                              ),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey[300],
                              child: Icon(Icons.photo, color: Colors.grey[600]),
                            ),
                      title: Text(
                        item.productName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.color != null && item.color!.isNotEmpty)
                            Text('Màu: ${item.color}', style: TextStyle(fontSize: 12)),
                          if (item.size != null && item.size!.isNotEmpty)
                            Text('Kích thước: ${item.size}', style: TextStyle(fontSize: 12)),
                          Text('Số lượng: ${item.quantity}', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      trailing: Text(
                        currencyFormat.format(item.price * item.quantity),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                Divider(thickness: 1),
                const SizedBox(height: 8),
                _buildOrderSummary(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopOrderDetails() {
    if (_order == null) return Container();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column - Order info and items
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông tin đơn hàng',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mã đơn hàng',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text('#${_order!.id}'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ngày đặt hàng',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(DateFormat('dd/MM/yyyy HH:mm').format(_order!.orderDate)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (_order!.voucherId != null && _order!.voucherId!.isNotEmpty || 
                          _order!.note != null && _order!.note!.isNotEmpty) 
                        const SizedBox(height: 16),
                      if (_order!.voucherId != null && _order!.voucherId!.isNotEmpty)
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mã giảm giá',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(_order!.voucherId!),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (_order!.note != null && _order!.note!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Ghi chú',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(_order!.note!),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Products list
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Danh sách sản phẩm',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Table header
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              'Sản phẩm',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Giá',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'SL',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Thành tiền',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 24),

                      // Products
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _order!.items.length,
                        separatorBuilder: (context, index) => Divider(height: 24),
                        itemBuilder: (context, index) {
                          final item = _order!.items[index];
                          final currencyFormat = NumberFormat.currency(
                            locale: 'vi_VN',
                            symbol: 'đ',
                            decimalDigits: 0,
                          );

                          return Row(
                            children: [
                              // Product info
                              Expanded(
                                flex: 5,
                                child: Row(
                                  children: [
                                    // Product image
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: item.productImage != null && item.productImage!.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(4),
                                              child: Image.network(
                                                item.productImage!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Icon(Icons.image_not_supported, color: Colors.grey);
                                                },
                                              ),
                                            )
                                          : Icon(Icons.photo, color: Colors.grey),
                                    ),
                                    const SizedBox(width: 16),
                                    // Product name and details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.productName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          if (item.color != null || item.size != null)
                                            Text(
                                              [
                                                if (item.color != null) 'Màu: ${item.color}',
                                                if (item.size != null) 'Size: ${item.size}',
                                              ].join(' - '),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Price
                              Expanded(
                                flex: 2,
                                child: Text(
                                  currencyFormat.format(item.price),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              // Quantity
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '${item.quantity}',
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              // Total price
                              Expanded(
                                flex: 2,
                                child: Text(
                                  currencyFormat.format(item.price * item.quantity),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Divider(height: 24),

                      // Order summary
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 300,
                          child: _buildOrderSummary(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Right column - Customer info and order status
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông tin khách hàng',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tên khách hàng',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(_order!.userName),
                          const SizedBox(height: 16),

                          Text(
                            'Số điện thoại',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(_order!.userPhone),
                          const SizedBox(height: 16),

                          Text(
                            'Địa chỉ giao hàng',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(_order!.shippingAddress),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Order status
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trạng thái đơn hàng',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trạng thái hiện tại',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            value: _selectedStatus,
                            items: _statusOptions.map((String status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedStatus = newValue;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _updateOrderStatus,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text('Cập nhật trạng thái'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Text(
                            'Thông tin thanh toán',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _order!.isPaid ? Colors.green[50] : Colors.red[50],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: _order!.isPaid ? Colors.green : Colors.red,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _order!.isPaid ? 'Đã thanh toán' : 'Chưa thanh toán',
                                  style: TextStyle(
                                    color: _order!.isPaid ? Colors.green : Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Phương thức: ${_order!.paymentMethod}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    if (_order == null) return Container();

    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tạm tính'),
            Text(currencyFormat.format(_order!.subtotal)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Phí vận chuyển'),
            Text(currencyFormat.format(_order!.shippingFee)),
          ],
        ),
        if (_order!.discount > 0) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Giảm giá'),
              Text('-${currencyFormat.format(_order!.discount)}'),
            ],
          ),
        ],
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tổng cộng',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              currencyFormat.format(_order!.total),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
