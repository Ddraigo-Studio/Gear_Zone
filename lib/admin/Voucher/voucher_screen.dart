import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gear_zone/core/app_provider.dart';
import 'package:gear_zone/controller/voucher_controller.dart';
import 'package:gear_zone/model/voucher.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import 'package:intl/intl.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({Key? key}) : super(key: key);

  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  final VoucherController _voucherController = VoucherController();
  bool _showActiveOnly = false;
  bool _isLoading = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Kiểm tra xem có cần tải lại danh sách không
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      if (appProvider.reloadVoucherList) {
        appProvider.setReloadVoucherList(false);
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
    final appProvider = Provider.of<AppProvider>(context);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          appProvider.setCurrentScreen(AppScreen.voucherAdd);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
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

            // Vouchers list
            Expanded(
              child: _buildVouchersList(context),
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
        ),
        if (!isMobile) ...[
          const SizedBox(width: 16),
          SizedBox(
            width: 300,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm mã giảm giá...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobile)
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm mã giảm giá...',
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        if (isMobile) const SizedBox(height: 16),
        
        Row(
          children: [
            FilterChip(
              label: const Text('Chỉ hiển thị phiếu còn hiệu lực'),
              selected: _showActiveOnly,
              onSelected: (selected) {
                setState(() {
                  _showActiveOnly = selected;
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              checkmarkColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVouchersList(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    return StreamBuilder<List<Voucher>>(
      stream: _voucherController.getVouchers(activeOnly: _showActiveOnly),
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

        final vouchers = snapshot.data ?? [];
        
        // Áp dụng bộ lọc tìm kiếm
        final filteredVouchers = _searchQuery.isEmpty
            ? vouchers
            : vouchers.where((v) => 
                v.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                v.id.toLowerCase().contains(_searchQuery.toLowerCase())
              ).toList();

        if (filteredVouchers.isEmpty) {
          return const Center(
            child: Text(
              'Không có phiếu giảm giá nào',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return isMobile
            ? _buildMobileVouchersList(filteredVouchers, appProvider)
            : _buildDesktopVouchersList(filteredVouchers, appProvider);
      },
    );
  }

  Widget _buildMobileVouchersList(List<Voucher> vouchers, AppProvider appProvider) {
    return ListView.builder(
      itemCount: vouchers.length,
      itemBuilder: (context, index) {
        final voucher = vouchers[index];
        final isActive = voucher.isActive && 
                         DateTime.now().isBefore(voucher.validToDate);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              voucher.code,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Giảm ${voucher.discountPercentage}% (tối đa ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0).format(voucher.maximumDiscountAmount)})',
                ),
                const SizedBox(height: 2),
                Text(
                  'HSD: ${DateFormat('dd/MM/yyyy').format(voucher.validToDate)}',
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 14),
              onPressed: () {
                appProvider.setCurrentVoucherId(voucher.id);
                appProvider.setCurrentScreen(AppScreen.voucherDetail, isViewOnly: true);
              },
            ),
            onTap: () {
              appProvider.setCurrentVoucherId(voucher.id);
              appProvider.setCurrentScreen(AppScreen.voucherDetail, isViewOnly: true);
            },
          ),
        );
      },
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
                    'Mã giảm giá',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Giảm giá',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Điều kiện',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Hiệu lực',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
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
              itemCount: vouchers.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[300],
              ),
              itemBuilder: (context, index) {
                final voucher = vouchers[index];
                final isActive = voucher.isActive && 
                                DateTime.now().isBefore(voucher.validToDate);
                
                return InkWell(
                  onTap: () {
                    appProvider.setCurrentVoucherId(voucher.id);
                    appProvider.setCurrentScreen(AppScreen.voucherDetail, isViewOnly: true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Mã giảm giá
                        Expanded(
                          flex: 2,
                          child: Text(
                            voucher.code,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        // Giảm giá
                        Expanded(
                          flex: 2,
                          child: Text(
                            '${voucher.discountPercentage}% (tối đa ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0).format(voucher.maximumDiscountAmount)})',
                          ),
                        ),
                        
                        // Điều kiện
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Đơn hàng từ ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0).format(voucher.minimumOrderAmount)}',
                          ),
                        ),
                        
                        // Hiệu lực
                        Expanded(
                          flex: 2,
                          child: Text(
                            '${DateFormat('dd/MM/yyyy').format(voucher.validFromDate)} - ${DateFormat('dd/MM/yyyy').format(voucher.validToDate)}',
                          ),
                        ),
                        
                        // Trạng thái
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isActive ? Colors.green[50] : Colors.red[50],
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isActive ? Colors.green : Colors.red,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              isActive ? 'Còn hiệu lực' : 'Hết hiệu lực',
                              style: TextStyle(
                                color: isActive ? Colors.green : Colors.red,
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
                                icon: const Icon(Icons.edit, size: 18),
                                onPressed: () {
                                  appProvider.setCurrentVoucherId(voucher.id);
                                  appProvider.setCurrentScreen(AppScreen.voucherDetail, isViewOnly: false);
                                },
                                tooltip: 'Chỉnh sửa',
                                splashRadius: 20,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 18),
                                onPressed: () {
                                  _showDeleteConfirmation(context, voucher.id);
                                },
                                tooltip: 'Xóa',
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

  void _showDeleteConfirmation(BuildContext context, String voucherId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa phiếu giảm giá này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                _isLoading = true;
              });
              
              try {
                await _voucherController.deleteVoucher(voucherId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa phiếu giảm giá'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lỗi khi xóa: $e'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                  ),
                );
              } finally {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
            child: const Text('Xóa'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
