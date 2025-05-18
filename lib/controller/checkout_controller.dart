// filepath: d:\HOCTAP\CrossplatformMobileApp\DOANCK\Project\Gear_Zone\lib\controller\checkout_controller.dart
import 'package:flutter/foundation.dart';
import '../model/cart_item.dart';

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
    return subtotalPrice + _shippingFee + _taxFee - _voucherDiscount - _pointsDiscount;
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


  // Complete the checkout process
  Future<bool> completeCheckout() async {
    // Placeholder for API call to create order
    try {
      // Simulate a network call
      await Future.delayed(Duration(seconds: 1));

      // Clear checkout items after successful checkout
      _items = [];
      notifyListeners();
      return true;
    } catch (e) {
      print('Error during checkout: $e');
      return false;
    }
  }
}
