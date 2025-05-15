import 'package:flutter/material.dart';

// Enum định nghĩa các màn hình trong ứng dụng
enum AppScreen {
  dashboard,         // 0: Dashboard
  productList,       // 1: Danh sách sản phẩm
  productDetail,     // 2: Chi tiết sản phẩm
  categoryList,      // 3: Danh sách danh mục
  categoryDetail,    // 4: Chi tiết danh mục
  categoryAdd,       // 5: Thêm danh mục mới
  customerList,      // 6: Danh sách khách hàng
  productAdd,        // 7: Thêm sản phẩm mới
}

class AppProvider extends ChangeNotifier {
  AppScreen _currentScreen = AppScreen.dashboard; // Mặc định là dashboard
  bool _isViewOnlyMode = false; // Theo dõi chế độ xem hay sửa
  String _currentProductId = ''; // ID sản phẩm hiện tại đang xem/sửa
  String _currentCategoryId = ''; // ID danh mục hiện tại đang xem/sửa
  String _selectedCategory = ''; // Danh mục sản phẩm được chọn (laptop, mouse, monitor, pc)
  
  AppScreen get currentScreen => _currentScreen;
  bool get isViewOnlyMode => _isViewOnlyMode;
  String get currentProductId => _currentProductId;
  String get currentCategoryId => _currentCategoryId;
  String get selectedCategory => _selectedCategory;
  
  void setCurrentScreen(AppScreen screen, {bool isViewOnly = false}) {
    _currentScreen = screen;
    _isViewOnlyMode = isViewOnly;
    notifyListeners();
  }
  
  // Hàm hỗ trợ tương thích ngược để không phải sửa nhiều code
  @Deprecated('Sử dụng setCurrentScreen với tham số enum AppScreen thay vì số nguyên')
  void setCurrentScreenByIndex(int index, {bool isViewOnly = false}) {
    if (index >= 0 && index < AppScreen.values.length) {
      _currentScreen = AppScreen.values[index];
      _isViewOnlyMode = isViewOnly;
      notifyListeners();
    }
  }
  
  void setCurrentProductId(String productId) {
    _currentProductId = productId;
    notifyListeners();
  }
  
  void setCurrentCategoryId(String categoryId) {
    _currentCategoryId = categoryId;
    notifyListeners();
  }
  
  void setSelectedCategory(String category) {
    // If we're selecting a new category, ensure we exit view-only mode
    if (_selectedCategory != category && _isViewOnlyMode) {
      _isViewOnlyMode = false;
      _currentProductId = '';
    }
    _selectedCategory = category;
    notifyListeners();
  }
  
  void resetSelectedCategory() {
    _selectedCategory = '';
    notifyListeners();
  }
}
