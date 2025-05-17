import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';

class CustomerController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _usersCollection;
  
  CustomerController() {
    _usersCollection = _firestore.collection('users');
  }
  
  // Lấy danh sách khách hàng có phân trang
  Future<Map<String, dynamic>> getCustomersPaginated({int page = 1, int limit = 20}) async {
    try {
      // Lấy tổng số khách hàng
      final totalSnapshot = await _usersCollection.get();
      final total = totalSnapshot.size;
      
      // Lấy dữ liệu khách hàng theo trang - đối với Firestore, chúng ta cần thực hiện phân trang thủ công
      Query query = _usersCollection
          .orderBy('createdAt', descending: true)
          .limit(limit);
          
      // Nếu không phải trang đầu tiên, chúng ta cần lấy tài liệu chốt
      if (page > 1) {
        // Lấy tài liệu cuối cùng của trang trước
        final lastDoc = await _usersCollection
            .orderBy('createdAt', descending: true)
            .limit((page - 1) * limit)
            .get()
            .then((snap) => snap.docs.isNotEmpty ? snap.docs.last : null);
            
        if (lastDoc != null) {
          query = query.startAfterDocument(lastDoc);
        }
      }
      
      final QuerySnapshot querySnapshot = await query.get();
          
      // Chuyển đổi dữ liệu thành danh sách khách hàng
      final List<UserModel> customers = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id; // Using uid instead of id
        return UserModel.fromMap(data);
      }).toList();
      
      // Tính tổng số trang
      final int totalPages = (total / limit).ceil();
      
      return {
        'customers': customers,
        'total': total,
        'totalPages': totalPages,
        'currentPage': page,
        'hasNextPage': page < totalPages,
        'hasPreviousPage': page > 1,
      };
    } catch (e) {
      print('Lỗi khi lấy khách hàng phân trang: $e');
      return {
        'customers': <UserModel>[],
        'total': 0,
        'totalPages': 1,
        'currentPage': 1,
        'hasNextPage': false,
        'hasPreviousPage': false,
      };
    }
  }

  // Lấy danh sách khách hàng từ Firestore (giữ lại cho khả năng tương thích ngược)
  Stream<List<UserModel>> getCustomers() {
    return _usersCollection
        .orderBy('createdAt', descending: true)
        .limit(20) // Giới hạn 20 khách hàng mặc định
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id; // Using uid instead of id
        return UserModel.fromMap(data);
      }).toList();
    });
  }
  
  // Lấy chi tiết một khách hàng theo ID
  Future<UserModel?> getCustomerById(String customerId) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(customerId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id; // Using uid instead of id
        return UserModel.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Lỗi khi lấy khách hàng: $e');
      return null;
    }
  }

  // Cập nhật khách hàng
  Future<bool> updateCustomer(UserModel customer) async {
    try {
      if (customer.uid.isEmpty) {
        print('Không thể cập nhật khách hàng: ID không tồn tại');
        return false;
      }

      await _usersCollection.doc(customer.uid).update(customer.toMap());
      return true;
    } catch (e) {
      print('Lỗi khi cập nhật khách hàng: $e');
      return false;
    }
  }

  // Xóa khách hàng
  Future<bool> deleteCustomer(String customerId) async {
    try {
      await _usersCollection.doc(customerId).delete();
      return true;
    } catch (e) {
      print('Lỗi khi xóa khách hàng: $e');
      return false;
    }
  }
}
