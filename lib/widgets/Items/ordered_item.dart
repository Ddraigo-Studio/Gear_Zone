import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_outlined_button.dart';
import '../../theme/custom_button_style.dart';

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
      case 'Chờ xử lý':
        return const Color(0xFFFF7E5F); // Deep Orange
      case 'Đang giao':
        return Color(0xfffe5a5a);
      case 'Đã nhận':
        return Color(0xff6dd176);
      case 'Trả hàng':
        return Colors.black;
      case 'Đã hủy':
        return Colors.grey;
      default:
        return  const Color(0xFFFF7E5F);
    }
  }

  /// Hàm xác định màu cho nút “Đánh giá” dựa theo status
  Color _getReviewButtonColor() {
    switch (status) {
      case 'Đã nhận':
        return Color(0xfff2655d);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.h),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thông tin sản phẩm + trạng thái
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ảnh sản phẩm
              Container(
                height: 60.h,
                width: 60.h,
                margin: EdgeInsets.only(bottom: 6.h),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
              // Thông tin chi tiết
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
                        // color: statusColor.withOpacity(0.1),
                        border: Border.all(color: statusColor),
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(color: statusColor),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Giá sản phẩm
                    Text(
                      "${price.toStringAsFixed(2)}",
                      style: CustomTextStyles.bodySmallBalooBhaiRed500,
                    ),
                  ],
                ),
              ),
              
            ],
          ),
          if (status == "Đã nhận")
            DeliverySuccessWidget(
              dateText: "12/03/2025",
              onReturnPressed: () {
                // Xử lý khi nhấn nút Trả hàng/hoàn tiền
              },
              onConfirmReceived: () {
                // Xử lý khi nhấn nút Đã nhận được hàng
              },
            ),
          SizedBox(height: 16.h),
          if(status != "Đã nhận")
            SizedBox(
              
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildReviewButton(),
                  SizedBox(width: 16.h),
                  _buildDetailsButton(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Nút “Đánh giá” với màu tự quy định theo status
  Widget _buildReviewButton() {
    final reviewColor = _getReviewButtonColor();
    return SizedBox(
      height: 34.h,
      width: 120.h,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: reviewColor),
          foregroundColor: reviewColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.h),
          ),
        ),
        onPressed: onReviewPressed,
        child:  Text("Đánh giá", style: CustomTextStyles.titleSmallInterGray700),
      ),
    );
  }

  /// Nút “Chi tiết” với màu mặc định (có thể tùy chỉnh)
  Widget _buildDetailsButton() {
    return SizedBox(
      height: 34.h,
      width: 120.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.h),
          ),
        ),
        onPressed: onDetailsPressed,
        child: Text(
          "Chi tiết" ,
          style: CustomTextStyles.titleSmallWhiteA700,
        ),
      ),
    );
  }

}

/// Widget hiển thị thông báo "Giao hàng thành công"
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
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
                    minimumSize: Size(double.infinity, 48.h),
                  ),
                  child: Text('Trả hàng/hoàn tiền', style: CustomTextStyles.titleSmallInterGray700),
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
                    minimumSize: Size(double.infinity, 48.h), 
                  ),
                  child: Text(
                    'Đã nhận được hàng',
                    style: CustomTextStyles.titleSmallWhiteA700, 
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
