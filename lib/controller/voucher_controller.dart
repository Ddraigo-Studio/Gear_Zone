import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gear_zone/model/voucher.dart';

class VoucherController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'vouchers';

  // Tạo phiếu giảm giá mới
  Future<String> createVoucher(Voucher voucher) async {
    try {
      // Tạo document mới với ID tự động
      DocumentReference docRef = _firestore.collection(_collection).doc();
      
      // Cập nhật ID từ document reference
      Voucher updatedVoucher = Voucher(
        id: docRef.id,
        code: voucher.code,
        discountPercentage: voucher.discountPercentage,
        minimumOrderAmount: voucher.minimumOrderAmount,
        maximumDiscountAmount: voucher.maximumDiscountAmount,
        expirationDate: voucher.expirationDate,
        validFromDate: voucher.validFromDate,
        validToDate: voucher.validToDate,
        applicableProducts: voucher.applicableProducts,
        paymentMethods: voucher.paymentMethods,
        isActive: voucher.isActive,
      );
      
      // Lưu voucher vào Firestore
      await docRef.set(updatedVoucher.toMap());
      
      return docRef.id;
    } catch (e) {
      print('Error creating voucher: $e');
      throw e;
    }
  }

  // Cập nhật phiếu giảm giá
  Future<void> updateVoucher(Voucher voucher) async {
    try {
      await _firestore.collection(_collection).doc(voucher.id).update(voucher.toMap());
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
  Stream<List<Voucher>> getVouchers({bool activeOnly = false}) {
    try {
      Query query = _firestore.collection(_collection).orderBy('validToDate', descending: true);
      
      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true)
                    .where('validToDate', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()));
      }
      
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
  Future<int> getVouchersCount({bool activeOnly = false}) async {
    try {
      Query query = _firestore.collection(_collection);
      
      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true)
                    .where('validToDate', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()));
      }
      
      QuerySnapshot snapshot = await query.get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error counting vouchers: $e');
      return 0;
    }
  }

  // Kích hoạt/vô hiệu hóa phiếu giảm giá
  Future<void> toggleVoucherStatus(String id, bool isActive) async {
    try {
      await _firestore.collection(_collection).doc(id).update({'isActive': isActive});
    } catch (e) {
      print('Error toggling voucher status: $e');
      throw e;
    }
  }
}
