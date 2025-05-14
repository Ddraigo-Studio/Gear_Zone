import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

class CartModel {
  final String? userId;                // Dùng làm document ID (có thể null cho khách hàng chưa đăng nhập)
  final List<CartItem> items;   

  CartModel({
    this.userId,
    this.items = const [],
  });  factory CartModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String docId = doc.id;
    
    return CartModel(
      userId: docId,
      items: data['items'] != null
          ? (data['items'] as List)
              .map((e) => CartItem.fromMap(Map<String, dynamic>.from(e)))
              .toList()
          : [],
    );
  }

  factory CartModel.fromMap(Map<String, dynamic> data, {String? docId}) {
    return CartModel(
      userId: docId,
      items: data['items'] != null
          ? (data['items'] as List)
              .map((e) => CartItem.fromMap(Map<String, dynamic>.from(e)))
              .toList()
          : [],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'items': items.map((i) => i.toMap()).toList(),
    };
  }

  CartModel copyWith({
    String? userId,
    List<CartItem>? items,
  }) {
    return CartModel(
      userId: userId ?? this.userId,
      items: items ?? this.items,
    );
  }
}
