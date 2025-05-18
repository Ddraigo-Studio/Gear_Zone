import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';
import '../../model/product.dart';
import '../../widgets/items/product_carousel_item_widget.dart';
import '../../controller/product_controller.dart';
import '../../widgets/cart_icon_button.dart';

enum SpecialProductType {
  newest,
  bestSelling,
  promotion,
}

class SpecialProductsPage extends StatefulWidget {
  final SpecialProductType type;
  final String title;

  const SpecialProductsPage({
    super.key,
    required this.type,
    required this.title,
  });

  @override
  State<SpecialProductsPage> createState() => _SpecialProductsPageState();
}

class _SpecialProductsPageState extends State<SpecialProductsPage> {
  final ProductController _productController = ProductController();
  List<ProductModel> products = [];
  bool isLoading = true;
  String error = '';
  Stream<List<ProductModel>>? _productsStream;
  
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }
  
  void _loadProducts() {
    setState(() {
      isLoading = true;
      error = '';
    });
    
    try {
      switch (widget.type) {
        case SpecialProductType.newest:
          _productsStream = _productController.getNewestProducts(limit: 50);
          break;
        case SpecialProductType.promotion:
          _productsStream = _productController.getPromotionProducts(limit: 50);
          break;
        case SpecialProductType.bestSelling:
          // Since best selling is using Future instead of Stream in controller
          _loadBestSellingProducts();
          return;
      }
      
      if (_productsStream != null) {
        _productsStream!.listen((loadedProducts) {
          if (mounted) {
            setState(() {
              products = loadedProducts;
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
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Đã xảy ra lỗi: $e';
          isLoading = false;
        });
      }
    }
  }
  
  void _loadBestSellingProducts() async {
    try {
      final loadedProducts = await _productController.getBestSellingProducts(limit: 50);
      if (mounted) {
        setState(() {
          products = loadedProducts;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Không thể tải sản phẩm bán chạy: $e';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: CustomTextStyles.titleMediumBalooBhai2Gray700,
        ),
        backgroundColor: appTheme.whiteA700,
        foregroundColor: Colors.grey.shade400,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          CartIconButton(
            iconSize: isDesktop ? 40.h : null, 
          ),
          SizedBox(width: 10),
        ],
      ),
      body: isLoading
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(appTheme.deepPurple400),
            ),
          )
        : error.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.h,
                        vertical: 12.h,
                      ),
                    ),
                    child: Text('Thử lại'),
                  ),
                ],
              ),
            )
          : products.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      color: appTheme.deepPurple400,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Không có sản phẩm nào',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Hiện chưa có sản phẩm nào trong danh mục này',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: CustomTextStyles.titleMediumBaloo2Gray500.copyWith(
                          fontSize: isDesktop ? 20.fSize : 18.fSize,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      
                      // Grid layout for products
                      _buildProductsGrid(context),
                    ],
                  ),
                ),
              ),
    );
  }
  
  Widget _buildProductsGrid(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? SizeUtils.getGridItemCount() : 2,
        childAspectRatio: isDesktop ? 0.9 : 0.7,
        crossAxisSpacing: 16.h,
        mainAxisSpacing: 16.h,
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
