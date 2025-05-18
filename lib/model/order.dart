import 'package:cloud_firestore/cloud_firestore.dart';

// Simple Order class for UI display purposes (legacy support)
class Order {
  final String imagePath;
  final String productName;
  final String color;
  final int quantity;
  final double price;
  final String status;

  Order({
    required this.imagePath,
    required this.productName,
    required this.color,
    required this.quantity,
    required this.price,
    required this.status,
  });
}

// Enhanced OrderModel for Firestore and full order management
class OrderModel {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final String shippingAddress;
  final DateTime orderDate;
  final String status;
  final List<OrderItem> items;
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double total;
  final String? voucherId;
  final String? voucherCode; // Added field for voucher code
  final double voucherDiscount; // Added field for voucher discount
  final double pointsDiscount; // Added field for loyalty points discount
  final int pointsUsed; // Added field for loyalty points used
  final String paymentMethod;
  final bool isPaid;
  final String? note;
  OrderModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.shippingAddress,
    required this.orderDate,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
    this.voucherId,
    this.voucherCode,
    this.voucherDiscount = 0.0,
    this.pointsDiscount = 0.0,
    this.pointsUsed = 0,
    required this.paymentMethod,
    required this.isPaid,
    this.note,
  });
  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'shippingAddress': shippingAddress,
      'orderDate': Timestamp.fromDate(orderDate),
      'status': status,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'discount': discount,
      'total': total,
      'voucherId': voucherId,
      'voucherCode': voucherCode,
      'voucherDiscount': voucherDiscount,
      'pointsDiscount': pointsDiscount,
      'pointsUsed': pointsUsed,
      'paymentMethod': paymentMethod,
      'isPaid': isPaid,
      'note': note,
    };
  }

  // Create from Firestore document
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userPhone: data['userPhone'] ?? '',
      shippingAddress: data['shippingAddress'] ?? '',
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      status: data['status'] ?? 'Chờ xử lý',
      items: (data['items'] as List)
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      subtotal: (data['subtotal'] ?? 0).toDouble(),
      shippingFee: (data['shippingFee'] ?? 0).toDouble(),
      discount: (data['discount'] ?? 0).toDouble(),
      total: (data['total'] ?? 0).toDouble(),
      voucherId: data['voucherId'],
      voucherCode: data['voucherCode'],
      voucherDiscount: (data['voucherDiscount'] ?? 0).toDouble(),
      pointsDiscount: (data['pointsDiscount'] ?? 0).toDouble(),
      pointsUsed: (data['pointsUsed'] ?? 0) as int,
      paymentMethod: data['paymentMethod'] ?? 'COD',
      isPaid: data['isPaid'] ?? false,
      note: data['note'],
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String? productImage;
  final int quantity;
  final double price;
  final String? color;
  final String? size;

  OrderItem({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.quantity,
    required this.price,
    this.color,
    this.size,
  });

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'quantity': quantity,
      'price': price,
      'color': color,
      'size': size,
    };
  }

  // Create from map
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'],
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      color: map['color'],
      size: map['size'],
    );
  }
}
