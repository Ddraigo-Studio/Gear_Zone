import 'package:flutter/material.dart';

/// Lớp quản lý trạng thái phân trang tổng quát cho các danh sách
class PaginationController extends ChangeNotifier {
  int _currentPage = 1;
  int _itemsPerPage = 20;
  int _totalItems = 0;
  int _totalPages = 1;
  bool _hasNextPage = false;
  bool _hasPreviousPage = false;

  // Getters
  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  int get totalItems => _totalItems;
  int get totalPages => _totalPages;
  bool get hasNextPage => _hasNextPage;
  bool get hasPreviousPage => _hasPreviousPage;

  // Setters với cập nhật trạng thái
  set itemsPerPage(int value) {
    _itemsPerPage = value;
    _calculatePagination();
    notifyListeners();
  }

  set totalItems(int value) {
    _totalItems = value;
    _calculatePagination();
    notifyListeners();
  }

  // Phương thức để tính toán trạng thái phân trang
  void _calculatePagination() {
    _totalPages = (_totalItems / _itemsPerPage).ceil();
    if (_totalPages < 1) _totalPages = 1;

    // Đảm bảo trang hiện tại không vượt quá tổng số trang
    if (_currentPage > _totalPages) {
      _currentPage = _totalPages;
    }

    _hasNextPage = _currentPage < _totalPages;
    _hasPreviousPage = _currentPage > 1;
  }

  // Phương thức để di chuyển đến trang tiếp theo
  void nextPage() {
    if (_hasNextPage) {
      _currentPage++;
      _calculatePagination();
      notifyListeners();
    }
  }

  // Phương thức để quay lại trang trước
  void previousPage() {
    if (_hasPreviousPage) {
      _currentPage--;
      _calculatePagination();
      notifyListeners();
    }
  }

  // Phương thức để đi đến trang cụ thể
  void goToPage(int page) {
    if (page >= 1 && page <= _totalPages && page != _currentPage) {
      _currentPage = page;
      _calculatePagination();
      notifyListeners();
    }
  }

  // Phương thức để đặt lại phân trang về trang đầu tiên
  void reset() {
    _currentPage = 1;
    _calculatePagination();
    notifyListeners();
  }

  // Tính toán vị trí bắt đầu và kết thúc của mảng dữ liệu
  Map<String, int> getItemRange() {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    if (endIndex > _totalItems) {
      endIndex = _totalItems;
    }
    return {'startIndex': startIndex, 'endIndex': endIndex};
  }
}
