import 'package:flutter/material.dart';
import '../model/order.dart';

class OrdersController {
  // Danh sách đơn hàng mẫu (demo)
  final List<Order> allOrders = [
    // Order(
    //   imagePath: 'assets/images/_product_1.png',
    //   productName: 'Case PC',
    //   color: 'Xanh',
    //   quantity: 1,
    //   price: 24.0,
    //   status: 'Chờ xử lý',
    // ),
    Order(
      imagePath: 'assets/images/_product_1.png',
      productName: 'Bag',
      color: 'Berawn',
      quantity: 1,
      price: 24.0,
      status: 'Đang giao',
    ),
    Order(
      imagePath: 'assets/images/_product_1.png',
      productName: 'Bag',
      color: 'Berawn',
      quantity: 1,
      price: 24.0,
      status: 'Đã nhận',
    ),
    Order(
      imagePath: 'assets/images/_product_1.png',
      productName: 'Bag',
      color: 'Berawn',
      quantity: 1,
      price: 24.0,
      status: 'Trả hàng',
    ),
    Order(
      imagePath: 'assets/images/_product_1.png',
      productName: 'Bag',
      color: 'Berawn',
      quantity: 1,
      price: 24.0,
      status: 'Đã hủy',
    ),
  ];

  /// Lọc đơn hàng theo status
  List<Order> getOrdersByStatus(String status) {
    return allOrders.where((order) => order.status == status).toList();
  }
}
