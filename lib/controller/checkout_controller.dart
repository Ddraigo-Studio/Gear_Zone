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

  // Guest information
  String _guestName = '';
  String _guestAddress = '';
  String _guestPhone = '';
  String _guestEmail = '';

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
  int get userPoints => FirebaseAuth.instance.currentUser != null ? _userPoints : 0;
  bool get usePoints => _usePoints;
  double get pointsDiscount => _pointsDiscount;
  // Getters for guest information
  String get guestName => _guestName;
  String get guestAddress => _guestAddress;
  String get guestPhone => _guestPhone;
  String get guestEmail => _guestEmail;

  // Get the subtotal price (before additional fees and discounts)
  double get subtotalPrice {
    return _items.fold(
        0, (sum, item) => sum + (item.discountedPrice * item.quantity));
  }

  // Get the final total price
  double get totalPrice {
    return subtotalPrice +
        _shippingFee +
        taxFee -
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

  // Set guest information
  void setGuestInfo({
    String? name,
    String? address,
    String? phone,
    String? email,
  }) {
    if (name != null) _guestName = name;
    if (address != null) _guestAddress = address;
    if (phone != null) _guestPhone = phone;
    if (email != null) _guestEmail = email;
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
      _updateTotalDiscount();
    }
    notifyListeners();
  }

  // Remove applied voucher
  void removeVoucher() {
    _voucherId = null;
    _voucherCode = '';
    _voucherDiscount = 0.0;
    _updateTotalDiscount();
    notifyListeners();
  }

  // Update total discount (from voucher and points)
  void _updateTotalDiscount() {
    _discount = _voucherDiscount;
    if (_usePoints) {
      _calculatePointsDiscount();
      _discount += _pointsDiscount;
    }
  }

  void toggleUsePoints(bool value) {
  if (FirebaseAuth.instance.currentUser == null) {
    _usePoints = false; // Khách vãng lai không dùng điểm
    _pointsDiscount = 0.0;
    notifyListeners();
    return;
  }
  _usePoints = value;
  _calculatePointsDiscount();
  _updateTotalDiscount();
  notifyListeners();
}

void setUserPoints(int points) {
  if (FirebaseAuth.instance.currentUser == null) {
    _userPoints = 0; // Khách vãng lai không có điểm
    _pointsDiscount = 0.0;
    notifyListeners();
    return;
  }
  _userPoints = points;
  if (_usePoints) {
    _calculatePointsDiscount();
  }
  notifyListeners();
}

  // Calculate discount from points
  void _calculatePointsDiscount() {
    if (_usePoints && _userPoints > 0 && FirebaseAuth.instance.currentUser != null) {
      _pointsDiscount = _userPoints * 1000.0;
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
    if (FirebaseAuth.instance.currentUser == null) {
      return 0; // Guests don't earn points
    }
    return (totalPrice / 10000).floor();
  }

  Future<String?> completeCheckout() async {
  try {
    final firestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;

    String shippingAddress;
    String userName;
    String userPhone;

    if (currentUser == null) {
      // Guest checkout
      if (_guestName.isEmpty ||
          _guestAddress.isEmpty ||
          _guestPhone.isEmpty ||
          _guestEmail.isEmpty) {
        print('Thông tin khách hàng không đầy đủ');
        return null; // Trả về null nếu thông tin không đầy đủ
      }
      userName = _guestName;
      userPhone = _guestPhone;
      shippingAddress = '$_guestName, $_guestPhone, $_guestAddress';
    } else {
      // Logged-in user
      final userDoc = await firestore.collection('users').doc(currentUser.uid).get();
      final userData = userDoc.data();
      if (userData == null) {
        print('Không tìm thấy dữ liệu người dùng');
        return null;
      }

      userName = userData['name'] ?? '';
      userPhone = userData['phoneNumber'] ?? '';
      shippingAddress = ''; // Khởi tạo mặc định

      if (userData.containsKey('addressList') &&
          userData['addressList'] is List &&
          userData['addressList'].isNotEmpty) {
        for (var address in userData['addressList']) {
          if (address['isDefault'] == true) {
            final name = address['name'] ?? '';
            final phoneNumber = address['phoneNumber'] ?? '';
            final addressText = address['fullAddress'] ?? '';
            shippingAddress = '$name, $phoneNumber, $addressText';
            break;
          }
        }
      }

      if (shippingAddress.isEmpty) {
        print('Không tìm thấy địa chỉ mặc định');
        return null;
      }
    }

    // Tạo danh sách OrderItem từ CartItem
    final List<OrderItem> orderItems = _items
        .map((item) => OrderItem(
              productId: item.productId,
              productName: item.productName,
              productImage: item.imagePath,
              quantity: item.quantity,
              price: item.discountedPrice,
              color: item.color,
              size: null,
            ))
        .toList();

    // Tạo ID đơn hàng
    final String orderId = firestore.collection('orders').doc().id;

    // Tạo OrderModel
    final OrderModel order = OrderModel(
      id: orderId,
      userId: currentUser?.uid ?? '', // Để trống userId cho khách vãng lai
      userName: userName,
      userPhone: userPhone,
      shippingAddress: shippingAddress,
      orderDate: DateTime.now(),
      status: 'Chờ xử lý',
      items: orderItems,
      subtotal: subtotalPrice,
      shippingFee: _shippingFee,
      discount: _voucherDiscount + _pointsDiscount,
      total: totalPrice,
      voucherId: _voucherId,
      voucherCode: _voucherCode,
      voucherDiscount: _voucherDiscount,
      pointsDiscount: 0.0, // Khách vãng lai không dùng điểm
      pointsUsed: 0, // Khách vãng lai không dùng điểm
      paymentMethod: _paymentMethod,
      isPaid: _paymentMethodIndex != 2,
      note: '',
    );

    // Lưu đơn hàng vào Firestore
    await firestore.collection('orders').doc(orderId).set(order.toMap());

    // Chỉ cập nhật dữ liệu cho người dùng đã đăng nhập
    if (currentUser != null) {
      // Cập nhật voucher đã sử dụng
      if (_voucherId != null) {
        await firestore.collection('users').doc(currentUser.uid).update({
          'usedVouchers': FieldValue.arrayUnion([_voucherId]),
        });
      }

      // Cập nhật điểm tích lũy nếu sử dụng
      if (_usePoints && _pointsDiscount > 0) {
        await firestore.collection('users').doc(currentUser.uid).update({
          'loyaltyPoints': 0,
        });

        await firestore.collection('pointTransactions').add({
          'userId': currentUser.uid,
          'amount': -_userPoints,
          'reason': 'Sử dụng để giảm giá đơn hàng #$orderId',
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      // Thêm điểm tích lũy từ đơn hàng
      int pointsEarned = (totalPrice / 10000).floor();
      if (pointsEarned > 0) {
        await firestore.collection('users').doc(currentUser.uid).update({
          'loyaltyPoints': FieldValue.increment(pointsEarned),
        });

        await firestore.collection('pointTransactions').add({
          'userId': currentUser.uid,
          'amount': pointsEarned,
          'reason': 'Tích lũy từ đơn hàng #$orderId',
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    }

    // Xóa dữ liệu sau khi đặt hàng thành công
    _items = [];
    _guestName = '';
    _guestAddress = '';
    _guestPhone = '';
    _guestEmail = '';
    _voucherId = null;
    _voucherCode = '';
    _voucherDiscount = 0.0;
    notifyListeners();

    return orderId;
} catch (e) {
    print('Lỗi khi thanh toán: $e');
    return null;
  }
}
}