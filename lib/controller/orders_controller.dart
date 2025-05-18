
import 'dart:async';
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
  
  // Caching để tối ưu hiệu suất
  final Map<String, StreamController<List<OrderModel>>> _cachedStreams = {};
  final Map<String, List<OrderModel>> _cachedOrders = {};
  final Map<String, DateTime> _lastFetchTime = {};
  // Stream để lấy tất cả đơn hàng của người dùng với caching
  Stream<List<OrderModel>> getUserOrdersStream(String userId) {
    print('💾 getUserOrdersStream called for userId: $userId');
    final cacheKey = 'user_$userId';
    
    // Trả về stream đã cache nếu có
    if (_cachedStreams.containsKey(cacheKey)) {
      print('✅ Using cached stream for user orders: $userId');
      return _cachedStreams[cacheKey]!.stream;
    }
    
    // Tạo stream controller mới
    final controller = StreamController<List<OrderModel>>.broadcast();
    _cachedStreams[cacheKey] = controller;
    
    // Đăng ký snapshot listener
    _firestore
      .collection('orders')
      .where('userId', isEqualTo: userId)
      .orderBy('orderDate', descending: true)
      .snapshots()
      .listen((snapshot) {
        print('📦 Got ${snapshot.docs.length} user orders from Firestore');
        final orders = snapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .toList();
            
        // Cập nhật cache và thông báo cho listeners
        _cachedOrders[cacheKey] = orders;
        _lastFetchTime[cacheKey] = DateTime.now();
        controller.add(orders);
      }, onError: (error) {
        print('❌ Error in user orders stream: $error');
        controller.addError(error);
      });
      
    return controller.stream;
  }

  // Lấy đơn hàng theo ID với cache
  Future<OrderModel?> getOrderById(String orderId) async {
    print('🔍 Getting order details for ID: $orderId');
    
    // Kiểm tra trong cache trước
    for (final orders in _cachedOrders.values) {
      final cachedOrder = orders.firstWhere(
        (order) => order.id == orderId,
        orElse: () => OrderModel(
          id: '', 
          userId: '', 
          userName: '', 
          userPhone: '', 
          shippingAddress: '',
          orderDate: DateTime.now(), 
          status: '', 
          items: [], 
          subtotal: 0, 
          shippingFee: 0, 
          discount: 0,
          total: 0, 
          voucherDiscount: 0, 
          pointsDiscount: 0, 
          pointsUsed: 0,
          paymentMethod: '', 
          isPaid: false
        )
      );
      
      if (cachedOrder.id.isNotEmpty) {
        print('✅ Order found in cache');
        return cachedOrder;
      }
    }
    
    // Không tìm thấy trong cache, truy xuất từ Firestore
    print('⚡ Fetching order from Firestore');
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists) {
        return OrderModel.fromFirestore(doc);
      }
      print('❌ Order not found in Firestore');
      return null;
    } catch (e) {
      print('❌ Error getting order by ID: $e');
      return null;
    }
  }

  // Lấy đơn hàng theo trạng thái với cache
  Future<List<OrderModel>> getOrdersByStatus(String userId, String status) async {
    print('🔍 getOrdersByStatus: userId=$userId, status=$status');
    final cacheKey = 'user_${userId}_status_$status';
    
    // Kiểm tra cache
    if (_cachedOrders.containsKey(cacheKey) && 
        _lastFetchTime.containsKey(cacheKey) && 
        DateTime.now().difference(_lastFetchTime[cacheKey]!).inMinutes < 5) {
      print('✅ Using cached orders for status: $status');
      return _cachedOrders[cacheKey]!;
    }
    
    print('⚡ Fetching status orders from Firestore');
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: status)
          .orderBy('orderDate', descending: true)
          .get();
      
      final orders = snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
      
      // Cập nhật cache
      _cachedOrders[cacheKey] = orders;
      _lastFetchTime[cacheKey] = DateTime.now();
      
      print('📦 Cached ${orders.length} orders for status: $status');
      return orders;
    } catch (e) {
      print('❌ Error in getOrdersByStatus: $e');
      return [];
    }
  }
  
  // Stream để lấy đơn hàng theo trạng thái với caching và debug
  Stream<List<OrderModel>> getOrdersByStatusStream(String userId, String status) {
    print('💾 getOrdersByStatusStream: userId=$userId, status=$status');
    final cacheKey = 'user_${userId}_status_$status';
    
    // Trả về stream đã cache nếu có
    if (_cachedStreams.containsKey(cacheKey)) {
      print('✅ Using cached stream for status: $status');
      return _cachedStreams[cacheKey]!.stream;
    }
    
    // Tạo stream controller mới
    final controller = StreamController<List<OrderModel>>.broadcast();
    _cachedStreams[cacheKey] = controller;
    
    try {
      print('⚡ Creating new Firestore listener for status: $status');
      _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: status)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .listen((snapshot) {
          print('📦 Got ${snapshot.docs.length} orders for status: $status');
          final orders = snapshot.docs
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList();
              
          // Cập nhật cache và thông báo cho listeners
          _cachedOrders[cacheKey] = orders;
          _lastFetchTime[cacheKey] = DateTime.now();
          controller.add(orders);
        }, onError: (error) {
          print('❌ Error in status orders stream: $error');
          controller.addError(error);
        });
    } catch (e) {
      print('❌ Exception setting up status order stream: $e');
      controller.addError(e);
    }
    
    return controller.stream;
  }
  
  // Stream để lấy tất cả đơn hàng (cho tab tất cả) với caching và debug
  Stream<List<OrderModel>> getAllOrdersStream(String userId) {
    print('💾 getAllOrdersStream: userId=$userId');
    final cacheKey = 'user_${userId}_all';
    
    // Trả về stream đã cache nếu có
    if (_cachedStreams.containsKey(cacheKey)) {
      print('✅ Using cached stream for all orders');
      return _cachedStreams[cacheKey]!.stream;
    }
    
    // Tạo stream controller mới
    final controller = StreamController<List<OrderModel>>.broadcast();
    _cachedStreams[cacheKey] = controller;
    
    try {
      print('⚡ Creating new Firestore listener for all orders');
      _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .listen((snapshot) {
          print('📦 Got ${snapshot.docs.length} total orders');
          final orders = snapshot.docs
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList();
              
          // Cập nhật cache và thông báo cho listeners
          _cachedOrders[cacheKey] = orders;
          _lastFetchTime[cacheKey] = DateTime.now();
          controller.add(orders);
        }, onError: (error) {
          print('❌ Error in all orders stream: $error');
          controller.addError(error);
        });
    } catch (e) {
      print('❌ Exception setting up all orders stream: $e');
      controller.addError(e);
    }
    
    return controller.stream;
  }  // Chuyển đổi OrderModel sang Order cũ để hỗ trợ UI hiện tại
  // Được tối ưu để làm việc nhanh hơn
  List<Order> convertToLegacyOrders(List<OrderModel> orders) {
    print('🔄 Converting ${orders.length} OrderModel to legacy orders');
    return orders.map((order) {
      // Lấy sản phẩm đầu tiên trong đơn hàng để hiển thị
      final firstItem = order.items.isNotEmpty ? order.items[0] : null;
      
      return Order(
        imagePath: firstItem?.productImage ?? 'assets/images/default_product.png',
        productName: firstItem?.productName ?? 'Sản phẩm',
        color: firstItem?.color ?? '',
        quantity: firstItem?.quantity ?? 0,
        price: order.total, // Sử dụng tổng giá trị đơn hàng thay vì giá sản phẩm
        status: order.status,
      );
    }).toList();
  }
  
  // Giải phóng tài nguyên khi không cần nữa
  void dispose() {
    for (final controller in _cachedStreams.values) {
      controller.close();
    }
    _cachedStreams.clear();
    _cachedOrders.clear();
    _lastFetchTime.clear();
  }
}
