import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String productId;
  final String imagePath;
  final String productName;
  final String color;
  int quantity;
  final double originalPrice;
  final double discountedPrice;
  bool isSelected;
  final String? userId; 

  CartItem({
    required this.productId,
    required this.imagePath,
    required this.productName,
    required this.color,
    required this.quantity,
    required this.originalPrice,
    required this.discountedPrice,
    this.userId,
    this.isSelected = false,
  });

  double get totalPrice => discountedPrice * quantity;

  // Chuyển đổi từ CartItem sang Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'imagePath': imagePath,
      'productName': productName,
      'color': color,
      'quantity': quantity,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'userId': userId,
      // Không lưu isSelected vì đây là trạng thái tạm thời trong UI
    };
  }

  // Tạo CartItem từ document Firestore
  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return CartItem(
      productId: data['productId'] ?? '',
      imagePath: data['imagePath'] ?? '',
      productName: data['productName'] ?? '',
      color: data['color'] ?? '',
      quantity: data['quantity'] ?? 1,
      originalPrice: (data['originalPrice'] ?? 0).toDouble(),
      discountedPrice: (data['discountedPrice'] ?? 0).toDouble(),
      userId: data['userId'],
      isSelected: false, // Mặc định là false khi tải từ Firestore
    );
  }

  // Tạo CartItem từ Map (dùng cho queries)
  factory CartItem.fromMap(Map<String, dynamic> data, {String? docId}) {
    return CartItem(
      productId: data['productId'] ?? '',
      imagePath: data['imagePath'] ?? '',
      productName: data['productName'] ?? '',
      color: data['color'] ?? '',
      quantity: data['quantity'] ?? 1,
      originalPrice: (data['originalPrice'] ?? 0).toDouble(),
      discountedPrice: (data['discountedPrice'] ?? 0).toDouble(),
      userId: data['userId'],
      isSelected: false, // Mặc định là false khi tải từ Firestore
    );
  }

  CartItem copyWith({
    String? productId,
    String? imagePath,
    String? productName,
    String? color,
    int? quantity,
    double? originalPrice,
    double? discountedPrice,
    String? userId,
    bool? isSelected,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      imagePath: imagePath ?? this.imagePath,
      productName: productName ?? this.productName,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
      originalPrice: originalPrice ?? this.originalPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      userId: userId ?? this.userId,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
