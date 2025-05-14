import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';
import '../../model/category.dart';
import '../../widgets/items/category_products_grid.dart';
import '../../controller/category_controller.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/cart_icon_button.dart';

class CategoryProductsPage extends StatefulWidget {
  final String categoryId;

  const CategoryProductsPage({
    super.key,
    required this.categoryId,
  });

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  final CategoryController _categoryController = CategoryController();
  CategoryModel? category;
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    _loadCategory();
  }

  Future<void> _loadCategory() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      // Lấy thông tin danh mục theo ID
      final fetchedCategory =
          await _categoryController.getCategoryById(widget.categoryId);

      if (mounted) {
        setState(() {
          category = fetchedCategory;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Không thể tải danh mục: $e';
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
          category?.categoryName ?? 'Danh mục sản phẩm',
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
              iconSize: isDesktop
              ? 40.h
              : null, 
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
                        onPressed: _loadCategory,
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
              : category == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category_outlined,
                            color: appTheme.deepPurple400,
                            size: 64,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Không tìm thấy danh mục',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Danh mục bạn đang tìm kiếm có thể đã bị xóa hoặc không tồn tại',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appTheme.deepPurple400,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.h,
                                vertical: 12.h,
                              ),
                            ),
                            child: Text('Quay lại'),
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
                            // B
                            // Tiêu đề sản phẩm
                            Text(
                              category!.categoryName,
                              style: CustomTextStyles.titleMediumBaloo2Gray500
                                  .copyWith(
                                fontSize: isDesktop ? 20.fSize : 18.fSize,
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // Danh sách sản phẩm theo danh mục
                            CategoryProductsGrid(
                              category: category!,
                            ),
                          ],
                        ),
                      ),
                    ),
    );
  }
}
