import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_outlined_button.dart';

class OrderedItem extends StatelessWidget {
  final String imagePath;
  final String productName;
  final String color;
  final int quantity;
  final double price;
  final String status;
  final VoidCallback? onReviewPressed;
  final VoidCallback? onDetailsPressed;

  const OrderedItem({
    super.key,
    required this.imagePath,
    required this.productName,
    required this.color,
    required this.quantity,
    required this.price,
    required this.status,
    this.onReviewPressed,
    this.onDetailsPressed,
  });

  /// Hàm xác định màu cho ô trạng thái (label) dựa theo status
  Color _getStatusColor() {
    switch (status) {
      case 'Chờ xác nhận':
      case 'Chờ xử lý': // Nếu bạn có thêm trạng thái này
        return const Color(0xFFFF7E5F); // Deep Orange
      case 'Chờ giao hàng':
        return Colors.blue;
      case 'Đã giao':
        return Colors.green;
      case 'Trả hàng':
        return Colors.purple;
      case 'Đã hủy':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  /// Hàm xác định màu cho nút “Đánh giá” dựa theo status
  /// Có thể giống _getStatusColor() hoặc tùy chỉnh khác nhau.
  Color _getReviewButtonColor() {
    switch (status) {
      case 'Chờ xác nhận':
      case 'Chờ xử lý':
        return const Color(0xFFFF7E5F);
      case 'Chờ giao hàng':
        return Colors.blue;
      case 'Đã giao':
        return Colors.green;
      case 'Trả hàng':
        return Colors.purple;
      case 'Đã hủy':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.h),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thông tin sản phẩm + Trạng thái
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Ảnh sản phẩm
              Container(
                height: 42.h,
                width: 60.h,
                margin: EdgeInsets.only(bottom: 6.h),
                color: Colors.white, // Demo
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
              // Thông tin
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: theme.textTheme.bodyLarge,
                      ),
                      Text("Color $color", style: CustomTextStyles.bodySmallBalooBhaiBlack900),
                      Text("Số lượng: $quantity", style: CustomTextStyles.bodySmallBalooBhaiGray90010),
                    ],
                  ),
                ),
              ),
              // Ô trạng thái + giá
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Trạng thái
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        border: Border.all(color: statusColor),
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(color: statusColor),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Giá
                    Text(
                      "${price.toStringAsFixed(2)}",
                      style: CustomTextStyles.bodySmallBalooBhaiRed500,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Nút “Đánh giá” + “Chi tiết”
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildReviewButton(),
              SizedBox(width: 16.h),
              _buildDetailsButton(),
            ],
          ),
        ],
      ),
    );
  }

  /// Tạo nút “Đánh giá” với màu tùy theo status
  Widget _buildReviewButton() {
    final reviewColor = _getReviewButtonColor();
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: reviewColor),
        foregroundColor: reviewColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
      ),
      onPressed: onReviewPressed,
      child: const Text("Đánh giá"),
    );
  }

  /// Nút “Chi tiết” (giữ màu mặc định hoặc tuỳ ý bạn)
  Widget _buildDetailsButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary, // Màu chính
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
      ),
      onPressed: onDetailsPressed,
      child: const Text("Chi tiết"),
    );
  }
}


class DeliverySuccessWidget extends StatelessWidget {
  final String dateText;
  final VoidCallback? onReturnPressed;
  final VoidCallback? onConfirmReceived;

  const DeliverySuccessWidget({
    super.key,
    required this.dateText,
    this.onReturnPressed,
    this.onConfirmReceived,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Giao hàng thành công vào $dateText',
            style: TextStyle(
              color: Colors.green.shade700,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReturnPressed,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                  ),
                  child: const Text('Trả hàng/hoàn tiền'),
                ),
              ),
              SizedBox(width: 16.h),
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirmReceived,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                  ),
                  child: const Text('Đã nhận được hàng'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}