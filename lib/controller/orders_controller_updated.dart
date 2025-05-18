import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../model/order.dart';

class OrdersController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Các trạng thái đơn hàng trong hệ thống
  static const String STATUS_PENDING = 'Chờ xử lý';
  static const String STATUS_SHIPPING = 'Đang giao';
  static const String STATUS_COMPLETED = 'Đã nhận';
  static const String STATUS_RETURNED = 'Trả hàng';
  static const String STATUS_CANCELLED = 'Đã hủy';

  // Danh sách tất cả các trạng thái
  static const List<String> ALL_STATUSES = [
    STATUS_PENDING,
    STATUS_SHIPPING,
    STATUS_COMPLETED,
    STATUS_RETURNED,
    STATUS_CANCELLED,
  ];

  // Stream để lấy tất cả đơn hàng của người dùng
  Stream<List<OrderModel>> getUserOrdersStream(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    });
  }

  // Lấy đơn hàng theo ID
  Future<OrderModel?> getOrderById(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    if (doc.exists) {
      return OrderModel.fromFirestore(doc);
    }
    return null;
  }

  // Lấy đơn hàng theo trạng thái
  Future<List<OrderModel>> getOrdersByStatus(
      String userId, String status) async {
    final snapshot = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: status)
        .orderBy('orderDate', descending: true)
        .get();

    return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
  }

  // Stream để lấy đơn hàng theo trạng thái
  Stream<List<OrderModel>> getOrdersByStatusStream(
      String userId, String status) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: status)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    });
  }

  // Stream để lấy tất cả đơn hàng (cho tab tất cả)
  Stream<List<OrderModel>> getAllOrdersStream(String userId) {
    return getUserOrdersStream(userId);
  }

  // Chuyển đổi OrderModel sang Order cũ để hỗ trợ UI hiện tại
  List<Order> convertToLegacyOrders(List<OrderModel> orders) {
    return orders.map((order) {
      // Lấy sản phẩm đầu tiên trong đơn hàng để hiển thị
      final firstItem = order.items.isNotEmpty ? order.items[0] : null;

      return Order(
        imagePath:
            firstItem?.productImage ?? 'assets/images/default_product.png',
        productName: firstItem?.productName ?? 'Sản phẩm',
        color: firstItem?.color ?? '',
        quantity: firstItem?.quantity ?? 0,
        price:
            order.total, // Sử dụng tổng giá trị đơn hàng thay vì giá sản phẩm
        status: order.status,
      );
    }).toList();
  }
}
