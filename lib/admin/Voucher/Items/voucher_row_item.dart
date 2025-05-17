import 'package:flutter/material.dart';
import '../../../model/voucher.dart'; // Import Voucher model
import '../../../core/app_provider.dart'; 
import '../../../core/utils/responsive.dart';
import 'package:provider/provider.dart';
import '../../../controller/voucher_controller.dart'; // Import VoucherController
import 'package:intl/intl.dart'; // Import intl for date formatting

TableRow buildVoucherTableRow(
    BuildContext context, int index, List<Voucher> vouchers) {  final voucher = vouchers[index % vouchers.length];
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
      // Voucher Code
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16, horizontal: 8),
          child: Row(
            children: [
              Container(
                width: isMobile ? 40 : 48,
                height: isMobile ? 40 : 48,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Icon(
                    Icons.card_giftcard,
                    color: Colors.blue.shade800,
                    size: isMobile ? 24 : 28,
                  ),
                ),
              ),
              SizedBox(width: isMobile ? 8 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      voucher.id,
                      style: TextStyle(
                        fontSize: isMobile ? 10 : 13,
                        color: Theme.of(context).primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      voucher.code,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 13,
                        fontWeight: FontWeight.w500,
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
      // Discount Amount
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
          alignment: Alignment.center,
          child: Text(
            NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(voucher.discountAmount),
            style: TextStyle(
              fontSize: isMobile ? 9 : 13,
            ),
          ),
        ),
      ),      // Usage Count
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${voucher.currentUsageCount}/${voucher.maxUsageCount}',
                style: TextStyle(
                  fontSize: isMobile ? 12 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Còn lại: ${voucher.remainingUsageCount}',
                style: TextStyle(
                  fontSize: isMobile ? 9 : 11,
                  color: voucher.remainingUsageCount > 0 ? Colors.green : Colors.red,
                ),
              ),
              if (!isMobile)
                Text(
                  '${voucher.userUsageCounts.length} người dùng',
                  style: TextStyle(
                    fontSize: isMobile ? 8 : 10,
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
        ),
      ),
      // Created Date
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
                DateFormat('dd/MM/yyyy').format(voucher.createdAt),
                style: TextStyle(fontSize: isMobile ? 9 : 13),
              ),
              Text(
                DateFormat('HH:mm:ss').format(voucher.createdAt),
                style: TextStyle(fontSize: isMobile ? 9 : 13, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),      // Status
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Active status indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12, vertical: isMobile ? 4 : 6),
                decoration: BoxDecoration(
                  color: voucher.isActive ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  voucher.isActive ? 'Đang kích hoạt' : 'Đã khóa',
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 13,
                    fontWeight: FontWeight.w500, 
                    color: voucher.isActive ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Remaining usage status
              if (!isMobile || voucher.isActive)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 6 : 10, vertical: isMobile ? 2 : 4),
                  decoration: BoxDecoration(
                    color: voucher.remainingUsageCount > 0 ? Colors.blue.shade50 : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    voucher.remainingUsageCount > 0 ? 'Còn lượt' : 'Hết lượt',
                    style: TextStyle(
                      fontSize: isMobile ? 8 : 11,
                      fontWeight: FontWeight.w500,
                      color: voucher.remainingUsageCount > 0 ? Colors.blue.shade700 : Colors.orange.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
      // Actions
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 0 : 16),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.visibility_outlined, size: isMobile ? 18 : 20),
                onPressed: () {
                  // Save current voucher ID to Provider to access in detail screen
                  appProvider.setCurrentVoucherId(voucher.id);
                  // Navigate to voucher detail screen in view-only mode
                  appProvider.setCurrentScreen(AppScreen.voucherDetail,
                      isViewOnly: true);
                },
                color: Colors.grey,
                padding: EdgeInsets.all(isMobile ? 2 : 4),
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
                tooltip: 'Xem mã giảm giá',
              ),
              SizedBox(width: isMobile ? 2 : 8),
              IconButton(
                icon: Icon(Icons.edit_outlined, size: isMobile ? 18 : 20),
                onPressed: () {
                  // Navigate to voucher detail screen in edit mode
                  appProvider.setCurrentScreen(AppScreen.voucherDetail,
                      isViewOnly: false);
                  // Save current voucher ID to Provider to access in detail screen
                  appProvider.setCurrentVoucherId(voucher.id);
                },
                color: Colors.grey,
                padding: EdgeInsets.all(isMobile ? 2 : 4),
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
                tooltip: 'Sửa mã giảm giá',
              ),
              SizedBox(width: isMobile ? 2 : 8),
              IconButton(
                icon: Icon(Icons.delete_outlined, size: isMobile ? 18 : 20),
                onPressed: () => deleteVoucher(context, voucher.id),
                color: Colors.red.shade300,
                padding: EdgeInsets.all(isMobile ? 2 : 4),
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
                tooltip: 'Xóa mã giảm giá',
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget buildMobileVoucherItem(
    BuildContext context, int index, Voucher voucher,
    {bool isExpanded = false, Function(int)? onExpandToggle}) {
  final isActive = voucher.remainingUsageCount > 0;
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
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
              ),            
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Icon(
                    Icons.card_giftcard,
                    color: Colors.blue.shade800,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mã: ${voucher.code}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(voucher.discountAmount),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 20,
                ),
                onPressed: () {
                  if (onExpandToggle != null) {
                    onExpandToggle(index);
                  }
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
              ),
            ],
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 36.0, right: 16.0, bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('ID:', voucher.id),
                _buildInfoRow('Ngày tạo:', DateFormat('dd/MM/yyyy HH:mm').format(voucher.createdAt)),
                _buildInfoRow('Số lượt dùng:', '${voucher.currentUsageCount}/${voucher.maxUsageCount}'),
                _buildInfoRow('Trạng thái:', isActive ? 'Có hiệu lực' : 'Hết hiệu lực'),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(
                      icon: Icons.visibility_outlined,
                      label: 'Xem',
                      onPressed: () {
                        // Save current voucher ID to Provider to access in detail screen
                        appProvider.setCurrentVoucherId(voucher.id);
                        // Navigate to voucher detail screen in view-only mode
                        appProvider.setCurrentScreen(AppScreen.voucherDetail,
                            isViewOnly: true);
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.edit_outlined,
                      label: 'Sửa',
                      onPressed: () {
                        // Navigate to voucher detail screen in edit mode
                        appProvider.setCurrentScreen(AppScreen.voucherDetail,
                            isViewOnly: false);
                        // Save current voucher ID to Provider to access in detail screen
                        appProvider.setCurrentVoucherId(voucher.id);
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.delete_outlined,
                      label: 'Xóa',
                      color: Colors.red.shade300,
                      onPressed: () => deleteVoucher(context, voucher.id),
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

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildActionButton({
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
  Color? color,
}) {
  return TextButton.icon(
    onPressed: onPressed,
    icon: Icon(icon, size: 16, color: color ?? Colors.grey.shade700),
    label: Text(
      label,
      style: TextStyle(fontSize: 12, color: color ?? Colors.grey.shade700),
    ),
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      minimumSize: const Size(60, 36),
    ),
  );
}

Future<void> deleteVoucher(BuildContext context, String voucherId) async {
  final VoucherController voucherController = VoucherController();
  final appProvider = Provider.of<AppProvider>(context, listen: false);
  
  // Hiển thị dialog xác nhận
  bool confirm = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Xác nhận'),
      content: const Text('Bạn có chắc chắn muốn xóa mã giảm giá này?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Xóa'),
        ),
      ],
    ),
  ) ?? false;

  if (confirm) {
    try {
      // Hiển thị loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      
      // Xóa voucher
      await voucherController.deleteVoucher(voucherId);
      
      // Đóng dialog loading
      Navigator.of(context).pop();
      
      // Thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xóa mã giảm giá thành công'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Đánh dấu cần tải lại danh sách voucher
      appProvider.setReloadVoucherList(true);
    } catch (e) {
      // Đóng dialog loading nếu có lỗi
      Navigator.of(context).pop();
      
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi xóa mã giảm giá: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
