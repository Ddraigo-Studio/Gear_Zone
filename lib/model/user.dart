class UserModel {
  final String uid;           // ID duy nhất của người dùng (từ Firebase Auth)
  final String name;   // Tên hiển thị
  final String email;         // Địa chỉ email
  final String phoneNumber;   // Số điện thoại
  final String? photoURL;     // Đường dẫn đến ảnh đại diện
  final int loyaltyPoints;    // Điểm tích lũy (như hiển thị trong giao diện)
  final DateTime createdAt;   // Ngày tạo tài khoản
  final DateTime lastActive;  // Ngày hoạt động gần nhất
  final List<String> addressIds; // Danh sách ID địa chỉ của người dùng
  final String? defaultAddressId; // ID của địa chỉ mặc định

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.photoURL,
    this.loyaltyPoints = 0,
    required this.createdAt,
    required this.lastActive,
    this.addressIds = const [],
    this.defaultAddressId,
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
      lastActive: data["lastActive"] != null 
          ? DateTime.parse(data["lastActive"]) 
          : DateTime.now(),
      addressIds: data["addressIds"] != null 
          ? List<String>.from(data["addressIds"]) 
          : [],
      defaultAddressId: data["defaultAddressId"],
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
      "lastActive": lastActive.toIso8601String(),
      "addressIds": addressIds,
      "defaultAddressId": defaultAddressId,
    };
  }

  // Tạo bản sao của UserModel với một số thuộc tính được thay đổi
  UserModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? phoneNumber,
    String? photoURL,
    int? loyaltyPoints,
    DateTime? createdAt,
    DateTime? lastActive,
    List<String>? addressIds,
    String? defaultAddressId,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      addressIds: addressIds ?? this.addressIds,
      defaultAddressId: defaultAddressId ?? this.defaultAddressId,
    );
  }

  // Phương thức tạo một UserModel từ FirebaseUser
  factory UserModel.fromFirebaseUser(dynamic firebaseUser, {
    String? name,
    String? phoneNumber,
    int loyaltyPoints = 0,
    List<String> addressIds = const [],
    String? defaultAddressId,
  }) {
    return UserModel(
      uid: firebaseUser.uid,
      name: name ?? firebaseUser.name ?? "",
      email: firebaseUser.email ?? "",
      phoneNumber: phoneNumber ?? firebaseUser.phoneNumber ?? "",
      photoURL: firebaseUser.photoURL,
      loyaltyPoints: loyaltyPoints,
      createdAt: DateTime.now(),
      lastActive: DateTime.now(),
      addressIds: addressIds,
      defaultAddressId: defaultAddressId,
    );
  }

  // Phương thức cập nhật điểm tích lũy
  UserModel addLoyaltyPoints(int points) {
    return this.copyWith(
      loyaltyPoints: this.loyaltyPoints + points,
      lastActive: DateTime.now(),
    );
  }

  // Phương thức thêm địa chỉ mới
  UserModel addAddress(String addressId, {bool setAsDefault = false}) {
    final newAddressIds = List<String>.from(addressIds);
    newAddressIds.add(addressId);
    
    return this.copyWith(
      addressIds: newAddressIds,
      defaultAddressId: setAsDefault ? addressId : defaultAddressId,
      lastActive: DateTime.now(),
    );
  }

  // Phương thức xóa địa chỉ
  UserModel removeAddress(String addressId) {
    final newAddressIds = List<String>.from(addressIds);
    newAddressIds.remove(addressId);
    
    // Nếu địa chỉ bị xóa là địa chỉ mặc định, đặt địa chỉ mặc định về null
    final newDefaultAddressId = 
        addressId == defaultAddressId ? null : defaultAddressId;
    
    return this.copyWith(
      addressIds: newAddressIds,
      defaultAddressId: newDefaultAddressId,
      lastActive: DateTime.now(),
    );
  }

  // Phương thức cập nhật địa chỉ mặc định
  UserModel updateDefaultAddress(String addressId) {
    if (!addressIds.contains(addressId)) return this;
    
    return this.copyWith(
      defaultAddressId: addressId,
      lastActive: DateTime.now(),
    );
  }
}
