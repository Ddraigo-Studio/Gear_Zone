import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_image.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/items/categories_grid_item.dart';
import '../../widgets/cart_icon_button.dart';
import '../../controller/category_controller.dart';
import '../../model/category.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoryController _categoryController = CategoryController();
  List<CategoryModel> categories = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // Load category data from controller
  Future<void> _loadCategories() async {
    try {
      setState(() {
        isLoading = true;
        error = '';
        categories = [];
      });
      
      // Listen to Firestore stream for real-time category updates
      _categoryController.getCategories().listen((fetchedCategories) {
        if (mounted) {
          setState(() {
            categories = fetchedCategories;
            isLoading = false;
          });
        }
      }, onError: (e) {
        if (mounted) {
          setState(() {
            error = 'Không thể tải danh mục: $e';
            isLoading = false;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Đã xảy ra lỗi: $e';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(
            top: 16.h,
            left: 8.h,
            right: 8.h,
          ),
          child: Column(
            spacing: 14,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoriesGrid(context),
            ],
          ),
        ),
      ),
    );
  }
  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 2,
      toolbarHeight: 80.h,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: AppbarLeadingImage(
          imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
          height: 25.h,
          width: 25.h,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "Danh mục",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true, // Nếu muốn tiêu đề căn giữa
      actions: [
        CartIconButton(
          
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildCategoriesGrid(BuildContext context) {
    if (isLoading) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(appTheme.deepPurple400),
              ),
              SizedBox(height: 16),
              Text(
                'Đang tải danh mục...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (error.isNotEmpty) {
      return Expanded(
        child: Center(
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
                onPressed: _loadCategories,
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.deepPurple400,
                  foregroundColor: Colors.white,
                ),
                child: Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (categories.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.category_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'Chưa có danh mục nào',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }    return Expanded(
      child: ResponsiveGridListBuilder(
        minItemWidth: 1,
        minItemsPerRow: 2,
        maxItemsPerRow: 2,
        builder: (context, items) => ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          children: items,
        ),
        gridItems: List.generate(
          categories.length,
          (index) {
            return CategoriesGridItem(
              category: categories[index],
            );
          },
        ),
      ),
    );
  }
}
