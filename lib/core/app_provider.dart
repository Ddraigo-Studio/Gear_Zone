import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  int _currentScreen = 0;
  bool _isViewOnlyMode = false; // Theo dõi chế độ xem hay sửa
  String _currentProductId = ''; // ID sản phẩm hiện tại đang xem/sửa
  String _selectedCategory = ''; // Danh mục sản phẩm được chọn (laptop, mouse, monitor, pc)
  
  int get currentScreen => _currentScreen;
  bool get isViewOnlyMode => _isViewOnlyMode;
  String get currentProductId => _currentProductId;
  String get selectedCategory => _selectedCategory;
  
  void setCurrentScreen(int index, {bool isViewOnly = false}) {
    _currentScreen = index;
    _isViewOnlyMode = isViewOnly;
    notifyListeners();
  }
  
  void setCurrentProductId(String productId) {
    _currentProductId = productId;
    notifyListeners();
  }
  
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
  
  void resetSelectedCategory() {
    _selectedCategory = '';
    notifyListeners();
  }
}
