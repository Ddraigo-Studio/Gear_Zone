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
  customerDetail,    // 7: Chi tiết khách hàng 
  productAdd,        // 8: Thêm sản phẩm mới
  voucherList,       // 9: Danh sách phiếu giảm giá
  voucherDetail,     // 10: Chi tiết phiếu giảm giá
  voucherAdd,        // 11: Thêm phiếu giảm giá mới
  orderList,         // 12: Danh sách đơn hàng
  orderDetail,       // 13: Chi tiết đơn hàng
  couponList,        // 14: Danh sách mã giảm giá
  couponDetail,      // 15: Chi tiết mã giảm giá
  couponAdd,         // 16: Thêm mã giảm giá mới
}

class AppProvider extends ChangeNotifier {
  AppScreen _currentScreen = AppScreen.dashboard; // Mặc định là dashboard
  bool _isViewOnlyMode = false; // Theo dõi chế độ xem hay sửa
  String _currentProductId = ''; // ID sản phẩm hiện tại đang xem/sửa
  String _currentCategoryId = ''; // ID danh mục hiện tại đang xem/sửa
  String _currentCustomerId = ''; // ID khách hàng hiện tại đang xem/sửa
  String _currentVoucherId = ''; // ID phiếu giảm giá hiện tại đang xem/sửa
  String _currentOrderId = ''; // ID đơn hàng hiện tại đang xem/sửa
  String _currentCouponId = ''; // ID mã giảm giá hiện tại đang xem/sửa
  String _selectedCategory = ''; // Danh mục sản phẩm được chọn (laptop, mouse, monitor, pc)
  bool _reloadProductList = false; // Cờ để tải lại danh sách sản phẩm
  bool _reloadCategoryList = false; // Cờ để tải lại danh sách danh mục
  bool _reloadCustomerList = false; // Cờ để tải lại danh sách khách hàng
  bool _reloadVoucherList = false; // Cờ để tải lại danh sách phiếu giảm giá
  bool _reloadOrderList = false; // Cờ để tải lại danh sách đơn hàng
  bool _reloadCouponList = false; // Cờ để tải lại danh sách mã giảm giá
  
  AppScreen get currentScreen => _currentScreen;
  bool get isViewOnlyMode => _isViewOnlyMode;
  String get currentProductId => _currentProductId;
  String get currentCategoryId => _currentCategoryId;
  String get currentCustomerId => _currentCustomerId;
  String get currentVoucherId => _currentVoucherId;
  String get currentOrderId => _currentOrderId;
  String get currentCouponId => _currentCouponId;
  String get selectedCategory => _selectedCategory;
  bool get reloadProductList => _reloadProductList;
  bool get reloadCategoryList => _reloadCategoryList;
  bool get reloadCustomerList => _reloadCustomerList;
  bool get reloadVoucherList => _reloadVoucherList;
  bool get reloadOrderList => _reloadOrderList;
  bool get reloadCouponList => _reloadCouponList;
  
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
  
  void setCurrentCustomerId(String customerId) {
    _currentCustomerId = customerId;
    notifyListeners();
  }
  
  void setCurrentVoucherId(String voucherId) {
    _currentVoucherId = voucherId;
    notifyListeners();
  }
  
  void setCurrentOrderId(String orderId) {
    _currentOrderId = orderId;
    notifyListeners();
  }
  
  void setCurrentCouponId(String couponId) {
    _currentCouponId = couponId;
    notifyListeners();
  }
  
  void resetSelectedCategory() {
    _selectedCategory = '';
    notifyListeners();
  }
  
  // Phương thức để đặt cờ tải lại danh sách sản phẩm
  void setReloadProductList(bool value) {
    _reloadProductList = value;
    notifyListeners();
  }
  
  // Phương thức để đặt cờ tải lại danh sách danh mục
  void setReloadCategoryList(bool value) {
    _reloadCategoryList = value;
    notifyListeners();
  }
  
  // Phương thức để đặt cờ tải lại danh sách khách hàng
  void setReloadCustomerList(bool value) {
    _reloadCustomerList = value;
    notifyListeners();
  }
  
  // Phương thức để đặt cờ tải lại danh sách phiếu giảm giá
  void setReloadVoucherList(bool value) {
    _reloadVoucherList = value;
    notifyListeners();
  }
  
  // Phương thức để đặt cờ tải lại danh sách đơn hàng
  void setReloadOrderList(bool value) {
    _reloadOrderList = value;
    notifyListeners();
  }

  // Phương thức để đặt cờ tải lại danh sách mã giảm giá
  void setReloadCouponList(bool value) {
    _reloadCouponList = value;
    notifyListeners();
  }
}
