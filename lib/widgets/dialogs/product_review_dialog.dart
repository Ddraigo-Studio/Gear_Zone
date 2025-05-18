import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../core/app_export.dart';
import '../../controller/review_controller.dart';
import '../../model/order.dart';

class ProductReviewDialog extends StatefulWidget {
  final OrderItem orderItem;
  final Function? onReviewCompleted;

  const ProductReviewDialog({
    super.key,
    required this.orderItem,
    this.onReviewCompleted,
  });

  @override
  State<ProductReviewDialog> createState() => _ProductReviewDialogState();
}

class _ProductReviewDialogState extends State<ProductReviewDialog> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 5.0;
  final ReviewController _reviewController = ReviewController();
  bool _isSaving = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Xử lý gửi đánh giá
  void _submitReview() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập nhận xét của bạn'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() {
        _isSaving = true;
      });

      await _reviewController.addReview(
        productId: widget.orderItem.productId,
        rating: _rating,
        comment: _commentController.text.trim(),
      );

      if (widget.onReviewCompleted != null) {
        widget.onReviewCompleted!();
      }

      if (mounted) {
        Navigator.pop(context, true); // Đóng dialog với kết quả thành công

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cảm ơn bạn đã gửi đánh giá!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi gửi đánh giá: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.h),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Tiêu đề
              Text(
                'Đánh giá sản phẩm',
                style: CustomTextStyles.titleMediumGabaritoPrimaryBold,
              ),
              SizedBox(height: 16.h),

              // Thông tin sản phẩm
              Row(
                children: [
                  // Ảnh sản phẩm
                  Container(
                    height: 60.h,
                    width: 60.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.h),
                      child: widget.orderItem.productImage != null
                          ? Image.network(
                              widget.orderItem.productImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade300,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey.shade700,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey.shade300,
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey.shade700,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 12.h),

                  // Tên sản phẩm
                  Expanded(
                    child: Text(
                      widget.orderItem.productName,
                      style: theme.textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Rating bar
              Text(
                'Đánh giá của bạn',
                style: CustomTextStyles.bodyLargeBalooBhaijaanGray900,
              ),
              SizedBox(height: 8.h),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.h),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: appTheme.deepPurple400,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              SizedBox(height: 16.h),

              // Textfield nhận xét
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Nhập nhận xét của bạn về sản phẩm...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  contentPadding: EdgeInsets.all(16.h),
                ),
                maxLines: 4,
                textInputAction: TextInputAction.newline,
              ),
              SizedBox(height: 24.h),

              // Nút gửi đánh giá
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                  ),
                  child: _isSaving
                      ? Center(
                          child: SizedBox(
                            height: 20.h,
                            width: 20.h,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.h,
                            ),
                          ),
                        )
                      : Text(
                          'Gửi đánh giá',
                          style: CustomTextStyles.titleSmallWhiteA700,
                        ),
                ),
              ),
              SizedBox(height: 8.h),

              // Nút hủy
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Để sau',
                  style: CustomTextStyles.bodyMediumAmaranthRed500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
