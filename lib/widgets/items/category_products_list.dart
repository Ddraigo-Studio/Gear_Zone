import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';
import '../../model/product.dart';
import '../../model/category.dart';
import '../../controller/product_controller.dart';
import 'product_carousel_item_widget.dart';

class CategoryProductsList extends StatefulWidget {
  final CategoryModel category;
  
  const CategoryProductsList({
    super.key,
    required this.category,
  });

  @override
  State<CategoryProductsList> createState() => _CategoryProductsListState();
}

class _CategoryProductsListState extends State<CategoryProductsList> {
  final ProductController _productController = ProductController();
  List<ProductModel> products = [];
  bool isLoading = true;
  String error = '';
  StreamSubscription<List<ProductModel>>? _subscription;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      // Fallback: Nếu không có kết nối, sử dụng dữ liệu mẫu
      final sampleData = _productController.getSampleProducts();
      
      setState(() {
        products = List.from(sampleData);
        isLoading = false;
      });
      
      // Lắng nghe stream sản phẩm theo danh mục từ Firestore
      Stream<List<ProductModel>> productsStream = _productController.getProductsByCategory(widget.category.categoryName);
      _subscription = productsStream.listen((fetchedProducts) {
        if (mounted) {
          setState(() {
            products = fetchedProducts;
            isLoading = false;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Không thể tải sản phẩm: $e';
          isLoading = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    // We'll use isDesktop to adjust styling based on screen size
    final bool isDesktop = Responsive.isDesktop(context);
    
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (error.isNotEmpty) {
      return Center(
        child: Text(
          error,
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
          ),
        ),
      );
    }
    
    if (products.isEmpty) {
      return Center(
        child: Text(
          'Không có sản phẩm nào thuộc danh mục này',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }
      return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: isDesktop ? 10.h : 8.h,
            horizontal: isDesktop ? 16.h : 12.h,
          ),
          child: ProductCarouselItem(
            product: products[index],
          ),
        );
      },
    );
  }
}
