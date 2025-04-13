import 'package:flutter/material.dart';
import '../model/product.dart';

class CartItem {
  final String productId;
  final String imagePath;
  final String productName;
  final String color;
  int quantity;
  final double price;

  CartItem({
    required this.productId,
    required this.imagePath,
    required this.productName,
    required this.color,
    required this.quantity,
    required this.price,
  });
}

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

  // Get the total price of all items in the cart
  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Add item to cart
  void addItem(CartItem item) {
    // Check if the item is already in the cart
    final existingIndex = _items.indexWhere((i) => i.productId == item.productId && i.color == item.color);
    
    if (existingIndex >= 0) {
      // Update quantity if the item already exists
      _items[existingIndex].quantity += item.quantity;
    } else {
      // Add new item
      _items.add(item);
    }
    
    notifyListeners();
  }

  // Update item quantity
  void updateQuantity(String productId, String color, int quantity) {
    final index = _items.indexWhere((i) => i.productId == productId && i.color == color);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  // Remove item from cart
  void removeItem(String productId, String color) {
    _items.removeWhere((item) => item.productId == productId && item.color == color);
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
        imagePath: 'assets/images/_product_1.png',
        productName: 'Laptop ASUS Vivobook 14',
        color: 'Bạc',
        quantity: 2,
        price: 17390000,
      ),
    );
    
    addItem(
      CartItem(
        productId: '2',
        imagePath: 'assets/images/_product_1.png',
        productName: 'Chuột gaming Logitech G502',
        color: 'Đen',
        quantity: 2,
        price: 1290000,
      ),
    );
  }
}