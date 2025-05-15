import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gear_zone/model/product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProductController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late final CollectionReference _productsCollection;
  
  ProductController() {
    _productsCollection = _firestore.collection('products');
  }  // Lấy danh sách sản phẩm có phân trang
  Future<Map<String, dynamic>> getProductsPaginated({int page = 1, int limit = 20}) async {
    try {
      // Lấy tổng số sản phẩm
      final totalSnapshot = await _productsCollection.get();
      final total = totalSnapshot.size;
      
      // Lấy dữ liệu sản phẩm theo trang - đối với Firestore, chúng ta cần thực hiện phân trang thủ công
      Query query = _productsCollection
          .orderBy('createdAt', descending: true)
          .limit(limit);
          
      // Nếu không phải trang đầu tiên, chúng ta cần lấy tài liệu chốt
      if (page > 1) {
        // Lấy tài liệu cuối cùng của trang trước
        final lastDoc = await _productsCollection
            .orderBy('createdAt', descending: true)
            .limit((page - 1) * limit)
            .get()
            .then((snap) => snap.docs.isNotEmpty ? snap.docs.last : null);
            
        if (lastDoc != null) {
          query = query.startAfterDocument(lastDoc);
        }
      }
      
      final QuerySnapshot querySnapshot = await query.get();
          
      // Chuyển đổi dữ liệu thành danh sách sản phẩm
      final List<ProductModel> products = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
      
      // Tính tổng số trang
      final int totalPages = (total / limit).ceil();
      
      return {
        'products': products,
        'total': total,
        'totalPages': totalPages,
        'currentPage': page,
        'hasNextPage': page < totalPages,
        'hasPreviousPage': page > 1,
      };
    } catch (e) {
      print('Lỗi khi lấy sản phẩm phân trang: $e');
      return {
        'products': <ProductModel>[],
        'total': 0,
        'totalPages': 1,
        'currentPage': 1,
        'hasNextPage': false,
        'hasPreviousPage': false,
      };
    }
  }
    // Lấy danh sách sản phẩm theo danh mục có phân trang
  Future<Map<String, dynamic>> getProductsByCategoryPaginated(
      String category, {int page = 1, int limit = 20}) async {
    try {
      // Lấy tổng số sản phẩm của danh mục
      final totalSnapshot = await _productsCollection
          .where('category', isEqualTo: category)
          .get();
      final total = totalSnapshot.size;
      
      // Lấy dữ liệu sản phẩm theo trang - đối với Firestore, chúng ta cần thực hiện phân trang thủ công
      // Vì Firestore không hỗ trợ offset trực tiếp, chúng ta sẽ dùng startAfter để lấy trang tiếp theo
      Query query = _productsCollection
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .limit(limit);
          
      // Nếu không phải trang đầu tiên, chúng ta cần lấy tài liệu chốt
      if (page > 1) {
        // Lấy tài liệu cuối cùng của trang trước
        final lastDoc = await _productsCollection
            .where('category', isEqualTo: category)
            .orderBy('createdAt', descending: true)
            .limit((page - 1) * limit)
            .get()
            .then((snap) => snap.docs.isNotEmpty ? snap.docs.last : null);
            
        if (lastDoc != null) {
          query = query.startAfterDocument(lastDoc);
        }
      }
      
      final QuerySnapshot querySnapshot = await query.get();
          
      // Chuyển đổi dữ liệu thành danh sách sản phẩm
      final List<ProductModel> products = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
      
      // Tính tổng số trang
      final int totalPages = (total / limit).ceil();
      
      return {
        'products': products,
        'total': total,
        'totalPages': totalPages,
        'currentPage': page,
        'hasNextPage': page < totalPages,
        'hasPreviousPage': page > 1,
      };
    } catch (e) {
      print('Lỗi khi lấy sản phẩm theo danh mục phân trang: $e');
      return {
        'products': <ProductModel>[],
        'total': 0,
        'totalPages': 1,
        'currentPage': 1,
        'hasNextPage': false,
        'hasPreviousPage': false,
      };
    }
  }

  // Giữ các phương thức stream cho khả năng tương thích ngược
  Stream<List<ProductModel>> getProducts() {
    return _productsCollection
        .orderBy('createdAt', descending: true)
        .limit(20) // Giới hạn 20 sản phẩm mặc định
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    });
  }
  
  // Cập nhật phương thức lấy sản phẩm theo danh mục với giới hạn
  Stream<List<ProductModel>> getProductsByCategory(String category) {
    return _productsCollection
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .limit(20) // Giới hạn 20 sản phẩm mặc định
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

  // Lấy danh sách sản phẩm khuyến mãi (có giảm giá > 0%)
  Stream<List<ProductModel>> getPromotionProducts() {
    return _productsCollection
        .where('discount', isGreaterThan: 0)
        .orderBy('discount', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    });
  }

  // Lấy danh sách sản phẩm mới nhất
  Stream<List<ProductModel>> getNewestProducts() {
    return _productsCollection
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    });
  }

  // Lấy danh sách sản phẩm bán chạy nhất (giả lập, trong thực tế sẽ dựa trên số lượng đã bán)
  Future<List<ProductModel>> getBestSellingProducts() async {
    try {
      // Trong môi trường thực, bạn sẽ có một field như "soldCount" để sắp xếp
      // Ở đây chúng ta giả lập bằng cách lấy sản phẩm giảm giá nhiều nhất
      QuerySnapshot snapshot = await _productsCollection
          .orderBy('discount', descending: true)
          .limit(10)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy sản phẩm bán chạy: $e');
      return [];
    }
  }

  // Lấy danh sách mẫu sản phẩm cho trường hợp không có kết nối Firebase
  List<ProductModel> getSampleProducts() {
    // Sử dụng dữ liệu mẫu từ SampleData.sampleProducts
    // Danh sách này có thể được mở rộng trong model/sample_data.dart
    return List.from(sampleProducts);
  }

  // Lấy sản phẩm theo danh mục cụ thể: Laptop
  Future<List<ProductModel>> getLaptopProducts() async {
    try {
      QuerySnapshot snapshot = await _productsCollection
          .where('category', isEqualTo: 'Laptop')
          .limit(10)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy sản phẩm laptop: $e');
      return [];
    }
  }

  // Lấy sản phẩm theo danh mục cụ thể: Màn hình
  Future<List<ProductModel>> getMonitorProducts() async {
    try {
      QuerySnapshot snapshot = await _productsCollection
          .where('category', isEqualTo: 'Màn hình')
          .limit(10)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy sản phẩm màn hình: $e');
      return [];
    }
  }

  // Lấy sản phẩm theo danh mục cụ thể: Bàn phím
  Future<List<ProductModel>> getKeyboardProducts() async {
    try {
      QuerySnapshot snapshot = await _productsCollection
          .where('category', isEqualTo: 'PC')
          .limit(10)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy sản phẩm bàn phím: $e');
      return [];
    }
  }

  // Lấy sản phẩm theo danh mục cụ thể: Chuột
  Future<List<ProductModel>> getMouseProducts() async {
    try {
      QuerySnapshot snapshot = await _productsCollection
          .where('category', isEqualTo: 'Chuột')
          .limit(10)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy sản phẩm chuột: $e');
      return [];
    }
  }

  // Lấy sản phẩm theo danh mục cụ thể: Tai nghe
  Future<List<ProductModel>> getHeadphoneProducts() async {
    try {
      QuerySnapshot snapshot = await _productsCollection
          .where('category', isEqualTo: 'Tai nghe')
          .limit(10)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy sản phẩm tai nghe: $e');
      return [];
    }  
  }

  Future<List<ProductModel>> getlaptopGamingProducts() async {
    try {
      QuerySnapshot snapshot = await _productsCollection
          .where('category', isEqualTo: 'Laptop Gaming')
          .limit(10)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy sản phẩm PC: $e');
      return [];
    }  
  }
  // Đếm tổng số sản phẩm trong database
  Future<int> getTotalProductCount() async {
    try {
      final QuerySnapshot snapshot = await _productsCollection.get();
      return snapshot.docs.length;
    } catch (e) {
      print('Lỗi khi đếm tổng số sản phẩm: $e');
      return 0;
    }
  }
  
  // Đếm số sản phẩm theo danh mục  
  Future<int> countProductsByCategory(String categoryName) async {
    try {
      final QuerySnapshot snapshot = 
          await _productsCollection.where('category', isEqualTo: categoryName).get();
      return snapshot.docs.length;
    } catch (e) {
      print('Lỗi khi đếm sản phẩm theo danh mục: $e');
      return 0;
    }
  }

  // Lấy sản phẩm theo danh mục cụ thể truyền vào (Future version)
  Future<List<ProductModel>> getProductsByCategoryFuture(String categoryName) async {
    try {
      QuerySnapshot snapshot = await _productsCollection
          .where('category', isEqualTo: categoryName)
          .limit(20)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy sản phẩm theo danh mục $categoryName: $e');
      return [];
    }
  }

  // Biến static để cache dữ liệu mẫu cho trường hợp không có kết nối đến Firebase
  static List<ProductModel> sampleProducts = [];
}
