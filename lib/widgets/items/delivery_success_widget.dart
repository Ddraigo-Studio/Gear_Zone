import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../dialogs/product_review_dialog.dart';
import '../../model/order.dart';

class DeliverySuccessWidget extends StatefulWidget {
  final String dateText;
  final VoidCallback? onReturnPressed;
  final Function? onReviewSubmitted;
  final OrderItem orderItem;

  const DeliverySuccessWidget({
    super.key,
    required this.dateText,
    required this.orderItem,
    this.onReturnPressed,
    this.onReviewSubmitted,
  });

  @override
  State<DeliverySuccessWidget> createState() => _DeliverySuccessWidgetState();
}

class _DeliverySuccessWidgetState extends State<DeliverySuccessWidget> {
  bool _hasConfirmed = false;

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
              _hasConfirmed = true;
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
            'Giao hàng thành công vào ${widget.dateText}',
            style: TextStyle(
              color: Colors.green.shade700,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 12.h),
          _hasConfirmed
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
                        style:
                            CustomTextStyles.bodySmallBalooBhaiGray700.copyWith(
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
                        onPressed: widget.onReturnPressed,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.h),
                          ),
                          minimumSize: Size(double.infinity, 48.h),
                        ),
                        child: Text('Trả hàng/hoàn tiền',
                            style: CustomTextStyles.titleSmallInterGray700),
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
    );
  }
}
