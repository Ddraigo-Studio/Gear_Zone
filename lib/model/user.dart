class UserModel {
  final String uid;           // ID duy nhất của người dùng (từ Firebase Auth)
  final String name;          // Tên hiển thị
  final String email;         // Địa chỉ email
  final String phoneNumber;   // Số điện thoại
  final String? photoURL;     // Đường dẫn đến ảnh đại diện
  final int loyaltyPoints;    // Điểm tích lũy (như hiển thị trong giao diện)
  final DateTime createdAt;   // Ngày tạo tài khoản
  final List<Map<String, dynamic>> addressList; // Danh sách địa chỉ của người dùng
  final String? defaultAddressId; // ID của địa chỉ mặc định
  final String? role; // Vai trò của người dùng (user, admin, etc.)
  final bool hasChangedPassword; // Đánh dấu người dùng đã từng đổi mật khẩu chưa
  final bool? isBanned; // Trạng thái cấm tài khoản
  
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.photoURL,
    this.loyaltyPoints = 0,
    required this.createdAt,
    this.addressList = const [],
    this.defaultAddressId,
    this.role,
    this.hasChangedPassword = false,
    this.isBanned = false,
  });
  // Chuyển đổi từ Map (JSON) sang UserModel
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data["uid"] ?? "",
      name: data["name"] ?? "",
      email: data["email"] ?? "",
      phoneNumber: data["phoneNumber"] ?? "",
      photoURL: data["photoURL"],
      loyaltyPoints: data["loyaltyPoints"] ?? 0,
      createdAt: data["createdAt"] != null 
          ? DateTime.parse(data["createdAt"]) 
          : DateTime.now(),
      addressList: data["addressList"] != null 
          ? List<Map<String, dynamic>>.from(data["addressList"]) 
          : [],      defaultAddressId: data["defaultAddressId"],
      role: data["role"],
      hasChangedPassword: data["hasChangedPassword"] ?? false,
      isBanned: data["isBanned"] ?? false,
    );
  }
  // Chuyển đổi từ UserModel sang Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "photoURL": photoURL,
      "loyaltyPoints": loyaltyPoints,
      "createdAt": createdAt.toIso8601String(),      
      "addressList": addressList,
      "defaultAddressId": defaultAddressId,
      "role": role,
      "hasChangedPassword": hasChangedPassword,
      "isBanned": isBanned,
    };
  }
  // Tạo bản sao của UserModel với một số thuộc tính được thay đổi
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phoneNumber,
    String? photoURL,
    int? loyaltyPoints,
    DateTime? createdAt,
    List<Map<String, dynamic>>? addressList,
    String? defaultAddressId,
    String? role,
    bool? hasChangedPassword,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      createdAt: createdAt ?? this.createdAt,
      addressList: addressList ?? this.addressList,
      defaultAddressId: defaultAddressId ?? this.defaultAddressId,
      role: role ?? this.role,
      hasChangedPassword: hasChangedPassword ?? this.hasChangedPassword,
    );
  }

  // Phương thức tạo một UserModel từ FirebaseUser
  factory UserModel.fromFirebaseUser(dynamic firebaseUser, {
    String? name,
    String? phoneNumber,
    int loyaltyPoints = 0,
    List<Map<String, dynamic>> addressList = const [],
    String? defaultAddressId,
    String? role,
    bool hasChangedPassword = false,
  }) {
    return UserModel(
      uid: firebaseUser.uid,
      name: name ?? firebaseUser.name ?? "",
      email: firebaseUser.email ?? "",
      phoneNumber: phoneNumber ?? firebaseUser.phoneNumber ?? "",
      photoURL: firebaseUser.photoURL,
      loyaltyPoints: loyaltyPoints,
      createdAt: DateTime.now(),
      addressList: addressList,
      defaultAddressId: defaultAddressId,
      role: role,
      hasChangedPassword: hasChangedPassword,
    );
  }

  // Phương thức cập nhật điểm tích lũy
  UserModel addLoyaltyPoints(int points) {
    return this.copyWith(
      loyaltyPoints: this.loyaltyPoints + points,
    );
  }

  // Phương thức thêm địa chỉ mới
  UserModel addAddress(Map<String, dynamic> addressData, {bool setAsDefault = false}) {
    final newAddressList = List<Map<String, dynamic>>.from(addressList);
    newAddressList.add(addressData);
    
    final String addressId = addressData['id'] as String;
    
    return this.copyWith(
      addressList: newAddressList,
      defaultAddressId: setAsDefault ? addressId : defaultAddressId,
    );
  }

  // Phương thức xóa địa chỉ
  UserModel removeAddress(String addressId) {
    final newAddressList = List<Map<String, dynamic>>.from(addressList)
      .where((address) => address['id'] != addressId).toList();
    
    // Nếu địa chỉ bị xóa là địa chỉ mặc định, đặt địa chỉ mặc định về null
    final newDefaultAddressId = 
        addressId == defaultAddressId ? null : defaultAddressId;
    
    return this.copyWith(
      addressList: newAddressList,
      defaultAddressId: newDefaultAddressId,
    );
  }
  // Phương thức cập nhật địa chỉ mặc định
  UserModel updateDefaultAddress(String addressId) {
    // Kiểm tra xem addressId có tồn tại trong danh sách địa chỉ không
    bool addressExists = addressList.any((address) => address['id'] == addressId);
    if (!addressExists) return this;
    
    return this.copyWith(
      defaultAddressId: addressId,
    );
  }
  
  // Phương thức lấy địa chỉ mặc định
  Map<String, dynamic>? getDefaultAddress() {
    if (addressList.isEmpty) {
      return null;
    }
    
    if (defaultAddressId != null) {
      for (var address in addressList) {
        if (address['id'] == defaultAddressId) {
          return address;
        }
      }
    }
    
    // Nếu không tìm thấy địa chỉ mặc định, trả về địa chỉ đầu tiên
    return addressList.isNotEmpty ? addressList.first : null;
  }
  
  // Phương thức lấy địa chỉ đầy đủ từ địa chỉ mặc định
  String getDefaultAddressText() {
    final address = getDefaultAddress();
    if (address == null) {
      return 'Không có địa chỉ';
    }
    
    // Ưu tiên sử dụng trường fullAddress nếu có
    if (address['fullAddress'] != null && address['fullAddress'].toString().isNotEmpty) {
      return address['fullAddress'];
    }
    
    // Nếu không có fullAddress, tạo từ các thành phần
    final street = address['street'] ?? address['addressDetail'] ?? '';
    final ward = address['ward'] ?? '';
    final district = address['district'] ?? '';
    final province = address['province'] ?? '';
    
    return '$street, $ward, $district, $province'.replaceAll(RegExp(r', ,'), ',').replaceAll(RegExp(r'(^,|,$)'), '');
  }
}
