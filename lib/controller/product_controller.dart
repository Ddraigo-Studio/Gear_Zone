import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gear_zone/model/product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:async';

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
      // print('Lỗi khi lấy sản phẩm phân trang: $e');
      return {
        'products': <ProductModel>[],
        'total': 0,
        'totalPages': 1,
        'currentPage': 1,
        'hasNextPage': false,
        'hasPreviousPage': false,
      };
    }  }  
  
  // Lấy danh sách sản phẩm theo danh mục có phân trang  
  Future<Map<String, dynamic>> getProductsByCategoryPaginated(
      String category, {int page = 1, int limit = 20}) async {
    // print('Đang lấy sản phẩm theo danh mục: "$category", trang: $page, limit: $limit');
    
    try {
      if (category.isEmpty) {
        // print('Danh mục trống, chuyển sang lấy tất cả sản phẩm');
        return await getProductsPaginated(page: page, limit: limit);
      }
        // Kiểm tra trước nếu có sản phẩm với danh mục tương tự nhưng khác chữ hoa/thường
      final allProductsSnap = await _productsCollection.get();      
      final matchingDocs = allProductsSnap.docs.where((doc) {
        final docCategory = (doc.data() as Map<String, dynamic>)['category']?.toString();
        return docCategory != null && 
               docCategory.toLowerCase() == category.toLowerCase();
      }).toList();
      
      final int matchingCount = matchingDocs.length;
      
      if (matchingCount > 0) {
        // print('Tìm thấy $matchingCount sản phẩm với danh mục tương tự: "$category"');
          // Lấy tên danh mục chính xác từ sản phẩm đầu tiên tìm thấy
        final String exactCategoryName = (matchingDocs.first.data() as Map<String, dynamic>)['category'] as String;
        // print('Sử dụng tên danh mục chính xác: "$exactCategoryName"');
        
        // Sử dụng tên danh mục chính xác để truy vấn
        final totalSnapshot = await _productsCollection
            .where('category', isEqualTo: exactCategoryName)
            .get();
        final total = totalSnapshot.size;
        
        // print('Tổng số sản phẩm theo danh mục "$exactCategoryName": $total');
          if (total == 0) {
          // print('Không có sản phẩm nào thuộc danh mục: "$exactCategoryName" (lỗi không mong muốn)');
          return {
            'products': <ProductModel>[],
            'total': 0,
            'totalPages': 1,
            'currentPage': 1,
            'hasNextPage': false,
            'hasPreviousPage': false,
          };
        }
        
        // Lấy dữ liệu sản phẩm theo trang - đối với Firestore, chúng ta cần thực hiện phân trang thủ công
        // Sử dụng tên danh mục chính xác thay vì tên danh mục ban đầu
        Query query = _productsCollection
          .where('category', isEqualTo: exactCategoryName)
          .orderBy('createdAt', descending: true)
          .limit(limit);
          
        // Nếu không phải trang đầu tiên, chúng ta cần lấy tài liệu chốt
        if (page > 1) {
          // Lấy tài liệu cuối cùng của trang trước
          final lastDoc = await _productsCollection
              .where('category', isEqualTo: exactCategoryName)
              .orderBy('createdAt', descending: true)
              .limit((page - 1) * limit)
              .get()
              .then((snap) => snap.docs.isNotEmpty ? snap.docs.last : null);
              
          if (lastDoc != null) {
            query = query.startAfterDocument(lastDoc);
            // print('Sử dụng document chốt để lấy trang tiếp theo');
          } else {
            // print('Không tìm thấy document chốt cho trang $page');
          }
        }
        
        // Attempt paginated query
        try {
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
        } on FirebaseException catch (e) {
          if (e.code == 'failed-precondition') {
            // Fallback: return first page of results without pagination
            final List<ProductModel> fallbackProducts = matchingDocs
                .map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  data['id'] = doc.id;
                  return ProductModel.fromMap(data);
                })
                .toList();
            final int totalPages = (fallbackProducts.length / limit).ceil();
            return {
              'products': fallbackProducts,
              'total': fallbackProducts.length,
              'totalPages': totalPages > 0 ? totalPages : 1,
              'currentPage': 1,
              'hasNextPage': false,
              'hasPreviousPage': false,
            };
          }
          rethrow;
        }
      }
      
      // Nếu không tìm thấy sản phẩm nào có danh mục tương tự, tiếp tục tìm kiếm theo cách thông thường
      final totalSnapshot = await _productsCollection
          .where('category', isEqualTo: category)
          .get();
      final total = totalSnapshot.size;
      
      
      if (total == 0) {
        return {
          'products': <ProductModel>[],
          'total': 0,
          'totalPages': 1,
          'currentPage': 1,
          'hasNextPage': false,
          'hasPreviousPage': false,
        };
      }
      
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
          // print('Sử dụng document chốt để lấy trang tiếp theo');
        } else {
          // print('Không tìm thấy document chốt cho trang $page');
        }
      }
      
      final QuerySnapshot querySnapshot = await query.get();
      // print('Đã truy vấn được ${querySnapshot.docs.length} sản phẩm');
          
      // Chuyển đổi dữ liệu thành danh sách sản phẩm
      final List<ProductModel> products = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
      
      // Tính tổng số trang
      final int totalPages = (total / limit).ceil();
      
      // print('Tổng số trang: $totalPages, Trang hiện tại: $page');
      // print('Sản phẩm đã lấy: ${products.length}');
      
      return {
        'products': products,
        'total': total,
        'totalPages': totalPages,
        'currentPage': page,
        'hasNextPage': page < totalPages,
        'hasPreviousPage': page > 1,
      };    } catch (e) {
      // print('Lỗi khi lấy sản phẩm theo danh mục "$category" phân trang: $e');
      // print('Stack trace: ${StackTrace.current}');
        // Thử kiểm tra tên danh mục với cách viết hoa/thường khác nhau
      try {
        // print('Đang thử tìm kiếm sản phẩm với danh mục tương tự...');
        final allProducts = await _productsCollection.get();
        // Fixed: Handle nullable strings properly by converting to non-nullable strings
        final List<String> categories = allProducts.docs
            .map((doc) => (doc.data() as Map<String, dynamic>)['category']?.toString())
            .where((cat) => cat != null) // Filter out nulls
            .map((cat) => cat!) // Convert String? to String using non-null assertion
            .toSet() // Remove duplicates
            .toList();
        
        // print('Các danh mục có sẵn: ${categories.join(", ")}');
        
        final similarCategories = categories.where(
          (cat) => cat.toLowerCase() == category.toLowerCase()
        ).toList();
        
        if (similarCategories.isNotEmpty) {
          // print('Tìm thấy danh mục có thể tương thích: ${similarCategories.join(", ")}');
        }
      } catch (innerError) {
        // print('Lỗi khi kiểm tra danh mục tương tự: $innerError');
      }
      
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
  Stream<List<ProductModel>> getProducts() {
    return _productsCollection
        .orderBy('createdAt', descending: true)
        .limit(20) 
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    });
  }
  Stream<List<ProductModel>> getProductsByCategory(String category) {
    
    if (category.isEmpty) {
      return Stream.value(<ProductModel>[]);
    }
    
    // Sử dụng StreamController để quản lý luồng dữ liệu - broadcast để nhiều người có thể lắng nghe
    final controller = StreamController<List<ProductModel>>.broadcast();
    
    _productsCollection.get().then((allDocs) {
      final allCategories = allDocs.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['category']?.toString() ?? "null")
        .where((cat) => cat != "null")
        .toSet()
        .toList();
      
      if (category.toLowerCase() == "loa") {
        // print('🔍 DEBUG DANH MỤC LOA:');
        for (var doc in allDocs.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final productCategory = data['category']?.toString() ?? "null";
          final productName = data['name']?.toString() ?? "Không có tên";
          
          // print('🔍 Sản phẩm: "$productName" - Danh mục: "$productCategory" (lowercase: "${productCategory.toLowerCase()}")');
        }
      }
      
      // Trước tiên, thu thập tất cả các document có category phù hợp (không phân biệt hoa/thường)
      final matchingDocs = allDocs.docs.where((doc) {
        final docCategory = (doc.data() as Map<String, dynamic>)['category']?.toString();
        final isMatch = docCategory != null && 
              docCategory.toLowerCase() == category.toLowerCase();
              
        // In ra thông tin để debug
        if (isMatch) {
          // print('✅ Tìm thấy kết quả cho danh mục "$category": Document với category="$docCategory"');
        }
        
        return isMatch;
      }).toList();
      
      // print('Tổng số document phù hợp: ${matchingDocs.length}');
      
      if (matchingDocs.isNotEmpty) {
        final String exactCategoryName = (matchingDocs.first.data() as Map<String, dynamic>)['category'] as String;
       
        final List<ProductModel> immediateProducts = matchingDocs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          final product = ProductModel.fromMap(data);
         
          return product;
        }).toList();
        
     
        if (!controller.isClosed) {
          controller.add(immediateProducts);
        }
        
        // Tiếp tục lắng nghe thay đổi với danh mục chính xác
        final subscription = _productsCollection
            .where('category', isEqualTo: exactCategoryName)
            .orderBy('createdAt', descending: true)
            .snapshots()
            .listen(
              (snapshot) {
                if (controller.isClosed) return;
                
                final products = snapshot.docs.map((doc) {
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  data['id'] = doc.id;
                  return ProductModel.fromMap(data);
                }).toList();
                
                // print('Stream cập nhật: ${products.length} sản phẩm cho danh mục "$exactCategoryName"');
                controller.add(products);
              },
              onError: (error) {
                if (controller.isClosed) return;
                
                // print('Lỗi khi lấy sản phẩm theo danh mục: $error');
                controller.addError(error);
              }
            );
        
        // Đảm bảo subscription được hủy khi StreamController đóng
        controller.onCancel = () {
          // print('Đóng subscription cho danh mục "$exactCategoryName"');
          subscription.cancel();
        };
      } else {
        // Nếu không tìm thấy, trả về danh sách rỗng
        // print('Không tìm thấy sản phẩm nào với danh mục phù hợp: "$category"');
        controller.add(<ProductModel>[]);
      }
    }).catchError((error) {
      // print('Lỗi khi tìm kiếm danh mục: $error');
      controller.addError(error);
      // Không đóng controller ở đây, để cho phép người dùng thực hiện các thao tác khác
    });
    
    return controller.stream;
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
      // print('Lỗi khi lấy sản phẩm: $e');
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
      product.createdAt ??= DateTime.now();
      
      // Chuyển đổi sản phẩm thành Map
      Map<String, dynamic> productMap = product.toMap();
      
      // Lưu vào Firestore
      await _productsCollection.doc(productId).set(productMap);
      
      return productId;
    } catch (e) {
      // print('Lỗi khi thêm sản phẩm: $e');
      return null;
    }
  }

  // Cập nhật sản phẩm
  Future<bool> updateProduct(ProductModel product) async {
    try {
      if (product.id.isEmpty) {
        // print('Không thể cập nhật sản phẩm: ID không tồn tại');
        return false;
      }

      await _productsCollection.doc(product.id).update(product.toMap());
      return true;
    } catch (e) {
      // print('Lỗi khi cập nhật sản phẩm: $e');
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
      // print('Lỗi khi xóa sản phẩm: $e');
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
      // print('Lỗi khi tải lên hình ảnh sản phẩm: $e');
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
  }  // Lấy danh sách sản phẩm khuyến mãi (có mảng promotions không rỗng)
  Stream<List<ProductModel>> getPromotionProducts({int limit = 10}) {
    // Không thể sử dụng query trực tiếp để kiểm tra mảng không rỗng trong Firebase,
    // nên chúng ta sẽ lấy nhiều sản phẩm hơn và lọc trong code
    return _productsCollection
        .orderBy('createdAt', descending: true)
        .limit(limit * 3) // Lấy nhiều hơn để đảm bảo đủ sản phẩm sau khi lọc
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
        .map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return ProductModel.fromMap(data);
        })
        .where((product) => 
          product.promotions != null && product.promotions.isNotEmpty
        )
        .take(limit)
        .toList();
    });
  }  // Lấy danh sách sản phẩm mới nhất
  Stream<List<ProductModel>> getNewestProducts({int limit = 10}) {
    return _productsCollection
        .orderBy('createdAt', descending: true)
        .limit(limit)
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
  Future<List<ProductModel>> getBestSellingProducts({int limit = 10}) async {
    try {
      // Trong môi trường thực, bạn sẽ có một field như "soldCount" để sắp xếp
      // Ở đây chúng ta giả lập bằng cách lấy sản phẩm giảm giá nhiều nhất
      QuerySnapshot snapshot = await _productsCollection
          .orderBy('discount', descending: true)
          .limit(limit)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      // print('Lỗi khi lấy sản phẩm bán chạy: $e');
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
      // print('Lỗi khi lấy sản phẩm laptop: $e');
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
      // print('Lỗi khi lấy sản phẩm màn hình: $e');
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
      // print('Lỗi khi lấy sản phẩm bàn phím: $e');
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
      // print('Lỗi khi lấy sản phẩm chuột: $e');
      return [];
    }
  }
  
  // Lấy sản phẩm theo danh mục cụ thể: Loa
  Future<List<ProductModel>> getSpeakerProducts() async {
    try {
      QuerySnapshot snapshot = await _productsCollection
          .where('category', isEqualTo: 'Loa')
          .limit(10)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      // print('Lỗi khi lấy sản phẩm loa: $e');
      return [];
    }
  }
  
  // Lấy sản phẩm theo danh mục cụ thể: Case
  Future<List<ProductModel>> getCaseProducts() async {
    try {
      QuerySnapshot snapshot = await _productsCollection
          .where('category', isEqualTo: 'Case')
          .limit(10)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      // print('Lỗi khi lấy sản phẩm case: $e');
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
      // print('Lỗi khi lấy sản phẩm tai nghe: $e');
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
      // print('Lỗi khi lấy sản phẩm PC: $e');
      return [];
    }  
  }
  // Đếm tổng số sản phẩm trong database
  Future<int> getTotalProductCount() async {
    try {
      final QuerySnapshot snapshot = await _productsCollection.get();
      return snapshot.docs.length;
    } catch (e) {
      // print('Lỗi khi đếm tổng số sản phẩm: $e');
      return 0;
    }
  }
    // Đếm số sản phẩm theo danh mục  
  Future<int> countProductsByCategory(String categoryName) async {
    try {
      // print('Đếm sản phẩm theo danh mục: "$categoryName" (lowercase: "${categoryName.toLowerCase()}")');
        // Đầu tiên tìm chính xác trước
      final QuerySnapshot snapshot = 
          await _productsCollection.where('category', isEqualTo: categoryName).get();
      
      if (snapshot.docs.isNotEmpty) {
        // print('✅ Đếm: Tìm thấy sản phẩm khớp với category="$categoryName"');
        return snapshot.docs.length;
      }
      
      // Nếu không tìm thấy, thử tìm không phân biệt chữ hoa/thường
      final allDocsSnapshot = await _productsCollection.get();
      final matchingDocs = allDocsSnapshot.docs.where((doc) {
        final docCategory = (doc.data() as Map<String, dynamic>)['category']?.toString();
        final isMatch = docCategory != null && 
              docCategory.toLowerCase() == categoryName.toLowerCase();
        if (isMatch) {
          // print('✅ Đếm: Tìm thấy sản phẩm khớp với category="$docCategory" (case-insensitive)');
        }
        return isMatch;
      }).toList();
      
      return matchingDocs.length;
    } catch (e) {
      // print('Lỗi khi đếm sản phẩm theo danh mục: $e');
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
      // print('Lỗi khi lấy sản phẩm theo danh mục $categoryName: $e');
      return [];
    }
  }

  // Biến static để cache dữ liệu mẫu cho trường hợp không có kết nối đến Firebase
  static List<ProductModel> sampleProducts = [];

  // Cập nhật tên danh mục cho tất cả sản phẩm thuộc danh mục đó
  Future<bool> updateProductsCategory(String oldCategoryName, String newCategoryName) async {
    try {
      // Lấy tất cả sản phẩm thuộc danh mục cũ
      final querySnapshot = await _productsCollection
          .where('category', isEqualTo: oldCategoryName)
          .get();
      
      if (querySnapshot.docs.isEmpty) {
        print('Không có sản phẩm nào thuộc danh mục: $oldCategoryName');
        return true; // Không có sản phẩm nào cần cập nhật
      }
      
      // Tạo batch để cập nhật hàng loạt
      final batch = _firestore.batch();
      
      // Cập nhật tất cả sản phẩm
      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {'category': newCategoryName});
      }
      
      // Thực hiện cập nhật hàng loạt
      await batch.commit();
      
      print('Đã cập nhật ${querySnapshot.docs.length} sản phẩm từ "$oldCategoryName" thành "$newCategoryName"');
      return true;
    } catch (e) {
      print('Lỗi khi cập nhật danh mục sản phẩm: $e');
      return false;
    }
  }

  // Tìm kiếm sản phẩm có phân trang
  Future<Map<String, dynamic>> searchProductsPaginated(String query, {int page = 1, int limit = 20}) async {
    query = query.toLowerCase();
    try {
      // Lấy tất cả sản phẩm để tìm kiếm và lọc (vì Firestore không hỗ trợ tìm kiếm text trực tiếp)
      QuerySnapshot allProductsSnapshot = await _productsCollection.get();
      
      // Lọc sản phẩm theo query
      List<DocumentSnapshot> filteredDocs = allProductsSnapshot.docs.where((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String name = (data['name'] ?? '').toLowerCase();
        String id = doc.id.toLowerCase();
        String category = (data['category'] ?? '').toLowerCase();
        String code = (data['productCode'] ?? '').toLowerCase();
        
        return name.contains(query) || id.contains(query) || 
               category.contains(query) || code.contains(query);
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
      
      // Chuyển đổi sang ProductModel
      List<ProductModel> products = pagedDocs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
      
      // Trả về kết quả bao gồm dữ liệu và thông tin phân trang
      return {
        'products': products,
        'total': totalItems,
        'totalPages': totalPages > 0 ? totalPages : 1,
        'currentPage': page,
        'hasNextPage': page < totalPages,
        'hasPreviousPage': page > 1,
      };
    } catch (e) {
      print('Error searching paginated products: $e');
      throw e;
    }
  }
}
