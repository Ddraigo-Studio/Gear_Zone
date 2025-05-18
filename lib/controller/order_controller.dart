import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gear_zone/model/order.dart';

class OrderController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'orders';

  // Lấy tất cả đơn hàng
  Stream<List<OrderModel>> getOrders() {
    return _firestore
        .collection(_collection)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList());
  }
  // Lấy đơn hàng theo userId
  Stream<List<OrderModel>> getOrdersByUserId(String userId) {
    try {
      return _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          // Remove the orderBy to avoid needing a composite index
          .snapshots()
          .map((snapshot) {
            // Sort client-side instead
            List<OrderModel> orders = snapshot.docs
                .map((doc) => OrderModel.fromFirestore(doc))
                .toList();
            // Sort by orderDate in descending order
            orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
            return orders;
          });
    } catch (e) {
      print('Error getting orders by userId: $e');
      // Return empty list on error
      return Stream.value([]);
    }
  }

  // Lấy đơn hàng theo ID
  Future<OrderModel?> getOrderById(String id) async {
    DocumentSnapshot doc = await _firestore.collection(_collection).doc(id).get();
    if (doc.exists) {
      return OrderModel.fromFirestore(doc);
    }
    return null;
  }
  // Lấy đơn hàng theo trạng thái
  Stream<List<OrderModel>> getOrdersByStatus(String status) {
    // Bỏ orderBy để tránh cần composite index
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) {
          // Sắp xếp dữ liệu phía client thay vì server
          List<OrderModel> orders = snapshot.docs
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList();
          // Sắp xếp theo orderDate giảm dần
          orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
          return orders;
        });
  }

  // Cập nhật trạng thái đơn hàng
  Future<void> updateOrderStatus(String id, String status) async {
    try {
      await _firestore.collection(_collection).doc(id).update({'status': status});
    } catch (e) {
      print('Error updating order status: $e');
      throw e;
    }
  }

  // Cập nhật trạng thái thanh toán
  Future<void> updatePaymentStatus(String id, bool isPaid) async {
    try {
      await _firestore.collection(_collection).doc(id).update({'isPaid': isPaid});
    } catch (e) {
      print('Error updating payment status: $e');
      throw e;
    }
  }

  // Cập nhật toàn bộ đơn hàng
  Future<void> updateOrder(OrderModel order) async {
    try {
      await _firestore.collection(_collection).doc(order.id).update(order.toMap());
    } catch (e) {
      print('Error updating order: $e');
      throw e;
    }
  }

  // Đếm tổng số đơn hàng
  Future<int> getOrdersCount() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error counting orders: $e');
      return 0;
    }
  }

  // Đếm số đơn hàng theo trạng thái
  Future<int> getOrdersCountByStatus(String status) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: status)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error counting orders by status: $e');
      return 0;
    }
  }
}
