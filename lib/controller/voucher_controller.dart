import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gear_zone/model/voucher.dart';

class VoucherController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'vouchers';
    // Tạo phiếu giảm giá mới
  Future<String> createVoucher(Voucher voucher) async {
    try {
      // Validate discount amount
      const allowed = [10000.0, 20000.0, 50000.0, 100000.0];
      double discountAmount = voucher.discountAmount;
      if (!allowed.contains(discountAmount)) {
        discountAmount = 10000.0; // Default to 10,000 if invalid
      }
      
      // Tạo document mới với ID tự động
      DocumentReference docRef = _firestore.collection(_collection).doc();
        // Cập nhật ID từ document reference
      Voucher updatedVoucher = Voucher(
        id: docRef.id,
        code: voucher.code,
        discountAmount: discountAmount,
        createdAt: voucher.createdAt,
        maxUsageCount: voucher.maxUsageCount,
        currentUsageCount: voucher.currentUsageCount,
        appliedOrderIds: voucher.appliedOrderIds,
        userUsageCounts: voucher.userUsageCounts,
        isActive: voucher.isActive,
      );
      
      // Lưu voucher vào Firestore
      await docRef.set(updatedVoucher.toMap());
      
      return docRef.id;
    } catch (e) {
      print('Error creating voucher: $e');
      throw e;
    }
  }  // Cập nhật phiếu giảm giá
  Future<void> updateVoucher(Voucher voucher) async {
    try {
      // Validate discount amount
      const allowed = [10000.0, 20000.0, 50000.0, 100000.0];
      double discountAmount = voucher.discountAmount;
      
      Voucher updatedVoucher = voucher;
      if (!allowed.contains(discountAmount)) {
        updatedVoucher = voucher.copyWith(discountAmount: 10000.0); // Default to 10,000 if invalid
      }
      
      await _firestore.collection(_collection).doc(voucher.id).update(updatedVoucher.toMap());
    } catch (e) {
      print('Error updating voucher: $e');
      throw e;
    }
  }

  // Xóa phiếu giảm giá
  Future<void> deleteVoucher(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      print('Error deleting voucher: $e');
      throw e;
    }
  }

  // Lấy thông tin một phiếu giảm giá theo ID
  Future<Voucher?> getVoucherById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return Voucher.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting voucher: $e');
      throw e;
    }
  }

  // Lấy danh sách tất cả các phiếu giảm giá
  Stream<List<Voucher>> getVouchers() {
    try {
      Query query = _firestore.collection(_collection).orderBy('createdAt', descending: true);
      
      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => Voucher.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      print('Error getting vouchers: $e');
      throw e;
    }
  }
  
  // Lấy danh sách phiếu giảm giá với lọc theo số lần sử dụng còn lại
  Stream<List<Voucher>> getAvailableVouchers() {
    try {
      return _firestore.collection(_collection)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
              .map((doc) => Voucher.fromFirestore(doc))
              .where((voucher) => voucher.remainingUsageCount > 0)
              .toList();
          });
    } catch (e) {
      print('Error getting available vouchers: $e');
      throw e;
    }
  }
  // Kiểm tra xem mã voucher đã tồn tại hay chưa
  Future<bool> isCodeExist(String code) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking voucher code: $e');
      throw e;
    }
  }

  // Đếm tổng số phiếu giảm giá
  Future<int> getVouchersCount() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error counting vouchers: $e');
      return 0;
    }
  }
  // Lấy danh sách mã giảm giá có phân trang
  Future<Map<String, dynamic>> getVouchersPaginated({
    int page = 1, 
    int limit = 20
  }) async {
    try {
      // Tạo truy vấn
      Query query = _firestore.collection(_collection)
          .orderBy('createdAt', descending: true);
      
      // Đếm tổng số bản ghi
      QuerySnapshot countQuery = await query.get();
      final int totalItems = countQuery.size;
      final int totalPages = (totalItems / limit).ceil();
      
      // Lấy dữ liệu theo trang
      List<DocumentSnapshot> documents = [];
      if (totalItems > 0) {
        // Nếu không phải trang đầu tiên, cần lấy tài liệu cuối cùng của trang trước đó
        if (page > 1) {
          // Lấy tài liệu cuối cùng của trang trước đó
          QuerySnapshot prevPageQuery = await query
              .limit((page - 1) * limit)
              .get();
          
          if (prevPageQuery.docs.isNotEmpty) {
            final lastDoc = prevPageQuery.docs.last;
            
            // Sử dụng startAfterDocument để phân trang
            QuerySnapshot pageQuery = await query
                .startAfterDocument(lastDoc)
                .limit(limit)
                .get();
            
            documents.addAll(pageQuery.docs);
          }
        } else {
          // Trang đầu tiên
          QuerySnapshot pageQuery = await query
              .limit(limit)
              .get();
          
          documents.addAll(pageQuery.docs);
        }
      }
      
      // Chuyển đổi tài liệu thành đối tượng Voucher
      List<Voucher> vouchers = documents
          .map((doc) => Voucher.fromFirestore(doc))
          .toList();
      
      return {
        'vouchers': vouchers,
        'totalItems': totalItems,
        'totalPages': totalPages > 0 ? totalPages : 1,
        'currentPage': page,
        'hasNextPage': page < totalPages,
        'hasPreviousPage': page > 1,
      };
    } catch (e) {
      print('Error getting paginated vouchers: $e');
      return {
        'vouchers': <Voucher>[],
        'totalItems': 0,
        'totalPages': 1,
        'currentPage': page,
        'hasNextPage': false,
        'hasPreviousPage': false,
      };
    }
  }
  // Tạo mã giảm giá mới
  Future<String> createNewVoucher(String code, double amount, int maxUsageCount, {bool isActive = true}) async {
    try {
      // Kiểm tra xem mã đã tồn tại chưa
      bool codeExists = await isCodeExist(code);
      if (codeExists) {
        throw Exception('Mã giảm giá đã tồn tại');
      }
      
      // Validate discount amount
      const allowed = [10000.0, 20000.0, 50000.0, 100000.0];
      if (!allowed.contains(amount)) {
        amount = 10000.0; // Default to 10,000 if invalid
      }
      
      // Tạo mã giảm giá mới sử dụng factory của Voucher
      Voucher voucher = Voucher.createVoucher(
        code: code.toUpperCase(),
        amount: amount,
        maxUsageCount: maxUsageCount,
        isActive: isActive,
      );
      
      // Lưu vào Firestore
      return createVoucher(voucher);
    } catch (e) {
      print('Error creating voucher: $e');
      throw e;
    }
  }
    // Áp dụng mã giảm giá cho một đơn hàng
  Future<bool> applyVoucherToOrder(String code, String orderId, String userId) async {
    try {
      // Tìm mã giảm giá
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      
      if (snapshot.docs.isEmpty) {
        return false; // Không tìm thấy mã giảm giá
      }
      
      DocumentSnapshot doc = snapshot.docs.first;
      Voucher voucher = Voucher.fromFirestore(doc);
      
      // Kiểm tra tính hợp lệ của mã giảm giá
      if (voucher.currentUsageCount >= voucher.maxUsageCount || !voucher.isActive) {
        return false; // Mã đã hết lượt sử dụng hoặc không còn hoạt động
      }
      
      // Kiểm tra xem đơn hàng đã sử dụng mã này chưa
      if (voucher.appliedOrderIds.contains(orderId)) {
        return false; // Đơn hàng đã sử dụng mã này
      }
      
      // Áp dụng mã giảm giá với ID người dùng
      Voucher updatedVoucher = voucher.applyToOrder(orderId, userId);
      
      // Cập nhật vào Firestore
      await _firestore.collection(_collection).doc(voucher.id).update(updatedVoucher.toMap());
      
      return true;
    } catch (e) {
      print('Error applying voucher to order: $e');
      return false;
    }
  }
    // Lấy thông tin về các đơn hàng đã sử dụng một mã giảm giá
  Future<List<Map<String, dynamic>>> getOrderDetailsForVoucher(String voucherId) async {
    try {
      // Lấy thông tin mã giảm giá
      Voucher? voucher = await getVoucherById(voucherId);
      if (voucher == null || voucher.appliedOrderIds.isEmpty) {
        return [];
      }
      
      // Lấy thông tin các đơn hàng
      List<Map<String, dynamic>> orderDetails = [];
      
      for (String orderId in voucher.appliedOrderIds) {
        DocumentSnapshot orderDoc = await _firestore.collection('orders').doc(orderId).get();
        
        if (orderDoc.exists) {
          Map<String, dynamic> data = orderDoc.data() as Map<String, dynamic>;
          data['id'] = orderId;
          orderDetails.add(data);
        }
      }
      
      return orderDetails;
    } catch (e) {
      print('Error getting order details for voucher: $e');
      return [];
    }
  }
  
  // Tìm kiếm voucher theo mã
  Future<Voucher?> getVoucherByCode(String code) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('code', isEqualTo: code.toUpperCase())
          .limit(1)
          .get();
      
      if (snapshot.docs.isEmpty) {
        return null;
      }
      
      return Voucher.fromFirestore(snapshot.docs.first);
    } catch (e) {
      print('Error finding voucher by code: $e');
      return null;
    }
  }
  
  // Kiểm tra mã giảm giá có hợp lệ không (còn lượt sử dụng)
  Future<Map<String, dynamic>> checkVoucherValidity(String code, {String? userId}) async {
    try {
      Voucher? voucher = await getVoucherByCode(code);
      
      if (voucher == null) {
        return {
          'valid': false,
          'message': 'Mã giảm giá không tồn tại',
          'voucher': null
        };
      }
      
      if (!voucher.isActive) {
        return {
          'valid': false,
          'message': 'Mã giảm giá đã bị vô hiệu hóa',
          'voucher': voucher
        };
      }
      
      if (voucher.currentUsageCount >= voucher.maxUsageCount) {
        return {
          'valid': false,
          'message': 'Mã giảm giá đã hết lượt sử dụng',
          'voucher': voucher
        };
      }
      
      // Kiểm tra giới hạn sử dụng theo người dùng nếu có userId
      if (userId != null) {
        int userUsageCount = voucher.userUsageCounts[userId] ?? 0;
        int maxPerUserUsage = 1; // Số lần tối đa mỗi người dùng có thể sử dụng mã
        
        if (userUsageCount >= maxPerUserUsage) {
          return {
            'valid': false,
            'message': 'Bạn đã sử dụng hết lượt áp dụng mã này',
            'voucher': voucher
          };
        }
      }
      
      return {
        'valid': true,
        'message': 'Mã giảm giá hợp lệ',
        'voucher': voucher,
        'discountAmount': voucher.discountAmount,
        'remainingUsage': voucher.remainingUsageCount
      };
    } catch (e) {
      print('Error checking voucher validity: $e');
      return {
        'valid': false,
        'message': 'Lỗi khi kiểm tra mã giảm giá: $e',
        'voucher': null
      };
    }
  }  // Get user-specific voucher usage
  Future<Map<String, dynamic>> getUserVoucherUsage(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(_collection).get();
      
      Map<String, dynamic> userVoucherUsage = {
        'usedVouchers': <Map<String, dynamic>>[],
        'totalUsageCount': 0,
        'totalSaved': 0.0
      };
      
      snapshot.docs.forEach((doc) {
        Voucher voucher = Voucher.fromFirestore(doc);
        if (voucher.userUsageCounts.containsKey(userId)) {
          int usageCount = voucher.userUsageCounts[userId]!;
          
          // Add to total usage count
          userVoucherUsage['totalUsageCount'] = (userVoucherUsage['totalUsageCount'] as int) + usageCount;
          
          // Add to total saved amount
          userVoucherUsage['totalSaved'] = (userVoucherUsage['totalSaved'] as double) + (voucher.discountAmount * usageCount);
          
          // Add voucher details
          (userVoucherUsage['usedVouchers'] as List<Map<String, dynamic>>).add({
            'voucherId': voucher.id,
            'code': voucher.code,
            'usageCount': usageCount,
            'discountAmount': voucher.discountAmount,
            'totalDiscountAmount': voucher.discountAmount * usageCount,
            'isActive': voucher.isActive,
            'createdAt': voucher.createdAt,
          });
        }
      });
      
      return userVoucherUsage;
    } catch (e) {
      print('Error getting user voucher usage: $e');
      return {
        'usedVouchers': <Map<String, dynamic>>[],
        'totalUsageCount': 0,
        'totalSaved': 0.0
      };
    }
  }

  // Get voucher usage by users for a specific voucher
  Future<Map<String, dynamic>> getVoucherUserUsageDetails(String voucherId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc(voucherId).get();
      
      if (!doc.exists) {
        return {
          'voucherId': voucherId,
          'found': false,
          'totalUsers': 0,
          'userDetails': [],
        };
      }
      
      Voucher voucher = Voucher.fromFirestore(doc);
      List<Map<String, dynamic>> userDetails = [];
      
      // Get user details for each user who used this voucher
      for (String userId in voucher.userUsageCounts.keys) {
        int usageCount = voucher.userUsageCounts[userId]!;
        
        // Try to get user information from the users collection
        try {
          DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
          Map<String, dynamic> userData = {
            'userId': userId,
            'usageCount': usageCount,
            'totalDiscountAmount': usageCount * voucher.discountAmount,
          };
          
          // Add user data if available
          if (userDoc.exists) {
            Map<String, dynamic> userInfo = userDoc.data() as Map<String, dynamic>;
            userData['userName'] = userInfo['displayName'] ?? 'Unknown User';
            userData['email'] = userInfo['email'] ?? 'No Email';
            userData['phoneNumber'] = userInfo['phoneNumber'] ?? 'No Phone';
          } else {
            userData['userName'] = 'Unknown User';
            userData['email'] = 'Unknown';
            userData['phoneNumber'] = 'Unknown';
          }
          
          userDetails.add(userData);
        } catch (e) {
          print('Error getting user details for user $userId: $e');
          userDetails.add({
            'userId': userId,
            'userName': 'Error Loading User',
            'usageCount': usageCount,
            'totalDiscountAmount': usageCount * voucher.discountAmount,
          });
        }
      }
      
      return {
        'voucherId': voucherId,
        'voucherCode': voucher.code,
        'discountAmount': voucher.discountAmount,
        'createdAt': voucher.createdAt,
        'isActive': voucher.isActive,
        'found': true,
        'totalUsers': voucher.userUsageCounts.length,
        'userDetails': userDetails,
        'currentUsageCount': voucher.currentUsageCount,
        'maxUsageCount': voucher.maxUsageCount,
        'remainingUsage': voucher.remainingUsageCount,
      };
    } catch (e) {
      print('Error getting voucher user usage details: $e');
      return {
        'voucherId': voucherId,
        'found': false,
        'error': e.toString(),
        'totalUsers': 0,
        'userDetails': [],
      };
    }
  }

  // Toggle active status for multiple vouchers
  Future<Map<String, dynamic>> toggleMultipleVoucherStatus(List<String> voucherIds, bool isActive) async {
    try {
      int successCount = 0;
      List<String> failedIds = [];
      List<String> notFoundIds = [];
      
      for (String id in voucherIds) {
        try {
          // Check if voucher exists
          DocumentSnapshot doc = await _firestore.collection(_collection).doc(id).get();
          if (!doc.exists) {
            notFoundIds.add(id);
            continue;
          }
          
          // Update the status
          await _firestore.collection(_collection).doc(id).update({
            'isActive': isActive
          });
          
          successCount++;
        } catch (e) {
          print('Error toggling status for voucher $id: $e');
          failedIds.add(id);
        }
      }
      
      return {
        'success': failedIds.isEmpty && notFoundIds.isEmpty,
        'totalProcessed': voucherIds.length,
        'successCount': successCount,
        'failedCount': failedIds.length,
        'notFoundCount': notFoundIds.length,
        'failedIds': failedIds,
        'notFoundIds': notFoundIds,
      };
    } catch (e) {
      print('Error in batch toggling voucher status: $e');
      return {
        'success': false,
        'error': e.toString(),
        'totalProcessed': 0,
        'successCount': 0,
        'failedCount': voucherIds.length,
      };
    }
  }
  
  // Get recently used vouchers (within a time period)
  Future<List<Map<String, dynamic>>> getRecentlyUsedVouchers({
    int days = 7,
    int limit = 10,
  }) async {
    try {
      // Calculate the date from 'days' days ago
      DateTime cutoffDate = DateTime.now().subtract(Duration(days: days));
      
      // Get all vouchers
      QuerySnapshot snapshot = await _firestore.collection(_collection).get();
      
      List<Map<String, dynamic>> recentVouchers = [];
      
      // Process each voucher
      for (DocumentSnapshot doc in snapshot.docs) {
        Voucher voucher = Voucher.fromFirestore(doc);
        
        // Get related orders to check when voucher was used
        QuerySnapshot orderSnapshot = await _firestore
            .collection('orders')
            .where('voucherId', isEqualTo: voucher.id)
            .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(cutoffDate))
            .orderBy('createdAt', descending: true)
            .limit(limit)
            .get();
        
        if (orderSnapshot.docs.isNotEmpty) {
          int recentUsageCount = orderSnapshot.docs.length;
          
          recentVouchers.add({
            'voucherId': voucher.id,
            'code': voucher.code,
            'discountAmount': voucher.discountAmount,
            'isActive': voucher.isActive,
            'recentUsageCount': recentUsageCount,
            'totalUsageCount': voucher.currentUsageCount,
            'maxUsageCount': voucher.maxUsageCount,
            'recentOrders': orderSnapshot.docs.map((orderDoc) {
              Map<String, dynamic> orderData = orderDoc.data() as Map<String, dynamic>;
              return {
                'orderId': orderDoc.id,
                'orderDate': (orderData['createdAt'] as Timestamp).toDate(),
                'userId': orderData['userId'] ?? '',
                'orderTotal': orderData['total'] ?? 0.0,
              };
            }).toList(),
          });
        }
      }
      
      // Sort by recent usage count, descending
      recentVouchers.sort((a, b) => 
          (b['recentUsageCount'] as int).compareTo(a['recentUsageCount'] as int));
      
      // Limit results
      if (recentVouchers.length > limit) {
        recentVouchers = recentVouchers.sublist(0, limit);
      }
      
      return recentVouchers;
    } catch (e) {
      print('Error getting recently used vouchers: $e');
      return [];
    }
  }

  // Toggle voucher active status
  Future<void> toggleVoucherStatus(String voucherId, bool isActive) async {
    try {
      await _firestore.collection(_collection).doc(voucherId).update({
        'isActive': isActive
      });
    } catch (e) {
      print('Error toggling voucher status: $e');
      throw e;
    }
  }
}
