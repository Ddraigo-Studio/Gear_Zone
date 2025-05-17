import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gear_zone/core/app_provider.dart';
import 'package:gear_zone/controller/voucher_controller.dart';
import 'package:gear_zone/model/voucher.dart';
import 'package:gear_zone/core/utils/responsive.dart';
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
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
    final appProvider = Provider.of<AppProvider>(context, listen: false);

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Status filter removed
            
            // Add a "New Voucher" button
            ElevatedButton.icon(
              onPressed: () {
                appProvider.setCurrentScreen(AppScreen.voucherAdd);
              },
              icon: const Icon(Icons.add),
              label: const Text('Thêm mã giảm giá mới'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 24,
                  vertical: isMobile ? 10 : 16,
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
    
    return StreamBuilder<List<Voucher>>(
      stream: _voucherController.getVouchers(),
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
  }  Widget _buildMobileVouchersList(List<Voucher> vouchers, AppProvider appProvider) {
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
  }Widget _buildDesktopVouchersList(List<Voucher> vouchers, AppProvider appProvider) {
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
              color: Colors.white,
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
