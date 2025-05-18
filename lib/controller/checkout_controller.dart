// filepath: d:\HOCTAP\CrossplatformMobileApp\DOANCK\Project\Gear_Zone\lib\controller\checkout_controller.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/cart_item.dart';
import '../model/order.dart';

class CheckoutController extends ChangeNotifier {
  // Singleton pattern
  static final CheckoutController _instance = CheckoutController._internal();

  factory CheckoutController() {
    return _instance;
  }

  CheckoutController._internal();

  // Items being checked out
  List<CartItem> _items = [];

  // Shipping address
  String _address = '';
  // Payment method
  String _paymentMethod = 'Thanh toán khi nhận hàng';
  String _paymentIcon = '';
  int _paymentMethodIndex = 2; // Mặc định là thanh toán khi nhận hàng (index 2)
  // Shipping fee
  double _shippingFee = 30000.0;
  // Tax fee (sẽ được tính là 2% giá trị đơn hàng)
  double _taxFee = 0.0;

  // Discount from voucher
  double _discount = 0.0;

  // Reward points
  int _userPoints = 0; // Số điểm hiện có của người dùng
  bool _usePoints = false; // Trạng thái có sử dụng điểm hay không
  double _pointsDiscount = 0.0; // Giá trị tiền được giảm từ điểm

  // Voucher information
  String? _voucherId;
  String _voucherCode = '';
  double _voucherDiscount = 0.0;

  // Getters
  List<CartItem> get items => _items;
  String get address => _address;
  String get paymentMethod => _paymentMethod;
  String get paymentIcon => _paymentIcon;
  int get paymentMethodIndex => _paymentMethodIndex;
  double get shippingFee => _shippingFee;
  double get taxFee => subtotalPrice * 0.02; // Tính thuế 2% từ tổng giá trị
  double get discount => _discount;
  String? get voucherId => _voucherId;
  String get voucherCode => _voucherCode;
  double get voucherDiscount => _voucherDiscount;
  // Getters for reward points
  int get userPoints => _userPoints;
  bool get usePoints => _usePoints;
  double get pointsDiscount => _pointsDiscount;

  // Get the subtotal price (before additional fees and discounts)
  double get subtotalPrice {
    return _items.fold(
        0, (sum, item) => sum + (item.discountedPrice * item.quantity));
  }

  // Get the final total price
  double get totalPrice {
    // Tính toán trực tiếp từ từng thành phần thay vì dùng _discount tổng
    return subtotalPrice +
        _shippingFee +
        _taxFee -
        _voucherDiscount -
        _pointsDiscount;
  }

  // Set items to be checked out
  void setItems(List<CartItem> items) {
    _items = items;
    notifyListeners();
  }

  // Update shipping address
  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  // Update payment method
  void setPaymentMethod(String method, String icon, int index) {
    _paymentMethod = method;
    _paymentIcon = icon;
    _paymentMethodIndex = index;
    notifyListeners();
  }

  // Apply voucher and update discount
  void applyVoucher({String? voucherId, String? code, double? discount}) {
    if (voucherId != null) {
      _voucherId = voucherId;
    }
    if (code != null) {
      _voucherCode = code;
    }
    if (discount != null) {
      _voucherDiscount = discount;
      _updateTotalDiscount(); // Update the total discount amount
    }
    notifyListeners();
  }

  // Remove applied voucher
  void removeVoucher() {
    _voucherId = null;
    _voucherCode = '';
    _voucherDiscount = 0.0;
    _updateTotalDiscount(); // Reset discount với cập nhật tổng
    notifyListeners();
  }

  // Update total discount (from voucher and points)
  void _updateTotalDiscount() {
    // Vẫn giữ _discount là tổng của cả hai loại giảm giá
    _discount = _voucherDiscount;
    if (_usePoints) {
      _calculatePointsDiscount();
      _discount += _pointsDiscount;
    }
  }

  // Set user's loyalty points
  void setUserPoints(int points) {
    _userPoints = points;
    if (_usePoints) {
      _calculatePointsDiscount();
    }
    notifyListeners();
  }

  // Toggle using points
  void toggleUsePoints(bool value) {
    _usePoints = value;
    _calculatePointsDiscount();
    _updateTotalDiscount();
    notifyListeners();
  }

  // Calculate discount from points
  void _calculatePointsDiscount() {
    if (_usePoints && _userPoints > 0) {
      // 1 điểm = 1000 VND
      _pointsDiscount = _userPoints * 1000.0;

      // Đảm bảo discount từ điểm không vượt quá tổng tiền hàng
      // Trừ voucher discount để tránh trường hợp giảm giá âm
      double maxDiscount = subtotalPrice - _voucherDiscount;
      if (_pointsDiscount > maxDiscount) {
        _pointsDiscount = maxDiscount;
      }
    } else {
      _pointsDiscount = 0.0;
    }
  }

  // Tính điểm sẽ tích được từ đơn hàng (10% giá trị)
  int get pointsToEarn {
    return (totalPrice / 10000)
        .floor(); // 10% giá trị đơn hàng (1 điểm = 1000 VND)
  }

  // Complete the checkout process
  Future<String?> completeCheckout() async {
    try {
      // Get the FirebaseFirestore instance
      final firestore = FirebaseFirestore.instance;

      // Get the current user information from FirebaseAuth
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return null;
      }

      // Get user document to retrieve user data
      final userDoc =
          await firestore.collection('users').doc(currentUser.uid).get();
      final userData = userDoc.data();
      if (userData == null) {
        return null;
      }

      // Get the user's default address
      String shippingAddress = '';
      if (userData.containsKey('addressList') &&
          userData['addressList'] is List &&
          userData['addressList'].isNotEmpty) {
        for (var address in userData['addressList']) {
          if (address['isDefault'] == true) {
            // Construct full address
            final name = address['name'] ?? '';
            final phoneNumber = address['phoneNumber'] ?? '';
            final addressText = address['fullAddress'] ?? '';
            shippingAddress = '$name, $phoneNumber, $addressText';
            break;
          }
        }
      }

      if (shippingAddress.isEmpty) {
        return null; // Cannot proceed without shipping address
      }

      // Create order items from cart items
      final List<OrderItem> orderItems = _items
          .map((item) => OrderItem(
                productId: item.productId,
                productName: item.productName,
                productImage: item.imagePath,
                quantity: item.quantity,
                price: item.discountedPrice,
                color: item.color,
                size: null, // Add size if your app supports it
              ))
          .toList();

      // Generate a unique order ID
      final String orderId = firestore.collection('orders').doc().id;

      // Create the order model
      final OrderModel order = OrderModel(
        id: orderId,
        userId: currentUser.uid,
        userName: userData['name'] ?? '',
        userPhone: userData['phoneNumber'] ?? '',
        shippingAddress: shippingAddress,
        orderDate: DateTime.now(),
        status: 'Chờ xử lý',
        items: orderItems,
        subtotal: subtotalPrice,
        shippingFee: _shippingFee,
        discount: _voucherDiscount + _pointsDiscount,
        total: totalPrice,
        voucherId: _voucherId,
        paymentMethod: _paymentMethod,
        isPaid: _paymentMethodIndex != 2, // Not COD means already paid
        note: '',
      );

      // Save order to Firestore
      await firestore.collection('orders').doc(orderId).set(order.toMap());

      // Update user's used vouchers if a voucher was applied
      if (_voucherId != null) {
        await firestore.collection('users').doc(currentUser.uid).update({
          'usedVouchers': FieldValue.arrayUnion([_voucherId]),
        });
      }
      // Update user's loyalty points if points were used
      if (_usePoints && _pointsDiscount > 0) {
        // Use all available points
        await firestore.collection('users').doc(currentUser.uid).update({
          'loyaltyPoints':
              0, // Reset points to zero since we're using all points
        });

        // Add points transaction record
        await firestore.collection('pointTransactions').add({
          'userId': currentUser.uid,
          'amount': -_userPoints,
          'reason': 'Sử dụng để giảm giá đơn hàng #$orderId',
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      // Add loyalty points for the new purchase (10% of total)
      int pointsEarned = (totalPrice / 10000).floor(); // 10% of order value
      if (pointsEarned > 0) {
        await firestore.collection('users').doc(currentUser.uid).update({
          'loyaltyPoints': FieldValue.increment(pointsEarned),
        });

        // Add points transaction record
        await firestore.collection('pointTransactions').add({
          'userId': currentUser.uid,
          'amount': pointsEarned,
          'reason': 'Tích lũy từ đơn hàng #$orderId',
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      // Clear checkout items after successful checkout
      _items = [];
      notifyListeners();

      // Return the order ID for reference
      return orderId;
    } catch (e) {
      print('Error during checkout: $e');
      return null;
    }
  }
}
