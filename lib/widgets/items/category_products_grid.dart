import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';
import '../../model/product.dart';
import '../../model/category.dart';
import '../../controller/product_controller.dart';
import 'product_carousel_item_widget.dart';

class CategoryProductsGrid extends StatefulWidget {
  final CategoryModel category;
  
  const CategoryProductsGrid({
    super.key,
    required this.category,
  });

  @override
  State<CategoryProductsGrid> createState() => _CategoryProductsGridState();
}

class _CategoryProductsGridState extends State<CategoryProductsGrid> {
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
      // Lắng nghe stream sản phẩm theo danh mục từ Firestore
      Stream<List<ProductModel>> productsStream = _productController.getProductsByCategory(widget.category.categoryName);
      _subscription = productsStream.listen((fetchedProducts) {
        if (mounted) {
          setState(() {
            products = fetchedProducts;
            isLoading = false;
          });
        }
      }, onError: (e) {
        if (mounted) {
          setState(() {
            error = 'Không thể tải sản phẩm: $e';
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
    final bool isDesktop = Responsive.isDesktop(context);
    
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(appTheme.deepPurple400),
            ),
            SizedBox(height: 16),
            Text(
              'Đang tải sản phẩm...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    if (error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              error,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProducts,
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.deepPurple400,
                foregroundColor: Colors.white,
              ),
              child: Text('Thử lại'),
            ),
          ],
        ),
      );
    }
    
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'Không có sản phẩm nào thuộc danh mục này',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 5 : 2,
        childAspectRatio: isDesktop ? 0.9 : 0.75,
        crossAxisSpacing: 18.h,
        mainAxisSpacing: 18.h,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCarouselItem(
          product: products[index],
        );
      },
    );
  }
}
