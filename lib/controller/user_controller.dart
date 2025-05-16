import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gear_zone/model/user.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collection = 'users';

  // Lấy thông tin tất cả người dùng
  Stream<List<UserModel>> getUsers() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['uid'] = doc.id;
        return UserModel.fromMap(data);
      }).toList();
    });
  }

  // Lấy người dùng theo ID
  Future<UserModel?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc(uid).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return UserModel.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Cập nhật thông tin người dùng
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection(_collection).doc(user.uid).update({
        'name': user.name,
        'phoneNumber': user.phoneNumber,
        'photoURL': user.photoURL,
        'addressList': user.addressList,
        'defaultAddressId': user.defaultAddressId,
        'role': user.role,
      });
    } catch (e) {
      print('Error updating user: $e');
      throw e;
    }
  }

  // Thay đổi vai trò người dùng (admin/user)
  Future<void> updateUserRole(String uid, String role) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        'role': role,
      });
    } catch (e) {
      print('Error updating user role: $e');
      throw e;
    }
  }

  // Khóa/Mở khóa tài khoản người dùng
  Future<void> banUser(String uid, bool isBanned) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        'isBanned': isBanned,
      });
    } catch (e) {
      print('Error banning/unbanning user: $e');
      throw e;
    }
  }

  // Tìm kiếm người dùng theo tên hoặc email
  Stream<List<UserModel>> searchUsers(String query) {
    query = query.toLowerCase();
    
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                Map<String, dynamic> data = doc.data();
                data['uid'] = doc.id;
                return UserModel.fromMap(data);
              })
              .where((user) => 
                user.name.toLowerCase().contains(query) || 
                user.email.toLowerCase().contains(query) ||
                user.phoneNumber.contains(query)
              )
              .toList();
        });
  }

  // Đếm tổng số người dùng
  Future<int> getUsersCount() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error counting users: $e');
      return 0;
    }
  }

  // Đếm người dùng mới trong 30 ngày qua
  Future<int> getNewUsersCount() async {
    try {
      DateTime thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('createdAt', isGreaterThanOrEqualTo: thirtyDaysAgo)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error counting new users: $e');
      return 0;
    }
  }

  // Đổi mật khẩu cho người dùng (yêu cầu cần đăng nhập)
  Future<void> changePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        await _firestore.collection(_collection).doc(user.uid).update({
          'hasChangedPassword': true,
        });
      }
    } catch (e) {
      print('Error changing password: $e');
      throw e;
    }
  }

  // Đặt lại mật khẩu cho người dùng (gửi email)
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error resetting password: $e');
      throw e;
    }
  }
  // Xóa tài khoản người dùng (cần cẩn trọng)
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection(_collection).doc(uid).delete();
      // Lưu ý: Việc xóa tài khoản Authentication yêu cầu quyền admin Firebase hoặc người dùng đăng nhập là chính họ
    } catch (e) {
      print('Error deleting user: $e');
      throw e;
    }
  }

  // Kiểm tra nhanh xem người dùng có bị cấm hay không
  Future<bool> isUserBanned(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['isBanned'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error checking if user is banned: $e');
      return false;
    }
  }
}
