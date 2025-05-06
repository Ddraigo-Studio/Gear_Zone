import 'package:dvhcvn/dvhcvn.dart' as dvhcvn;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressData extends ChangeNotifier {
  int _latestChange = 0;
  int get latestChange => _latestChange;

  dvhcvn.Level1? _province;
  dvhcvn.Level1? get province => _province;
  set province(dvhcvn.Level1? v) {
    if (v == _province) return;

    _province = v;
    _district = null;
    _ward = null;
    _latestChange = 1;
    notifyListeners();
  }

  dvhcvn.Level2? _district;
  dvhcvn.Level2? get district => _district;
  set district(dvhcvn.Level2? v) {
    if (v == _district) return;

    _district = v;
    _ward = null;
    _latestChange = 2;
    notifyListeners();
  }

  dvhcvn.Level3? _ward;
  dvhcvn.Level3? get ward => _ward;
  set ward(dvhcvn.Level3? v) {
    if (v == _ward) return;

    _ward = v;
    _latestChange = 3;
    notifyListeners();
  }

  // Thêm phương thức refresh để cập nhật UI khi người dùng nhập text
  void refresh() {
    notifyListeners();
  }

  static AddressData of(BuildContext context, {bool listen = true}) =>
      Provider.of<AddressData>(context, listen: listen);
}