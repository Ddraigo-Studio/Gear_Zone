import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../model/order.dart';
import '../dialogs/product_review_dialog.dart';

class OrderedItem extends StatefulWidget {
  final String orderId;
  final OrderItem orderItem;
  final String status;
  final String deliveryDate;
  final VoidCallback? onReviewPressed;
  final VoidCallback? onDetailsPressed;
  final Function? onReviewSubmitted;

  const OrderedItem({
    super.key,
    required this.orderId,
    required this.orderItem,
    required this.status,
    required this.deliveryDate,
    this.onReviewPressed,
    this.onDetailsPressed,
    this.onReviewSubmitted,
  });

  @override
  State<OrderedItem> createState() => _OrderedItemState();
}

class _OrderedItemState extends State<OrderedItem> {
  bool _hasConfirmedDelivery = false;

  /// Hàm xác định màu cho ô trạng thái (label) dựa theo status
  Color _getStatusColor() {
    switch (widget.status) {
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
        return const Color(0xFFFF7E5F);
    }
  }

  /// Hàm xác định màu cho nút "Đánh giá" dựa theo status
  Color _getReviewButtonColor() {
    switch (widget.status) {
      case 'Đã nhận':
        return Color(0xfff2655d);
      default:
        return Colors.grey;
    }
  }

  /// Hàm xây dựng widget hiển thị hình ảnh sản phẩm
  /// Hỗ trợ cả hình ảnh cục bộ (asset) và hình ảnh từ URL mạng
  Widget _buildProductImage(String? path) {
    if (path == null || path.isEmpty) {
      return Container(
        color: Colors.grey.shade100,
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey,
          size: 30.h,
        ),
      );
    }

    // Kiểm tra xem đường dẫn có phải là URL không
    bool isNetworkImage = path.startsWith('http') || path.startsWith('https');
    if (isNetworkImage) {
      // Hiển thị ảnh từ mạng với xử lý lỗi
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.h),
        child: Image.network(
          path,
          fit: BoxFit.cover,
          height: 60.h,
          width: 60.h,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade100,
              child: Icon(
                Icons.image_not_supported,
                color: Colors.grey,
                size: 30.h,
              ),
            );
          },
        ),
      );
    } else {
      // Hiển thị ảnh local từ assets
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.h),
        child: Image.asset(
          path,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Nếu không tìm thấy ảnh, hiển thị icon placeholder
            return Container(
              color: Colors.grey.shade100,
              child: Icon(
                Icons.image_not_supported,
                color: Colors.grey,
                size: 30.h,
              ),
            );
          },
        ),
      );
    }
  }

  // Hiển thị dialog đánh giá sản phẩm
  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProductReviewDialog(
          orderItem: widget.orderItem,
          onReviewCompleted: () {
            // Callback khi đánh giá hoàn tất
            setState(() {
              _hasConfirmedDelivery = true;
            });
            if (widget.onReviewSubmitted != null) {
              widget.onReviewSubmitted!();
            }
          },
        );
      },
    );
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
                child: _buildProductImage(widget.orderItem.productImage),
              ),
              // Thông tin chi tiết
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.orderItem.productName,
                        style: theme.textTheme.bodyLarge,
                      ),
                      if (widget.orderItem.color != null &&
                          widget.orderItem.color!.isNotEmpty)
                        Text("Color ${widget.orderItem.color}",
                            style: CustomTextStyles.bodySmallBalooBhaiBlack900),
                      Text("Số lượng: ${widget.orderItem.quantity}",
                          style: CustomTextStyles.bodySmallBalooBhaiGray90010),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.h, vertical: 2.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: statusColor),
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                      child: Text(
                        widget.status,
                        style: TextStyle(color: statusColor),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Giá sản phẩm
                    Text(
                      FormatUtils.formatPrice(widget.orderItem.price),
                      style: CustomTextStyles.bodySmallBalooBhaiRed500,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Hiển thị phần xác nhận giao hàng nếu đơn hàng đã nhận
          if (widget.status == "Đã nhận")
            Container(
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
                    'Giao hàng thành công vào ${widget.deliveryDate}',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _hasConfirmedDelivery
                      ? Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                                size: 32.h,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Cảm ơn bạn đã xác nhận',
                                style: CustomTextStyles
                                    .bodySmallBalooBhaiGray700
                                    .copyWith(
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  // Xử lý khi nhấn nút Trả hàng/hoàn tiền
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black87,
                                  side: BorderSide(color: Colors.grey.shade400),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.h),
                                  ),
                                  minimumSize: Size(double.infinity, 48.h),
                                ),
                                child: Text('Trả hàng/hoàn tiền',
                                    style: CustomTextStyles
                                        .titleSmallInterGray700),
                              ),
                            ),
                            SizedBox(width: 16.h),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _showReviewDialog,
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
                        ),
                ],
              ),
            ),

          // Hiển thị nút Đánh giá và Chi tiết cho trạng thái khác
          if (widget.status != "Đã nhận")
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: SizedBox(
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
            ),
        ],
      ),
    );
  }

  /// Nút "Đánh giá" với màu tự quy định theo status
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
        onPressed: widget.onReviewPressed,
        child: Text("Đánh giá", style: CustomTextStyles.titleSmallInterGray700),
      ),
    );
  }

  /// Nút "Chi tiết" với màu mặc định (có thể tùy chỉnh)
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
        onPressed: widget.onDetailsPressed,
        child: Text(
          "Chi tiết",
          style: CustomTextStyles.titleSmallWhiteA700,
        ),
      ),
    );
  }
}
