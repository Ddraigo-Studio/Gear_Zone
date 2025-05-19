import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import '../model/review.dart';

class ReviewService {
  static final ReviewService _instance = ReviewService._internal();

  factory ReviewService() => _instance;

  ReviewService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id ?? 'unknown_android';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'unknown_ios';
      }
    } catch (e) {
      print('Error getting device ID: $e');
    }
    return 'unknown_device_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<String?> addReview(
    String productId,
    double rating,
    String comment,
    List<String> images,
  ) async {
    try {
      String userId;
      String userName = 'Khách';
      String userAvatar = '';

      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
        final userData = userDoc.data();
        if (userData == null) {
          throw Exception('Không tìm thấy thông tin người dùng');
        }
        userId = currentUser.uid;
        userName = userData['name'] ?? 'Người dùng';
        userAvatar = userData['profilePicture'] ?? '';
        if (rating == 0.0) {
          throw Exception('Người dùng đã đăng nhập phải chọn số sao');
        }
      } else {
        if (rating > 0.0) {
          throw Exception('Bạn cần đăng nhập để đánh giá bằng sao');
        }
        userId = 'anonymous_${await _getDeviceId()}';
      }

      final reviewRef = _firestore.collection('reviews').doc();
      final review = ReviewModel(
        id: reviewRef.id,
        userId: userId,
        productId: productId,
        userName: userName,
        userAvatar: userAvatar,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
        images: images,
      );

      await reviewRef.set(review.toMap());
      // No need to update summary here; WebSocket server handles it
      return reviewRef.id;
    } catch (e) {
      print('Lỗi khi thêm đánh giá: $e');
      rethrow;
    }
  }

  Stream<List<ReviewModel>> getProductReviews(String productId) {
    return _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReviewModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<ReviewModel>> getUserReviews(String userId) {
    return _firestore
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReviewModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<ProductReviewSummary?> getProductReviewSummary(String productId) async {
    try {
      final doc = await _firestore.collection('product_reviews').doc(productId).get();
      if (!doc.exists || doc.data() == null) {
        return ProductReviewSummary(
          productId: productId,
          averageRating: 0.0,
          numberOfReviews: 0,
          ratingDistribution: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
        );
      }

      final data = doc.data()!;
      Map<int, int> ratingDistribution = {};
      if (data['ratingDistribution'] != null) {
        (data['ratingDistribution'] as Map<String, dynamic>).forEach((key, value) {
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