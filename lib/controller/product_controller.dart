import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gear_zone/model/product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProductController {  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late final CollectionReference _productsCollection;
  
  ProductController() {
    _productsCollection = _firestore.collection('products');
  }

  // Lấy danh sách sản phẩm
  Stream<List<ProductModel>> getProducts() {
    return _productsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    });
  }

  // Lấy chi tiết một sản phẩm theo ID
  Future<ProductModel?> getProductById(String productId) async {
    try {
      DocumentSnapshot doc = await _productsCollection.doc(productId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Lỗi khi lấy sản phẩm: $e');
      return null;
    }
  }

  // Thêm sản phẩm mới
  Future<String?> addProduct(ProductModel product) async {
    try {
      // Tạo ID mới nếu ID chưa được đặt
      String productId = product.id.isEmpty ? _productsCollection.doc().id : product.id;
      
      // Đảm bảo sản phẩm có ID
      product.id = productId;
      
      // Thêm thời gian tạo nếu chưa có
      if (product.createdAt == null) {
        product.createdAt = DateTime.now();
      }
      
      // Chuyển đổi sản phẩm thành Map
      Map<String, dynamic> productMap = product.toMap();
      
      // Lưu vào Firestore
      await _productsCollection.doc(productId).set(productMap);
      
      return productId;
    } catch (e) {
      print('Lỗi khi thêm sản phẩm: $e');
      return null;
    }
  }

  // Cập nhật sản phẩm
  Future<bool> updateProduct(ProductModel product) async {
    try {
      if (product.id.isEmpty) {
        print('Không thể cập nhật sản phẩm: ID không tồn tại');
        return false;
      }

      await _productsCollection.doc(product.id).update(product.toMap());
      return true;
    } catch (e) {
      print('Lỗi khi cập nhật sản phẩm: $e');
      return false;
    }
  }

  // Xóa sản phẩm
  Future<bool> deleteProduct(String productId) async {
    try {
      // Xóa ảnh sản phẩm nếu có
      ProductModel? product = await getProductById(productId);
      if (product != null) {
        if (product.imageUrl.isNotEmpty && product.imageUrl.startsWith('gs://')) {
          await _storage.refFromURL(product.imageUrl).delete();
        }
        
        // Xóa các ảnh phụ
        for (String imageUrl in product.additionalImages) {
          if (imageUrl.isNotEmpty && imageUrl.startsWith('gs://')) {
            await _storage.refFromURL(imageUrl).delete();
          }
        }
      }
      
      // Xóa sản phẩm từ Firestore
      await _productsCollection.doc(productId).delete();
      return true;
    } catch (e) {
      print('Lỗi khi xóa sản phẩm: $e');
      return false;
    }
  }

  // Tải lên hình ảnh và lấy URL
  Future<String?> uploadProductImage(File imageFile, String productId, {bool isMainImage = true}) async {
    try {
      String fileName = isMainImage 
          ? '${productId}_main.jpg'
          : '${productId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // Tạo reference đến file trên Storage
      Reference storageReference = _storage.ref().child('products/$productId/$fileName');
      
      // Tải file lên
      UploadTask uploadTask = storageReference.putFile(imageFile);
      
      // Đợi cho đến khi hoàn thành và lấy URL download
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      print('Lỗi khi tải lên hình ảnh sản phẩm: $e');
      return null;
    }
  }

  // Tìm kiếm sản phẩm theo từ khóa
  Stream<List<ProductModel>> searchProducts(String keyword) {
    return _productsCollection
        .orderBy('name')
        .startAt([keyword])
        .endAt([keyword + '\uf8ff'])
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    });
  }

  // Lọc sản phẩm theo danh mục
  Stream<List<ProductModel>> getProductsByCategory(String category) {
    return _productsCollection
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    });
  }
}
