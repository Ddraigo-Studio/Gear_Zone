import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/category.dart';
import 'product_controller.dart';

class CategoryController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _categoriesCollection;
  
  CategoryController() {
    _categoriesCollection = _firestore.collection('categories');
  }
  
  // Lấy danh sách danh mục có phân trang
  Future<Map<String, dynamic>> getCategoriesPaginated({int page = 1, int limit = 20}) async {
    try {
      // Lấy tổng số danh mục
      final totalSnapshot = await _categoriesCollection.get();
      final total = totalSnapshot.size;
      
      // Lấy dữ liệu danh mục theo trang - đối với Firestore, chúng ta cần thực hiện phân trang thủ công
      Query query = _categoriesCollection
          .orderBy('ceatedAt', descending: true)
          .limit(limit);
          
      // Nếu không phải trang đầu tiên, chúng ta cần lấy tài liệu chốt
      if (page > 1) {
        // Lấy tài liệu cuối cùng của trang trước
        final lastDoc = await _categoriesCollection
            .orderBy('ceatedAt', descending: true)
            .limit((page - 1) * limit)
            .get()
            .then((snap) => snap.docs.isNotEmpty ? snap.docs.last : null);
            
        if (lastDoc != null) {
          query = query.startAfterDocument(lastDoc);
        }
      }
      
      final QuerySnapshot querySnapshot = await query.get();
          
      // Chuyển đổi dữ liệu thành danh sách danh mục
      final List<CategoryModel> categories = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return CategoryModel.fromMap(data);
      }).toList();
      
      // Tính tổng số trang
      final int totalPages = (total / limit).ceil();
      
      return {
        'categories': categories,
        'total': total,
        'totalPages': totalPages,
        'currentPage': page,
        'hasNextPage': page < totalPages,
        'hasPreviousPage': page > 1,
      };
    } catch (e) {
      print('Lỗi khi lấy danh mục phân trang: $e');
      return {
        'categories': <CategoryModel>[],
        'total': 0,
        'totalPages': 1,
        'currentPage': 1,
        'hasNextPage': false,
        'hasPreviousPage': false,
      };
    }
  }

  // Lấy danh sách danh mục từ Firestore (giữ lại cho khả năng tương thích ngược)
  Stream<List<CategoryModel>> getCategories() {
    return _categoriesCollection
        .orderBy('ceatedAt', descending: true)
        .limit(20) // Giới hạn 20 danh mục mặc định
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
      
      // Lấy danh mục cũ để kiểm tra tên đã thay đổi chưa
      final oldCategoryDoc = await _categoriesCollection.doc(category.id).get();
      final oldCategoryData = oldCategoryDoc.data() as Map<String, dynamic>?;
      
      if (oldCategoryData != null) {
        final oldCategoryName = oldCategoryData['categoryName'] as String;
        
        // Nếu tên danh mục đã thay đổi, cập nhật các sản phẩm
        if (oldCategoryName != category.categoryName) {
          print('Tên danh mục đã thay đổi từ "$oldCategoryName" thành "${category.categoryName}"');
          
          // Cập nhật danh mục trước
          await _categoriesCollection.doc(category.id).update(category.toMap());
          
          // Sau đó cập nhật tất cả sản phẩm thuộc danh mục này
          final productController = ProductController();
          final productsUpdated = await productController.updateProductsCategory(
            oldCategoryName, 
            category.categoryName
          );
          
          if (!productsUpdated) {
            print('Cập nhật danh mục thành công nhưng cập nhật sản phẩm thất bại');
          }
          
          return true;
        }
      }
      
      // Nếu tên không thay đổi hoặc không tìm thấy danh mục cũ
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

  // Tìm kiếm danh mục có phân trang
  Future<Map<String, dynamic>> searchCategoriesPaginated(String query, {int page = 1, int limit = 20}) async {
    query = query.toLowerCase();
    try {
      // Lấy tất cả danh mục để tìm kiếm và lọc (vì Firestore không hỗ trợ tìm kiếm text trực tiếp)
      QuerySnapshot allCategoriesSnapshot = await _categoriesCollection.get();
      
      // Lọc danh mục theo query
      List<DocumentSnapshot> filteredDocs = allCategoriesSnapshot.docs.where((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String categoryName = (data['categoryName'] ?? '').toLowerCase();
        String id = doc.id.toLowerCase();
        
        return categoryName.contains(query) || id.contains(query);
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
      
      // Chuyển đổi sang CategoryModel
      List<CategoryModel> categories = pagedDocs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return CategoryModel.fromMap(data);
      }).toList();
      
      // Trả về kết quả bao gồm dữ liệu và thông tin phân trang
      return {
        'categories': categories,
        'total': totalItems,
        'totalPages': totalPages > 0 ? totalPages : 1,
        'currentPage': page,
        'hasNextPage': page < totalPages,
        'hasPreviousPage': page > 1,
      };
    } catch (e) {
      print('Error searching paginated categories: $e');
      throw e;
    }
  }
}
