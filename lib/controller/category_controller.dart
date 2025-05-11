import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/category.dart';

class CategoryController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _categoriesCollection;
  
  CategoryController() {
    _categoriesCollection = _firestore.collection('categories');
  }
  // Lấy danh sách danh mục từ Firestore
  Stream<List<CategoryModel>> getCategories() {
    return _categoriesCollection
        .orderBy('ceatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return CategoryModel.fromMap(data);
      }).toList();
    });
  }
  
  // Lấy số lượng danh mục từ Firestore
  Future<int> getCategoriesCount() async {
    try {
      final snapshot = await _categoriesCollection.get();
      return snapshot.docs.length;
    } catch (e) {
      print('Lỗi khi lấy số lượng danh mục: $e');
      return 0;
    }
  }

  // Lấy chi tiết một danh mục theo ID
  Future<CategoryModel?> getCategoryById(String categoryId) async {
    try {
      DocumentSnapshot doc = await _categoriesCollection.doc(categoryId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return CategoryModel.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Lỗi khi lấy danh mục: $e');
      return null;
    }
  }

  // Thêm danh mục mới
  Future<String?> addCategory(CategoryModel category) async {
    try {
      // Tạo ID mới nếu ID chưa được đặt
      String categoryId = category.id.isEmpty ? _categoriesCollection.doc().id : category.id;
      
      // Đảm bảo danh mục có ID
      CategoryModel updatedCategory = category.copyWith(id: categoryId);
      
      // Chuyển đổi danh mục thành Map
      Map<String, dynamic> categoryMap = updatedCategory.toMap();
      
      // Lưu vào Firestore
      await _categoriesCollection.doc(categoryId).set(categoryMap);
      
      return categoryId;
    } catch (e) {
      print('Lỗi khi thêm danh mục: $e');
      return null;
    }
  }

  // Cập nhật danh mục
  Future<bool> updateCategory(CategoryModel category) async {
    try {
      if (category.id.isEmpty) {
        print('Không thể cập nhật danh mục: ID không tồn tại');
        return false;
      }

      await _categoriesCollection.doc(category.id).update(category.toMap());
      return true;
    } catch (e) {
      print('Lỗi khi cập nhật danh mục: $e');
      return false;
    }
  }

  // Xóa danh mục
  Future<bool> deleteCategory(String categoryId) async {
    try {
      await _categoriesCollection.doc(categoryId).delete();
      return true;
    } catch (e) {
      print('Lỗi khi xóa danh mục: $e');
      return false;
    }
  }
  // Lấy danh mục theo tên
  Future<CategoryModel?> getCategoryByName(String categoryName) async {
    try {
      final snapshot = await _categoriesCollection
          .where('categoryName', isEqualTo: categoryName)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return CategoryModel.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Lỗi khi lấy danh mục theo tên: $e');
      return null;
    }
  }
}
