import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/app_export.dart';
import '../../controller/review_controller.dart';

class ProductReviewSubmissionDialog extends StatefulWidget {
  final String productId;
  final bool isLoggedIn;
  final VoidCallback? onReviewSubmitted;

  const ProductReviewSubmissionDialog({
    super.key,
    required this.productId,
    required this.isLoggedIn,
    this.onReviewSubmitted,
  });

  @override
  State<ProductReviewSubmissionDialog> createState() => _ProductReviewSubmissionDialogState();
}

class _ProductReviewSubmissionDialogState extends State<ProductReviewSubmissionDialog> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0.0;
  List<String> _images = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập bình luận')),
      );
      return;
    }

    if (widget.isLoggedIn && _rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn số sao')),
      );
      return;
    }

    if (!widget.isLoggedIn && _rating > 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập để đánh giá bằng sao')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final reviewController = ReviewController();
      await reviewController.addReview(
        productId: widget.productId,
        rating: _rating,
        comment: _commentController.text,
        images: _images,
      );

      widget.onReviewSubmitted?.call();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đánh giá đã được gửi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi gửi đánh giá: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.h)),
      child: Container(
        padding: EdgeInsets.all(16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Đánh giá sản phẩm',
              style: CustomTextStyles.titleMediumBalooBhai2Gray700,
            ),
            SizedBox(height: 16.h),
            if (widget.isLoggedIn)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chọn số sao:',
                    style: CustomTextStyles.bodyMediumBalooBhaijaanGray900_1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 30.h,
                        ),
                        onPressed: _isSubmitting
                            ? null
                            : () {
                                setState(() {
                                  _rating = (index + 1).toDouble();
                                });
                              },
                      );
                    }),
                  ),
                ],
              )
            else
              Text(
                'Vui lòng đăng nhập để đánh giá bằng sao',
                style: CustomTextStyles.bodySmallBalooBhaiRed500,
              ),
            SizedBox(height: 16.h),
            TextField(
              controller: _commentController,
              maxLines: 4,
              enabled: !_isSubmitting,
              decoration: InputDecoration(
                hintText: 'Nhập bình luận của bạn...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.h),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.h),
                ),
              ),
              child: _isSubmitting
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Gửi đánh giá',
                      style: CustomTextStyles.titleSmallWhiteA700,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}