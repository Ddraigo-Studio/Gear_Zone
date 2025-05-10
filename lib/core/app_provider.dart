import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  int _currentScreen = 0;
  bool _isViewOnlyMode = false; // Theo dõi chế độ xem hay sửa
  
  int get currentScreen => _currentScreen;
  bool get isViewOnlyMode => _isViewOnlyMode;
  
  void setCurrentScreen(int index, {bool isViewOnly = false}) {
    _currentScreen = index;
    _isViewOnlyMode = isViewOnly;
    notifyListeners();
  }
}
