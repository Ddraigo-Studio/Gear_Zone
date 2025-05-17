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

  // Lấy danh sách người dùng có phân trang
  Future<Map<String, dynamic>> getUsersPaginated({int page = 1, int limit = 20}) async {
    try {
      // Tính toán vị trí bắt đầu dựa trên trang và giới hạn
      int skip = (page - 1) * limit;
      
      // Lấy tổng số người dùng để tính số trang
      QuerySnapshot countSnapshot = await _firestore.collection(_collection).get();
      int totalItems = countSnapshot.docs.length;
      int totalPages = (totalItems / limit).ceil();
      
      // Lấy dữ liệu cho trang hiện tại
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
          
      // Nếu không phải trang đầu tiên, thì sử dụng startAfter để phân trang
      if (page > 1) {
        // Lấy document cuối cùng của trang trước đó
        QuerySnapshot previousPageSnapshot = await _firestore
            .collection(_collection)
            .orderBy('createdAt', descending: true)
            .limit(skip)
            .get();
        
        // Nếu có đủ document để phân trang
        if (previousPageSnapshot.docs.isNotEmpty) {
          DocumentSnapshot lastVisibleDoc = previousPageSnapshot.docs.last;
          
          // Lấy danh sách document cho trang hiện tại
          snapshot = await _firestore
              .collection(_collection)
              .orderBy('createdAt', descending: true)
              .startAfterDocument(lastVisibleDoc)
              .limit(limit)
              .get();
        }
      }
      
      // Chuyển đổi snapshot thành danh sách UserModel
      List<UserModel> users = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return UserModel.fromMap(data);
      }).toList();
      
      // Trả về kết quả bao gồm dữ liệu và thông tin phân trang
      return {
        'users': users,
        'total': totalItems,
        'totalPages': totalPages,
        'currentPage': page,
        'hasNextPage': page < totalPages,
        'hasPreviousPage': page > 1,
      };
    } catch (e) {
      print('Error getting paginated users: $e');
      throw e;
    }
  }

  // Tìm kiếm người dùng có phân trang
  Future<Map<String, dynamic>> searchUsersPaginated(String query, {int page = 1, int limit = 20}) async {
    query = query.toLowerCase();
    try {
      // Lấy tất cả người dùng để tìm kiếm và lọc (vì Firestore không hỗ trợ tìm kiếm text trực tiếp)
      QuerySnapshot allUsersSnapshot = await _firestore.collection(_collection).get();
      
      // Lọc người dùng theo query
      List<DocumentSnapshot> filteredDocs = allUsersSnapshot.docs.where((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String name = (data['name'] ?? '').toLowerCase();
        String email = (data['email'] ?? '').toLowerCase();
        String phone = (data['phoneNumber'] ?? '');
        
        return name.contains(query) || email.contains(query) || phone.contains(query);
      }).toList();
      
      // Tính toán thông tin phân trang
      int totalItems = filteredDocs.length;
      int totalPages = (totalItems / limit).ceil();
      
      // Phân trang kết quả tìm kiếm
      int startIndex = (page - 1) * limit;
      int endIndex = (startIndex + limit < totalItems) ? startIndex + limit : totalItems;
      
      // Đảm bảo chỉ số không âm và không vượt quá giới hạn danh sách
      startIndex = startIndex < 0 ? 0 : startIndex;
      startIndex = startIndex > totalItems ? 0 : startIndex;
      endIndex = endIndex > totalItems ? totalItems : endIndex;
      
      // Lấy danh sách trang hiện tại từ kết quả đã lọc
      List<DocumentSnapshot> pagedDocs = [];
      if (startIndex < endIndex) {
        pagedDocs = filteredDocs.sublist(startIndex, endIndex);
      }
      
      // Chuyển đổi sang UserModel
      List<UserModel> users = pagedDocs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return UserModel.fromMap(data);
      }).toList();
      
      // Trả về kết quả bao gồm dữ liệu và thông tin phân trang
      return {
        'users': users,
        'total': totalItems,
        'totalPages': totalPages > 0 ? totalPages : 1,
        'currentPage': page,
        'hasNextPage': page < totalPages,
        'hasPreviousPage': page > 1,
      };
    } catch (e) {
      print('Error searching paginated users: $e');
      throw e;
    }
  }
}
