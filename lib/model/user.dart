class UserModel {
  String uid; 
  String email; 
  String name;

  UserModel({required this.uid, required this.email, required this.name});

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data["uid"] ?? "",  
      email: data["email"] ?? "",
      name: data["name"] ?? "Không có tên", 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
    };
  }
}
