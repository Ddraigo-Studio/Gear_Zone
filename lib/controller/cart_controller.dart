import 'package:flutter/material.dart';
import '../model/Cart.dart';

class CartController extends ChangeNotifier {
  // Singleton pattern
  static final CartController _instance = CartController._internal();

  factory CartController() {
    return _instance;
  }

  CartController._internal();

  // List of items in the cart
  final List<CartItem> _items = [];

  // Get all items in the cart
  List<CartItem> get items => _items;

  // Get the total number of items in the cart
  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Get the subtotal price (before discount)
  double get subtotalPrice {
    return _items.fold(0, (sum, item) => sum + (item.originalPrice * item.quantity));
  }

  // Get the total discount amount
  double get totalDiscount {
    return _items.fold(0, (sum, item) => 
      sum + ((item.originalPrice - item.discountedPrice) * item.quantity));
  }

  // Get the final total price (after discount)
  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + (item.discountedPrice * item.quantity));
  }

  // Add item to cart
  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere(
      (i) => i.productId == item.productId && i.color == item.color
    );
    
    if (existingIndex >= 0) {
      // Update quantity if the item already exists
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + item.quantity
      );
    } else {
      // Add new item
      _items.add(item);
    }
    
    notifyListeners();
  }

  // Update item quantity
  void updateQuantity(String productId, String color, int quantity) {
    if (quantity <= 0) {
      removeItem(productId, color);
      return;
    }

    final index = _items.indexWhere(
      (i) => i.productId == productId && i.color == color
    );
    
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  // Remove item from cart
  void removeItem(String productId, String color) {
    _items.removeWhere(
      (item) => item.productId == productId && item.color == color
    );
    notifyListeners();
  }

  // Clear cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
  
  // For demo purposes: add sample items to the cart
  void addSampleItems() {
    addItem(
      CartItem(
        productId: '1',
        imagePath: 'assets/images/img_product_detail.png',
        productName: 'Laptop ASUS Vivobook 14 OLED A1405VA KM095W',
        color: 'Bạc',
        quantity: 1,
        originalPrice: 20990000,
        discountedPrice: 17390000,
      ),
    );
    
    addItem(
      CartItem(
        productId: '2',
        imagePath: 'assets/images/img_product_detail_2.png',
        productName: 'Chuột gaming Logitech G502 HERO',
        color: 'Đen',
        quantity: 1,
        originalPrice: 1790000,
        discountedPrice: 1290000,
      ),
    );
  }
}