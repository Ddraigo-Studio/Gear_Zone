// filepath: d:\HOCTAP\CrossplatformMobileApp\DOANCK\Project\Gear_Zone\lib\admin\Voucher\voucher_detail_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gear_zone/core/app_provider.dart';
import 'package:gear_zone/controller/voucher_controller.dart';
import 'package:gear_zone/model/voucher.dart';
import 'package:intl/intl.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import '../../../widgets/admin_widgets/breadcrumb.dart';
import 'Items/voucher_row_item.dart';

class VoucherDetailScreen extends StatefulWidget {
  final bool isViewOnly;

  const VoucherDetailScreen({
    super.key,
    this.isViewOnly = true,
  });

  @override
  _VoucherDetailScreenState createState() => _VoucherDetailScreenState();
}

class _VoucherDetailScreenState extends State<VoucherDetailScreen> {
  final VoucherController _voucherController = VoucherController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isNew = false;

  // Form controllers
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _maxUsageCountController =
      TextEditingController();

  // Mức giảm giá cố định được cho phép
  final List<double> _allowedDiscountAmounts = [10000, 20000, 50000, 100000];
  double _selectedDiscountAmount = 10000;

  // Chi tiết voucher
  Voucher? _currentVoucher;
  List<Map<String, dynamic>> _appliedOrders = [];

  @override
  void initState() {
    super.initState();
    _loadVoucherData();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _maxUsageCountController.dispose();
    super.dispose();
  }

  Future<void> _loadVoucherData() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    if (appProvider.currentVoucherId.isEmpty) {
      // Đây là trường hợp thêm mới
      setState(() {
        _isNew = true;
        _maxUsageCountController.text = '10'; // Giá trị mặc định
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });    try {
      final voucher =
          await _voucherController.getVoucherById(appProvider.currentVoucherId);
      if (voucher != null) {
        // Ensure the discount amount is in the allowed list
        double validDiscountAmount = voucher.discountAmount;
        if (!_allowedDiscountAmounts.contains(validDiscountAmount) && 
            _allowedDiscountAmounts.isNotEmpty) {
          validDiscountAmount = _allowedDiscountAmounts.first;
        }
        
        setState(() {
          _currentVoucher = voucher;
          _codeController.text = voucher.code;
          _selectedDiscountAmount = validDiscountAmount;
          _maxUsageCountController.text = voucher.maxUsageCount.toString();
        });

        // Nếu đang xem chi tiết, lấy thêm thông tin các đơn hàng đã áp dụng
        if (widget.isViewOnly && voucher.appliedOrderIds.isNotEmpty) {
          final orders =
              await _voucherController.getOrderDetailsForVoucher(voucher.id);
          if (mounted) {
            setState(() {
              _appliedOrders = orders;
            });
          }
        }
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

  Future<void> _saveVoucher() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final appProvider = Provider.of<AppProvider>(context, listen: false);

      final String code = _codeController.text.trim().toUpperCase();
      final double discountAmount = _selectedDiscountAmount;
      final int maxUsageCount =
          int.tryParse(_maxUsageCountController.text) ?? 10;

      if (_isNew) {
        // Kiểm tra xem mã voucher đã tồn tại chưa
        bool codeExists = await _voucherController.isCodeExist(code);
        if (codeExists) {
          _showErrorSnackBar('Mã voucher đã tồn tại. Vui lòng chọn mã khác.');
          setState(() {
            _isLoading = false;
          });
          return;
        }

        final id = await _voucherController.createNewVoucher(
            code, discountAmount, maxUsageCount);
        appProvider.setCurrentVoucherId(id);
        appProvider.setReloadVoucherList(true);
        _showSuccessSnackBar('Đã tạo phiếu giảm giá mới.');
      } else {
        // Tạo voucher từ dữ liệu đã cập nhật và giữ nguyên các thông tin khác
        final updatedVoucher = _currentVoucher!.copyWith(
          code: code,
          discountAmount: discountAmount,
          maxUsageCount: maxUsageCount,
        );

        await _voucherController.updateVoucher(updatedVoucher);
        appProvider.setReloadVoucherList(true);
        _showSuccessSnackBar('Đã cập nhật phiếu giảm giá.');
      }

      // Trở về chế độ xem sau khi lưu
      if (!widget.isViewOnly) {
        appProvider.setCurrentScreen(AppScreen.voucherDetail, isViewOnly: true);
      }
    } catch (e) {
      _showErrorSnackBar('Lỗi khi lưu: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              appProvider.setCurrentScreen(AppScreen.voucherList);
            },
          ),
          title: Breadcrumb(
            items: [
              BreadcrumbItem(
                  title: 'Phiếu giảm giá',
                  onTap: () {
                    appProvider.setCurrentScreen(AppScreen.voucherList);
                  }),
              BreadcrumbItem(
                  title: _isNew
                      ? 'Tạo mới'
                      : (_currentVoucher?.code ?? 'Chi tiết')),
            ],
          ),
          actions: [
            if (!_isNew && !widget.isViewOnly)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _showDeleteConfirmation(context),
                tooltip: 'Xóa phiếu giảm giá',
              ),
            if (widget.isViewOnly && !_isNew)
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  appProvider.setCurrentScreen(AppScreen.voucherDetail,
                      isViewOnly: false);
                },
                tooltip: 'Chỉnh sửa',
              ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form chỉnh sửa
                    _buildVoucherForm(context),

                    // Chi tiết sử dụng (nếu đang xem)
                    if (widget.isViewOnly && !_isNew && _currentVoucher != null)
                      _buildVoucherUsageDetails(context),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: widget.isViewOnly
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, -2),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      if (_isNew) {
                        appProvider.setCurrentScreen(AppScreen.voucherList);
                      } else {
                        appProvider.setCurrentScreen(AppScreen.voucherDetail,
                            isViewOnly: true);
                      }
                    },
                    child: const Text('Hủy'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveVoucher,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_isNew ? 'Tạo' : 'Lưu thay đổi'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildVoucherForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isNew ? 'Tạo phiếu giảm giá mới' : 'Chi tiết phiếu giảm giá',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Mã giảm giá
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Mã giảm giá',
                  hintText: 'Nhập mã (5 ký tự)',
                  border: OutlineInputBorder(),
                ),
                enabled: _isNew, // Chỉ cho phép nhập khi tạo mới
                readOnly: !_isNew,
                maxLength: 5,
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã giảm giá';
                  }
                  if (value.length != 5) {
                    return 'Mã giảm giá phải có 5 ký tự';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                    return 'Mã giảm giá chỉ được chứa chữ cái và số';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),              // Giá trị giảm giá
              Builder(
                builder: (context) {
                  // Validate that the selected amount is in the list, otherwise use the first one
                  if (!_allowedDiscountAmounts.contains(_selectedDiscountAmount) && 
                      _allowedDiscountAmounts.isNotEmpty) {
                    _selectedDiscountAmount = _allowedDiscountAmounts.first;
                  }
                  
                  return DropdownButtonFormField<double>(
                    value: _selectedDiscountAmount,
                    decoration: const InputDecoration(
                      labelText: 'Giá trị giảm giá',
                      border: OutlineInputBorder(),
                    ),
                    items: _allowedDiscountAmounts.map((amount) {
                      final formatted = NumberFormat.currency(
                              locale: 'vi_VN', symbol: 'đ', decimalDigits: 0)
                          .format(amount);
                      return DropdownMenuItem<double>(
                        value: amount,
                        child: Text(formatted),
                      );
                    }).toList(),
                    onChanged: widget.isViewOnly
                        ? null
                        : (value) {
                            if (value != null) {
                              setState(() {
                                _selectedDiscountAmount = value;
                              });
                            }
                          },
                    validator: (value) {
                      if (value == null) {
                        return 'Vui lòng chọn giá trị giảm giá';
                      }
                      return null;
                    },
                  );
                }
              ),
              const SizedBox(height: 20),

              // Số lượt sử dụng tối đa
              TextFormField(
                controller: _maxUsageCountController,
                decoration: const InputDecoration(
                  labelText: 'Số lần sử dụng tối đa',
                  hintText: 'Nhập số lần sử dụng tối đa',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                enabled: !widget.isViewOnly,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số lần sử dụng tối đa';
                  }
                  final count = int.tryParse(value);
                  if (count == null || count < 1) {
                    return 'Số lần sử dụng phải lớn hơn 0';
                  }
                  return null;
                },
              ),

              // Hiển thị thêm thông tin khi xem chi tiết
              if (widget.isViewOnly && _currentVoucher != null) ...[
                const SizedBox(height: 20),
                _buildInfoItem(
                    'Ngày tạo',
                    DateFormat('dd/MM/yyyy HH:mm')
                        .format(_currentVoucher!.createdAt)),
                _buildInfoItem('Đã sử dụng',
                    '${_currentVoucher!.currentUsageCount}/${_currentVoucher!.maxUsageCount} lần'),
                _buildInfoItem(
                    'Còn lại', '${_currentVoucher!.remainingUsageCount} lần'),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label + ':',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherUsageDetails(BuildContext context) {
    if (_currentVoucher == null) {
      return const SizedBox();
    }
    
    final isMobile = Responsive.isMobile(context);

    return Card(
      margin: const EdgeInsets.only(top: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin sử dụng mã giảm giá',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Usage Statistics Overview
            _buildUsageStatistics(),
            
            const SizedBox(height: 24),
            
            // Tabs for detailed information
            DefaultTabController(
              length: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TabBar(
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: 'Đơn hàng đã áp dụng'),
                      Tab(text: 'Thống kê người dùng'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: isMobile ? 400 : 500,
                    child: TabBarView(
                      children: [
                        // Orders Tab
                        _currentVoucher!.appliedOrderIds.isEmpty
                          ? const Center(child: Text('Chưa có đơn hàng nào sử dụng mã giảm giá này.'))
                          : _appliedOrders.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : _buildOrdersTable(context),
                        
                        // Users Tab
                        _buildUserUsageTable(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hiển thị thống kê tổng quát về sử dụng mã giảm giá
  Widget _buildUsageStatistics() {
    final isMobile = Responsive.isMobile(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.confirmation_number_outlined,
                label: 'Tổng lượt sử dụng',
                value: '${_currentVoucher!.currentUsageCount}/${_currentVoucher!.maxUsageCount}',
                color: Colors.blue,
              ),
              _buildStatItem(
                icon: Icons.person_outline,
                label: 'Số người dùng',
                value: '${_currentVoucher!.userUsageCounts.length}',
                color: Colors.green,
              ),
              if (!isMobile)
                _buildStatItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Ngày tạo',
                  value: DateFormat('dd/MM/yyyy').format(_currentVoucher!.createdAt),
                  color: Colors.purple,
                ),
            ],
          ),
          if (isMobile)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: _buildStatItem(
                icon: Icons.calendar_today_outlined,
                label: 'Ngày tạo',
                value: DateFormat('dd/MM/yyyy').format(_currentVoucher!.createdAt),
                color: Colors.purple,
              ),
            ),
            
          const SizedBox(height: 16),
          
          // Status and toggle button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _currentVoucher!.isActive ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _currentVoucher!.isActive ? 'Đang kích hoạt' : 'Đã khóa',
                  style: TextStyle(
                    color: _currentVoucher!.isActive ? Colors.green.shade800 : Colors.red.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              TextButton.icon(
                onPressed: _toggleVoucherStatus,
                icon: Icon(_currentVoucher!.isActive ? Icons.block : Icons.check_circle_outline),
                label: Text(_currentVoucher!.isActive ? 'Khóa mã' : 'Kích hoạt mã'),
                style: TextButton.styleFrom(
                  foregroundColor: _currentVoucher!.isActive ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Cột thông kê đơn lẻ
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  // Hiển thị thông tin sử dụng theo người dùng
  Widget _buildUserUsageTable(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _voucherController.getVoucherUserUsageDetails(_currentVoucher!.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }
        
        final data = snapshot.data!;
        
        if (data['totalUsers'] == 0) {
          return const Center(child: Text('Chưa có dữ liệu sử dụng từ người dùng'));
        }
        
        final userDetails = data['userDetails'] as List<dynamic>;
        
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('ID người dùng')),
              DataColumn(label: Text('Tên')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Số lượt sử dụng')),
              DataColumn(label: Text('Tổng giá trị')),
            ],
            rows: userDetails.map<DataRow>((user) {
              final userData = user as Map<String, dynamic>;
              return DataRow(
                cells: [
                  DataCell(Text(userData['userId'] ?? 'N/A', 
                    style: const TextStyle(fontSize: 12))),
                  DataCell(Text(userData['userName'] ?? 'N/A')),
                  DataCell(Text(userData['email'] ?? 'N/A', 
                    style: const TextStyle(fontSize: 12))),
                  DataCell(Text('${userData['usageCount']}')),
                  DataCell(Text(NumberFormat.currency(
                    locale: 'vi_VN', symbol: '₫', decimalDigits: 0)
                    .format(userData['totalDiscountAmount']))),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
  
  // Chức năng toggle trạng thái kích hoạt của voucher
  Future<void> _toggleVoucherStatus() async {
    if (_currentVoucher == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Đảo ngược trạng thái
      final newStatus = !_currentVoucher!.isActive;
      
      // Cập nhật trạng thái
      await _voucherController.toggleVoucherStatus(_currentVoucher!.id, newStatus);
      
      // Tải lại thông tin voucher
      final updatedVoucher = await _voucherController.getVoucherById(_currentVoucher!.id);
      
      if (mounted && updatedVoucher != null) {
        setState(() {
          _currentVoucher = updatedVoucher;
          _isLoading = false;
        });
        
        _showSuccessSnackBar(
          newStatus 
            ? 'Đã kích hoạt mã giảm giá ${_currentVoucher!.code}' 
            : 'Đã khóa mã giảm giá ${_currentVoucher!.code}'
        );
      }
    } catch (e) {
      _showErrorSnackBar('Lỗi khi thay đổi trạng thái: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildOrdersTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Mã đơn hàng')),
          DataColumn(label: Text('Ngày đặt')),
          DataColumn(label: Text('Khách hàng')),
          DataColumn(label: Text('Tổng tiền')),
          DataColumn(label: Text('Trạng thái')),
        ],
        rows: _appliedOrders.map((order) {
          return DataRow(
            cells: [
              DataCell(Text(order['orderId'] ?? order['id'] ?? 'N/A')),
              DataCell(Text(order['createdAt'] != null
                  ? DateFormat('dd/MM/yyyy')
                      .format((order['createdAt'] as Timestamp).toDate())
                  : 'N/A')),
              DataCell(Text(order['customerName'] ?? 'N/A')),
              DataCell(Text(order['totalAmount'] != null
                  ? NumberFormat.currency(
                          locale: 'vi_VN', symbol: 'đ', decimalDigits: 0)
                      .format(order['totalAmount'])
                  : 'N/A')),
              DataCell(Text(order['status'] ?? 'N/A')),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final voucherId = appProvider.currentVoucherId;

    if (voucherId.isNotEmpty) {
      // Use the deleteVoucher function from voucher_row_item.dart
      // This provides a consistent deletion experience across the app
      deleteVoucher(context, voucherId).then((_) {
        // After successful deletion, navigate back to voucher list
        appProvider.setCurrentScreen(AppScreen.voucherList);
      });
    }
  }
}
