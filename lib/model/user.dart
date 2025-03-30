class UserModel {
  String uid; // ID người dùng (do Firebase tạo)
  String email; // Email của người dùng
  String name; // Tên của người dùng

  // Constructor để tạo UserModel
  UserModel({required this.uid, required this.email, required this.name});

  // Chuyển dữ liệu từ Firestore (Map) thành đối tượng UserModel
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data["uid"] ?? "",  // Lấy giá trị từ Map, nếu không có thì để ""
      email: data["email"] ?? "",
      name: data["name"] ?? "Không có tên", // Nếu không có name thì đặt mặc định
    );
  }

  // Chuyển đối tượng UserModel thành Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
    };
  }
}
