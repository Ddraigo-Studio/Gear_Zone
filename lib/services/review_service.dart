import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/review.dart';
import '../model/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class ReviewService {
  // Singleton pattern
  static final ReviewService _instance = ReviewService._internal();

  factory ReviewService() {
    return _instance;
  }

  ReviewService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Lưu đánh giá mới vào Firebase
  Future<String?> addReview(
    String productId,
    double rating,
    String comment,
    List<String> images,
  ) async {
    try {
      // Kiểm tra user đã đăng nhập hay chưa
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('Bạn cần đăng nhập để đánh giá sản phẩm');
      }

      // Lấy thông tin chi tiết của user từ Firestore
      final userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      final userData = userDoc.data();
      if (userData == null) {
        throw Exception('Không tìm thấy thông tin người dùng');
      }

      // Tạo reference cho document mới
      final reviewRef = _firestore.collection('reviews').doc();

      // Tạo object ReviewModel
      final review = ReviewModel(
        id: reviewRef.id,
        userId: currentUser.uid,
        productId: productId,
        userName: userData['name'] ?? 'Người dùng',
        userAvatar: userData['profilePicture'] ?? '',
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
        images: images,
      );

      // Lưu vào Firestore
      await reviewRef.set(review.toMap());

      // Cập nhật tổng hợp đánh giá cho sản phẩm
      await _updateProductReviewSummary(productId);

      return reviewRef.id;
    } catch (e) {
      print('Lỗi khi thêm đánh giá: $e');
      rethrow;
    }
  }

  // Lấy tất cả đánh giá của một sản phẩm
  Stream<List<ReviewModel>> getProductReviews(String productId) {
    return _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                ReviewModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Lấy tất cả đánh giá của một người dùng
  Stream<List<ReviewModel>> getUserReviews(String userId) {
    return _firestore
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                ReviewModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Kiểm tra xem người dùng đã đánh giá sản phẩm chưa
  Future<bool> hasUserReviewedProduct(String productId, String userId) async {
    final querySnapshot = await _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  // Cập nhật tóm tắt đánh giá cho sản phẩm (số sao trung bình, số lượng đánh giá)
  Future<void> _updateProductReviewSummary(String productId) async {
    try {
      // Lấy tất cả đánh giá của sản phẩm
      final reviewsSnapshot = await _firestore
          .collection('reviews')
          .where('productId', isEqualTo: productId)
          .get();

      final reviews = reviewsSnapshot.docs
          .map((doc) => ReviewModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // Nếu không có đánh giá nào
      if (reviews.isEmpty) {
        await _firestore.collection('product_reviews').doc(productId).set({
          'productId': productId,
          'averageRating': 0.0,
          'numberOfReviews': 0,
          'ratingDistribution': {
            '1': 0,
            '2': 0,
            '3': 0,
            '4': 0,
            '5': 0,
          },
        });
        return;
      }

      // Tính toán điểm đánh giá trung bình
      double totalRating =
          reviews.fold(0.0, (sum, review) => sum + review.rating);
      double averageRating = totalRating / reviews.length;

      // Tạo phân bố đánh giá
      Map<String, int> ratingDistribution = {
        '1': 0,
        '2': 0,
        '3': 0,
        '4': 0,
        '5': 0,
      };

      for (var review in reviews) {
        int rating = review.rating.round();
        if (rating < 1) rating = 1;
        if (rating > 5) rating = 5;
        ratingDistribution[rating.toString()] =
            (ratingDistribution[rating.toString()] ?? 0) + 1;
      }

      // Lưu tổng hợp đánh giá vào Firestore
      await _firestore.collection('product_reviews').doc(productId).set({
        'productId': productId,
        'averageRating': averageRating,
        'numberOfReviews': reviews.length,
        'ratingDistribution': ratingDistribution,
      });

      // Cập nhật trường rating trong sản phẩm
      await _firestore.collection('products').doc(productId).update({
        'rating': averageRating,
      });
    } catch (e) {
      print('Lỗi khi cập nhật tóm tắt đánh giá: $e');
    }
  }

  // Lấy thông tin tổng hợp đánh giá của sản phẩm
  Future<ProductReviewSummary?> getProductReviewSummary(
      String productId) async {
    try {
      final doc =
          await _firestore.collection('product_reviews').doc(productId).get();

      if (!doc.exists || doc.data() == null) {
        // Trả về tổng hợp mặc định nếu không có dữ liệu
        return ProductReviewSummary(
          productId: productId,
          averageRating: 0.0,
          numberOfReviews: 0,
          ratingDistribution: {
            1: 0,
            2: 0,
            3: 0,
            4: 0,
            5: 0,
          },
        );
      }

      final data = doc.data()!;

      // Convert ratingDistribution từ Map<String, dynamic> sang Map<int, int>
      Map<int, int> ratingDistribution = {};
      if (data['ratingDistribution'] != null) {
        (data['ratingDistribution'] as Map<String, dynamic>)
            .forEach((key, value) {
          ratingDistribution[int.parse(key)] = (value as num).toInt();
        });
      }

      return ProductReviewSummary(
        productId: productId,
        averageRating: (data['averageRating'] as num).toDouble(),
        numberOfReviews: (data['numberOfReviews'] as num).toInt(),
        ratingDistribution: ratingDistribution,
      );
    } catch (e) {
      print('Lỗi khi lấy thông tin tổng hợp đánh giá: $e');
      return null;
    }
  }
}
