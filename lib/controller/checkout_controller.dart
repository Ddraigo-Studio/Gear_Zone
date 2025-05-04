import 'package:flutter/foundation.dart';
import '../model/cart.dart';

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
  
  // Shipping fee
  double _shippingFee = 8000.0;
  
  // Tax fee
  double _taxFee = 10000.0;
  
  // Discount from voucher
  double _discount = 8000.0;

  // Getters
  List<CartItem> get items => _items;
  String get address => _address;
  String get paymentMethod => _paymentMethod;
  double get shippingFee => _shippingFee;
  double get taxFee => _taxFee;
  double get discount => _discount;
  
  // Get the subtotal price (before additional fees and discounts)
  double get subtotalPrice {
    return _items.fold(0, (sum, item) => sum + (item.discountedPrice * item.quantity));
  }
  
  // Get the final total price
  double get totalPrice {
    return subtotalPrice + _shippingFee + _taxFee - _discount;
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
  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
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