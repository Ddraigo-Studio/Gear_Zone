import 'package:flutter/material.dart';
import '../core/app_export.dart';
import '../controller/review_controller.dart';
import '../model/review.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductReviewList extends StatefulWidget {
  final String productId;

  const ProductReviewList({
    super.key,
    required this.productId,
  });

  @override
  State<ProductReviewList> createState() => _ProductReviewListState();
}

class _ProductReviewListState extends State<ProductReviewList> {
  final ReviewController _reviewController = ReviewController();
  bool _isLoading = true;
  ProductReviewSummary? _summary;

  @override
  void initState() {
    super.initState();
    _loadReviewSummary();
  }

  // Tải thông tin tổng hợp đánh giá
  Future<void> _loadReviewSummary() async {
    try {
      final summary =
          await _reviewController.getProductReviewSummary(widget.productId);
      if (mounted) {
        setState(() {
          _summary = summary;
        });
      }
    } catch (e) {
      print('Lỗi khi lấy thông tin tổng hợp đánh giá: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ReviewModel>>(
      stream: _reviewController.getProductReviews(widget.productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && _isLoading) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(appTheme.deepPurple400),
            ),
          );
        }

        // Khi có dữ liệu, cập nhật trạng thái và hiển thị
        _isLoading = false;

        if (snapshot.hasError) {
          print('Không thể tải đánh giá: ${snapshot.error}');
          return Center(
            child: Text(
              'Không thể tải đánh giá: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        final reviews = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRatingOverview(),
            SizedBox(height: 16.h),
            ...reviews.map((review) => _buildReviewItem(review)),
            if (reviews.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Text(
                    'Chưa có đánh giá nào cho sản phẩm này',
                    style: CustomTextStyles.bodyMediumBalooBhaijaanGray900_1,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // Widget hiển thị tổng quan đánh giá
  Widget _buildRatingOverview() {
    final hasReviews = (_summary?.numberOfReviews ?? 0) > 0;
    final averageRating = hasReviews ? _summary?.averageRating ?? 0.0 : 0.0;
    final numberOfReviews = _summary?.numberOfReviews ?? 0;

    return Row(
      children: [
        // Điểm đánh giá trung bình
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              hasReviews ? "${averageRating.toStringAsFixed(1)}/5" : "Chưa có",
              style: CustomTextStyles.headlineSmallRed500,
            ),
            SizedBox(height: 4.h),
            RatingBar.builder(
              initialRating: averageRating,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              ignoreGestures: true,
              itemCount: 5,
              itemSize: 16.h,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: appTheme.deepPurple400,
              ),
              onRatingUpdate: (_) {},
            ),
            SizedBox(height: 4.h),
            Text(
              '$numberOfReviews lượt đánh giá',
              style: CustomTextStyles.bodySmallBalooBhaiDeeppurple400,
            ),
          ],
        ),
        SizedBox(width: 24.h),

        // Biểu đồ phân phối đánh giá
        if (hasReviews)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 5; i >= 1; i--)
                  _buildRatingBar(
                      i, _summary?.ratingDistribution[i] ?? 0, numberOfReviews),
              ],
            ),
          ),
      ],
    );
  }

  // Widget hiển thị thanh đánh giá cho từng mức sao
  Widget _buildRatingBar(int rating, int count, int total) {
    final percent = total > 0 ? (count / total) : 0.0;

    return Row(
      children: [
        Text(
          '$rating',
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(width: 4.h),
        Icon(
          Icons.star,
          size: 12.h,
          color: appTheme.deepPurple400,
        ),
        SizedBox(width: 8.h),
        Expanded(
          child: Stack(
            children: [
              // Thanh nền
              Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(3.h),
                ),
              ),
              // Thanh tiến trình
              FractionallySizedBox(
                widthFactor: percent,
                child: Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: appTheme.deepPurple400,
                    borderRadius: BorderRadius.circular(3.h),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.h),
        Text(
          '$count',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  // Widget hiển thị một đánh giá
  Widget _buildReviewItem(ReviewModel review) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.h),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Người đánh giá và số sao
          Row(
            children: [
              // Avatar
              Container(
                height: 40.h,
                width: 40.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
                child: review.userAvatar.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20.h),
                        child: Image.network(
                          review.userAvatar,
                          fit: BoxFit.cover,
                          height: 40.h,
                          width: 40.h,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              color: Colors.grey.shade400,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: Colors.grey.shade400,
                      ),
              ),
              SizedBox(width: 12.h),

              // Tên và điểm đánh giá
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: CustomTextStyles.labelLargeGray900,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        for (int i = 1; i <= 5; i++)
                          Icon(
                            i <= review.rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            color: appTheme.deepPurple400,
                            size: 16.h,
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Thời gian đánh giá
              Text(
                _formatReviewDate(review.createdAt),
                style: CustomTextStyles.bodySmallBalooBhaiGray900,
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Nội dung đánh giá
          Text(
            review.comment,
            style: CustomTextStyles.bodyMediumBalooBhaijaanGray900_1,
          ),

          // Hình ảnh đánh giá nếu có
          if (review.images.isNotEmpty) ...[
            SizedBox(height: 12.h),
            SizedBox(
              height: 60.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 8.h),
                    height: 60.h,
                    width: 60.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.h),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.h),
                      child: Image.network(
                        review.images[index],
                        fit: BoxFit.cover,
                        height: 60.h,
                        width: 60.h,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey.shade400,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Định dạng thời gian đánh giá
  String _formatReviewDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return FormatUtils.formatDate(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}
