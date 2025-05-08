class ReviewModel {
  final String id;          // ID của đánh giá
  final String userId;      // ID người dùng đánh giá
  final String productId;   // ID của sản phẩm được đánh giá
  final String userName;    // Tên người dùng đánh giá
  final String userAvatar;  // Avatar người dùng
  final double rating;      // Số sao đánh giá (từ 1-5)
  final String comment;     // Nội dung bình luận
  final DateTime createdAt; // Thời gian tạo đánh giá
  final List<String> images; // Danh sách hình ảnh kèm theo (nếu có)

  ReviewModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.images = const [],
  });

  // Chuyển đổi từ Map (JSON) sang ReviewModel
  factory ReviewModel.fromMap(Map<String, dynamic> data) {
    return ReviewModel(
      id: data["id"] ?? "",
      userId: data["userId"] ?? "",
      productId: data["productId"] ?? "",
      userName: data["userName"] ?? "User",
      userAvatar: data["userAvatar"] ?? "",
      rating: (data["rating"] ?? 0).toDouble(),
      comment: data["comment"] ?? "",
      createdAt: data["createdAt"] != null 
          ? DateTime.parse(data["createdAt"]) 
          : DateTime.now(),
      images: data["images"] != null 
          ? List<String>.from(data["images"]) 
          : [],
    );
  }

  // Chuyển đổi từ ReviewModel sang Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "productId": productId,
      "userName": userName,
      "userAvatar": userAvatar,
      "rating": rating,
      "comment": comment,
      "createdAt": createdAt.toIso8601String(),
      "images": images,
    };
  }

  // Tạo bản sao của ReviewModel với một số thuộc tính được thay đổi
  ReviewModel copyWith({
    String? id,
    String? userId,
    String? productId,
    String? userName,
    String? userAvatar,
    double? rating,
    String? comment,
    DateTime? createdAt,
    List<String>? images,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      images: images ?? this.images,
    );
  }
}

// Model để tổng hợp các đánh giá của một sản phẩm
class ProductReviewSummary {
  final String productId;         // ID của sản phẩm
  final double averageRating;     // Điểm đánh giá trung bình
  final int numberOfReviews;      // Số lượng đánh giá
  final Map<int, int> ratingDistribution; // Phân bố đánh giá (key: số sao, value: số lượng)

  ProductReviewSummary({
    required this.productId,
    required this.averageRating,
    required this.numberOfReviews,
    required this.ratingDistribution,
  });

  // Chuyển đổi từ Map (JSON) sang ProductReviewSummary
  factory ProductReviewSummary.fromMap(Map<String, dynamic> data) {
    Map<int, int> distribution = {};
    if (data["ratingDistribution"] != null) {
      data["ratingDistribution"].forEach((key, value) {
        distribution[int.parse(key)] = value;
      });
    }

    return ProductReviewSummary(
      productId: data["productId"] ?? "",
      averageRating: (data["averageRating"] ?? 0).toDouble(),
      numberOfReviews: data["numberOfReviews"] ?? 0,
      ratingDistribution: distribution,
    );
  }

  // Chuyển đổi từ ProductReviewSummary sang Map (JSON)
  Map<String, dynamic> toMap() {
    Map<String, dynamic> distribution = {};
    ratingDistribution.forEach((key, value) {
      distribution[key.toString()] = value;
    });

    return {
      "productId": productId,
      "averageRating": averageRating,
      "numberOfReviews": numberOfReviews,
      "ratingDistribution": distribution,
    };
  }

  // Phương thức để tính toán lại tổng hợp đánh giá khi có đánh giá mới
  static ProductReviewSummary calculate(String productId, List<ReviewModel> reviews) {
    if (reviews.isEmpty) {
      return ProductReviewSummary(
        productId: productId,
        averageRating: 0,
        numberOfReviews: 0,
        ratingDistribution: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
      );
    }

    double total = 0;
    Map<int, int> distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    for (var review in reviews) {
      total += review.rating;
      int rating = review.rating.round();
      if (rating >= 1 && rating <= 5) {
        distribution[rating] = (distribution[rating] ?? 0) + 1;
      }
    }

    return ProductReviewSummary(
      productId: productId,
      averageRating: total / reviews.length,
      numberOfReviews: reviews.length,
      ratingDistribution: distribution,
    );
  }
}