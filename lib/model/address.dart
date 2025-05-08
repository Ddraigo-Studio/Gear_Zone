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

class Address {
  final String id;           // ID duy nhất của địa chỉ
  final String userId;       // ID của người dùng sở hữu địa chỉ này
  final String fullName;     // Họ và tên người nhận
  final String phoneNumber;  // Số điện thoại
  final String province;     // Tỉnh/Thành phố
  final String district;     // Quận/Huyện
  final String ward;         // Phường/Thị xã
  final String addressDetail; // Số nhà, tên đường...
  final bool isDefault;      // Địa chỉ mặc định hay không
  final String addressType;  // Loại địa chỉ: "Nhà", "Công ty", v.v.

  Address({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.province,
    required this.district,
    required this.ward,
    required this.addressDetail,
    this.isDefault = false,
    this.addressType = "Nhà",
  });

  // Chuyển đổi từ Map (JSON) sang Address
  factory Address.fromMap(Map<String, dynamic> data) {
    return Address(
      id: data["id"] ?? "",
      userId: data["userId"] ?? "",
      fullName: data["fullName"] ?? "",
      phoneNumber: data["phoneNumber"] ?? "",
      province: data["province"] ?? "",
      district: data["district"] ?? "",
      ward: data["ward"] ?? "",
      addressDetail: data["addressDetail"] ?? "",
      isDefault: data["isDefault"] ?? false,
      addressType: data["addressType"] ?? "Nhà",
    );
  }

  // Chuyển đổi từ Address sang Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "fullName": fullName,
      "phoneNumber": phoneNumber,
      "province": province,
      "district": district,
      "ward": ward,
      "addressDetail": addressDetail,
      "isDefault": isDefault,
      "addressType": addressType,
    };
  }

  // Tạo một bản sao của Address với một số thuộc tính được thay đổi
  Address copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? phoneNumber,
    String? province,
    String? district,
    String? ward,
    String? addressDetail,
    bool? isDefault,
    String? addressType,
  }) {
    return Address(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      province: province ?? this.province,
      district: district ?? this.district,
      ward: ward ?? this.ward,
      addressDetail: addressDetail ?? this.addressDetail,
      isDefault: isDefault ?? this.isDefault,
      addressType: addressType ?? this.addressType,
    );
  }

  // Hiển thị địa chỉ đầy đủ
  String get fullAddress {
    return "$addressDetail, $ward, $district, $province";
  }
}