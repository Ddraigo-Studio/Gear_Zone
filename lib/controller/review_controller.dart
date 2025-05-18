import 'package:flutter/foundation.dart';
import '../model/review.dart';
import '../services/review_service.dart';

class ReviewController with ChangeNotifier {
  // Singleton pattern
  static final ReviewController _instance = ReviewController._internal();

  factory ReviewController() {
    return _instance;
  }

  ReviewController._internal();

  final ReviewService _reviewService = ReviewService();

  // Thêm đánh giá mới
  Future<String?> addReview({
    required String productId,
    required double rating,
    required String comment,
    List<String> images = const [],
  }) async {
    try {
      final reviewId = await _reviewService.addReview(
        productId,
        rating,
        comment,
        images,
      );
      notifyListeners(); // Thông báo cho các widget lắng nghe
      return reviewId;
    } catch (e) {
      print('Lỗi khi thêm đánh giá: $e');
      rethrow;
    }
  }

  // Lấy tất cả đánh giá của một sản phẩm
  Stream<List<ReviewModel>> getProductReviews(String productId) {
    return _reviewService.getProductReviews(productId);
  }

  // Lấy tất cả đánh giá của một người dùng
  Stream<List<ReviewModel>> getUserReviews(String userId) {
    return _reviewService.getUserReviews(userId);
  }

  // Kiểm tra xem người dùng đã đánh giá sản phẩm chưa
  Future<bool> hasUserReviewedProduct(String productId, String userId) {
    return _reviewService.hasUserReviewedProduct(productId, userId);
  }

  // Lấy thông tin tổng hợp đánh giá của sản phẩm
  Future<ProductReviewSummary?> getProductReviewSummary(String productId) {
    return _reviewService.getProductReviewSummary(productId);
  }
}
