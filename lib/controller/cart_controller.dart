import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/cart.dart';
import '../model/cart_item.dart';

class CartController extends ChangeNotifier {
  // Singleton pattern
  static final CartController _instance = CartController._internal();

  factory CartController() {
    return _instance;
  }

  CartController._internal();

  // Model giỏ hàng
  CartModel? _cartModel;

  // Khởi tạo giỏ hàng
  void initCart(String? userId) {
    _cartModel = CartModel(userId: userId, items: []);
    notifyListeners();
  }

  // Lấy model giỏ hàng
  CartModel? get cart => _cartModel;

  // Lấy danh sách sản phẩm trong giỏ hàng
  List<CartItem> get items => _cartModel?.items ?? [];

  // Lấy tổng số sản phẩm trong giỏ hàng
  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Lấy tổng giá gốc (trước giảm giá)
  double get subtotalPrice {
    return items.fold(0, (sum, item) => sum + (item.originalPrice * item.quantity));
  }

  // Lấy tổng số tiền giảm giá
  double get totalDiscount {
    return items.fold(0, (sum, item) => 
      sum + ((item.originalPrice - item.discountedPrice) * item.quantity));
  }

  // Lấy tổng giá cuối cùng (sau giảm giá)
  double get totalPrice {
    return items.fold(0, (sum, item) => sum + (item.discountedPrice * item.quantity));
  }

  // Lấy tổng giá của các sản phẩm đã chọn
  double get selectedItemsPrice {
    return items
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + (item.discountedPrice * item.quantity));
  }

  // Lấy số lượng sản phẩm đã chọn
  int get selectedItemCount {
    return items.where((item) => item.isSelected).length;
  }

  // Lấy danh sách sản phẩm đã chọn
  List<CartItem> getSelectedItems() {
    return items.where((item) => item.isSelected).toList();
  }

  // Kiểm tra xem tất cả sản phẩm có được chọn hay không
  bool get allItemsSelected {
    if (items.isEmpty) return false;
    return items.every((item) => item.isSelected);
  }

  // Chuyển đổi trạng thái chọn của một sản phẩm
  void toggleItemSelection(String productId, String color, bool isSelected) {
    if (_cartModel == null) return;
    
    final index = _cartModel!.items.indexWhere(
      (i) => i.productId == productId && i.color == color
    );
    
    if (index >= 0) {
      final updatedItem = _cartModel!.items[index].copyWith(isSelected: isSelected);
      final updatedItems = List<CartItem>.from(_cartModel!.items);
      updatedItems[index] = updatedItem;
      
      _cartModel = _cartModel!.copyWith(items: updatedItems);
      notifyListeners();
    }
  }

  // Chọn tất cả sản phẩm
  void selectAllItems(bool isSelected) {
    if (_cartModel == null) return;
    
    final updatedItems = _cartModel!.items.map((item) => 
      item.copyWith(isSelected: isSelected)).toList();
    
    _cartModel = _cartModel!.copyWith(items: updatedItems);
    notifyListeners();
  }
  // Thêm sản phẩm vào giỏ hàng
  Future<void> addItem(CartItem item) async {
    if (_cartModel == null) {
      initCart(item.userId);
    }
    
    final existingIndex = _cartModel!.items.indexWhere(
      (i) => i.productId == item.productId && i.color == item.color
    );
    
    List<CartItem> updatedItems = List<CartItem>.from(_cartModel!.items);
    
    if (existingIndex >= 0) {
      // Cập nhật số lượng nếu sản phẩm đã tồn tại
      final existingItem = _cartModel!.items[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity
      );
    } else {
      // Thêm sản phẩm mới
      updatedItems.add(item);
    }
    
    _cartModel = _cartModel!.copyWith(items: updatedItems);
    notifyListeners();
    
    // Tự động lưu các thay đổi
    await _saveCartChanges();
  }

  // Cập nhật số lượng sản phẩm
  Future<void> updateQuantity(String productId, String color, int quantity) async {
    if (_cartModel == null) return;
    
    final index = _cartModel!.items.indexWhere(
      (i) => i.productId == productId && i.color == color
    );
    
    if (index >= 0) {
      List<CartItem> updatedItems = List<CartItem>.from(_cartModel!.items);
      updatedItems[index] = _cartModel!.items[index].copyWith(quantity: quantity);
      
      _cartModel = _cartModel!.copyWith(items: updatedItems);
      notifyListeners();
      
      // Tự động lưu các thay đổi
      await _saveCartChanges();
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  Future<void> removeItem(String productId, String color) async {
    if (_cartModel == null) return;
    
    final updatedItems = _cartModel!.items.where(
      (i) => !(i.productId == productId && i.color == color)
    ).toList();
    
    _cartModel = _cartModel!.copyWith(items: updatedItems);
    notifyListeners();
    
    // Tự động lưu các thay đổi
    await _saveCartChanges();
  }

  // Xóa các sản phẩm đã chọn
  Future<void> removeSelectedItems() async {
    if (_cartModel == null) return;
    
    final updatedItems = _cartModel!.items.where(
      (item) => !item.isSelected
    ).toList();
    
    _cartModel = _cartModel!.copyWith(items: updatedItems);
    notifyListeners();
    
    // Tự động lưu các thay đổi
    await _saveCartChanges();
  }

  // Phương thức nội bộ để tự động lưu các thay đổi giỏ hàng
  Future<void> _saveCartChanges() async {
    if (_cartModel == null) return;
    
    // Nếu có userId (đã đăng nhập), lưu vào Firestore
    if (_cartModel!.userId != null && _cartModel!.userId!.isNotEmpty) {
      await saveCartToFirestore();
    } 
    // Nếu không có userId (khách vãng lai), lưu vào local storage
    else {
      await saveCartToLocalStorage();
    }
  }
  // Xóa toàn bộ giỏ hàng
  void clearCart() {
    if (_cartModel != null) {
      _cartModel = _cartModel!.copyWith(items: []);
      notifyListeners();
    }
  }

  // Hằng số cho key lưu trữ local
  static const String _guestCartKey = 'guest_cart';
  
  // Lưu giỏ hàng vào local storage (dành cho khách)
  Future<bool> saveCartToLocalStorage() async {
    try {
      if (_cartModel == null) {
        print('Cannot save cart to local storage: cart is null');
        return false;
      }
      
      final prefs = await SharedPreferences.getInstance();
      final cartJson = jsonEncode(_cartModel!.toMap());
      
      await prefs.setString(_guestCartKey, cartJson);
      print('Cart saved to local storage');
      return true;
    } catch (e) {
      print('Error saving cart to local storage: $e');
      return false;
    }
  }
  
  // Tải giỏ hàng từ local storage (dành cho khách)
  Future<bool> loadCartFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_guestCartKey);
      
      if (cartJson != null && cartJson.isNotEmpty) {
        final cartData = jsonDecode(cartJson) as Map<String, dynamic>;
        _cartModel = CartModel.fromMap(cartData);
        notifyListeners();
        print('Cart loaded from local storage');
        return true;
      }
      
      print('No cart found in local storage');
      return false;
    } catch (e) {
      print('Error loading cart from local storage: $e');
      return false;
    }
  }
  
  // Xóa giỏ hàng trong local storage
  Future<bool> clearLocalCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_guestCartKey);
      print('Local cart cleared');
      return true;
    } catch (e) {
      print('Error clearing local cart: $e');
      return false;
    }
  }
  // Lưu giỏ hàng vào Firestore
  Future<bool> saveCartToFirestore() async {
    try {
      // Đảm bảo rằng cart đã được khởi tạo
      if (_cartModel == null) {
        print('Cannot save cart: cart is null');
        return false;
      }
      
      // Đảm bảo rằng userId tồn tại
      if (_cartModel!.userId == null || _cartModel!.userId!.isEmpty) {
        print('Cannot save cart: userId is null or empty');
        return false;
      }
      
      // Lấy tham chiếu đến collection 'carts' trong Firestore
      final firestore = FirebaseFirestore.instance;
      final cartRef = firestore.collection('carts').doc(_cartModel!.userId);
      
      // Lưu cart dưới dạng map
      await cartRef.set(_cartModel!.toMap(), SetOptions(merge: true));
      
      print('Cart saved to Firestore successfully for user: ${_cartModel!.userId}');
      return true;
    } catch (e) {
      print('Error saving cart to Firestore: $e');
      return false;
    }
  }  // Tải giỏ hàng từ Firestore
  Future<void> loadCartFromFirestore(String userId) async {
    try {
      // Lấy tham chiếu đến document của giỏ hàng trong Firestore
      final firestore = FirebaseFirestore.instance;
      final cartDoc = await firestore.collection('carts').doc(userId).get();
      
      if (cartDoc.exists && cartDoc.data() != null) {
        // Tạo CartModel từ dữ liệu Firestore
        _cartModel = CartModel.fromFirestore(cartDoc);
        notifyListeners();
        print('Cart loaded from Firestore for user: $userId');
      } else {
        // Nếu giỏ hàng không tồn tại, tạo giỏ hàng mới
        await createCartForNewUser(userId);
        print('Cart not found in Firestore, created new cart for user: $userId');
      }
    } catch (e) {
      print('Error loading cart from Firestore: $e');
    }
  }
    // Hợp nhất giỏ hàng local với giỏ hàng trên Firestore khi người dùng đăng nhập
  Future<bool> mergeGuestCartWithUserCart(String userId) async {
    try {
      // 1. Trước tiên, tải giỏ hàng local
      final hasLocalCart = await loadCartFromLocalStorage();
      if (!hasLocalCart || _cartModel == null || _cartModel!.items.isEmpty) {
        // Nếu không có giỏ hàng local, chỉ cần tải giỏ hàng từ Firestore
        await loadCartFromFirestore(userId);
        return true;
      }

      // 2. Lưu các item từ giỏ hàng local
      final localItems = List<CartItem>.from(_cartModel!.items);
      
      // 3. Tải giỏ hàng của người dùng từ Firestore
      final firestore = FirebaseFirestore.instance;
      final cartDoc = await firestore.collection('carts').doc(userId).get();
      
      CartModel userCart;
      if (cartDoc.exists && cartDoc.data() != null) {
        // Nếu người dùng đã có giỏ hàng trên Firestore
        userCart = CartModel.fromFirestore(cartDoc);
      } else {
        // Tạo giỏ hàng mới nếu chưa có
        userCart = CartModel(userId: userId, items: []);
      }
      
      // 4. Cập nhật _cartModel bằng giỏ hàng người dùng
      _cartModel = userCart;
      
      // 5. Thêm từng item từ giỏ hàng local vào giỏ hàng người dùng
      for (final item in localItems) {
        // Cập nhật userId cho mỗi item
        final userItem = item.copyWith(userId: userId);
        
        // Sử dụng phương thức addItem hiện có để thêm sản phẩm
        // nhưng chặn việc tự động lưu để tránh gọi Firestore nhiều lần
        final existingIndex = _cartModel!.items.indexWhere(
          (i) => i.productId == userItem.productId && i.color == userItem.color
        );
        
        List<CartItem> updatedItems = List<CartItem>.from(_cartModel!.items);
        
        if (existingIndex >= 0) {
          // Cập nhật số lượng nếu sản phẩm đã tồn tại
          final existingItem = _cartModel!.items[existingIndex];
          updatedItems[existingIndex] = existingItem.copyWith(
            quantity: existingItem.quantity + userItem.quantity
          );
        } else {
          // Thêm sản phẩm mới
          updatedItems.add(userItem);
        }
        
        _cartModel = _cartModel!.copyWith(items: updatedItems);
      }
      
      // 6. Lưu giỏ hàng đã hợp nhất lên Firestore
      await saveCartToFirestore();
      
      // 7. Xóa giỏ hàng local
      await clearLocalCart();
      
      notifyListeners();
      print('Successfully merged guest cart with user cart');
      return true;
    } catch (e) {
      print('Error merging guest cart with user cart: $e');
      return false;
    }
  }
  
  // Xử lý khi người dùng đăng nhập
  Future<bool> handleUserLogin(String userId) async {
    try {
      // Hợp nhất giỏ hàng khách với giỏ hàng người dùng
      final success = await mergeGuestCartWithUserCart(userId);
      return success;
    } catch (e) {
      print('Error handling user login: $e');
      return false;
    }
  }
    // Xử lý khi người dùng đăng xuất
  Future<bool> handleUserLogout() async {
    try {
      // Lưu giỏ hàng hiện tại vào Firestore trước khi đăng xuất
      if (_cartModel != null && _cartModel!.userId != null && _cartModel!.userId!.isNotEmpty) {
        await saveCartToFirestore();
      }
      
      // Khởi tạo giỏ hàng trống cho khách
      initCart(null);
      
      // Tải giỏ hàng local nếu có
      await loadCartFromLocalStorage();
      
      print('Successfully handled user logout');
      return true;
    } catch (e) {
      print('Error handling user logout: $e');
      return false;
    }
  }
  
  // Tạo giỏ hàng mới khi người dùng đăng ký tài khoản thành công
  Future<bool> createCartForNewUser(String userId) async {
    try {
      // Khởi tạo một giỏ hàng trống cho người dùng mới
      _cartModel = CartModel(userId: userId, items: []);
      
      // Lưu giỏ hàng vào Firestore
      final success = await saveCartToFirestore();
      
      notifyListeners();
      return success;
    } catch (e) {
      print('Error creating cart for new user: $e');
      return false;
    }
  }
}
