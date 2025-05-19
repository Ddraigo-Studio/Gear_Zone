import 'package:flutter/foundation.dart' show kIsWeb;
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
    // Xác định kích thước dựa trên nền tảng
    final double dialogWidth = kIsWeb ? 600.0 : MediaQuery.of(context).size.width * 0.9;
    final double padding = kIsWeb ? 24.0 : 16.h;
    final double starSize = kIsWeb ? 36.0 : 30.h;
    final double buttonHeight = kIsWeb ? 56.0 : 48.h;
    final double fontSizeTitle = kIsWeb ? 20.0 : 18.h;
    final double fontSizeBody = kIsWeb ? 16.0 : 14.h;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        width: dialogWidth, // Giới hạn chiều rộng trên web
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Đánh giá sản phẩm',
              style: CustomTextStyles.titleMediumBalooBhai2Gray700.copyWith(
                fontSize: fontSizeTitle,
              ),
            ),
            SizedBox(height: padding),
            if (widget.isLoggedIn)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chọn số sao:',
                    style: CustomTextStyles.bodyMediumBalooBhaijaanGray900_1.copyWith(
                      fontSize: fontSizeBody,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return MouseRegion(
                        cursor: SystemMouseCursors.click, // Hiệu ứng chuột trên web
                        child: IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: starSize,
                          ),
                          onPressed: _isSubmitting
                              ? null
                              : () {
                                  setState(() {
                                    _rating = (index + 1).toDouble();
                                  });
                                },
                        ),
                      );
                    }),
                  ),
                ],
              )
            else
              Text(
                'Vui lòng đăng nhập để đánh giá bằng sao',
                style: CustomTextStyles.bodySmallBalooBhaiRed500.copyWith(
                  fontSize: fontSizeBody,
                ),
              ),
            SizedBox(height: padding),
            TextField(
              controller: _commentController,
              maxLines: kIsWeb ? 6 : 4, // Tăng chiều cao TextField trên web
              enabled: !_isSubmitting,
              decoration: InputDecoration(
                hintText: 'Nhập bình luận của bạn...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: kIsWeb ? 16.0 : 12.h,
                  horizontal: kIsWeb ? 16.0 : 12.h,
                ),
              ),
              style: TextStyle(fontSize: fontSizeBody),
            ),
            SizedBox(height: padding),
            MouseRegion(
              cursor: _isSubmitting ? SystemMouseCursors.basic : SystemMouseCursors.click, // Hiệu ứng chuột
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: Size(double.infinity, buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: kIsWeb ? 2 : 0, // Thêm đổ bóng nhẹ trên web
                  padding: EdgeInsets.symmetric(vertical: kIsWeb ? 16.0 : 12.h),
                ).merge(
                  kIsWeb
                      ? ButtonStyle(
                          overlayColor: WidgetStateProperty.all(
                            Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          ), // Hiệu ứng hover trên web
                        )
                      : null,
                ),
                child: _isSubmitting
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Gửi đánh giá',
                        style: CustomTextStyles.titleSmallWhiteA700.copyWith(
                          fontSize: fontSizeBody,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}