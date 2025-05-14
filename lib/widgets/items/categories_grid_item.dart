import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../model/category.dart';

class CategoriesGridItem extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback? onTap;

  const CategoriesGridItem({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        // Navigate to category products page
        Navigator.pushNamed(context, '/category_products', arguments: {
          'categoryId': category.id,
        });
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 10.h,
          right: 10.h,
          bottom: 8.h,
          top: 8.h,
        ),
        width: double.maxFinite,
        decoration: AppDecoration.shadow.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder16,
        ),
        child: Column(
          spacing: 14,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.h),
              child: category.imagePath.isNotEmpty && category.imagePath.startsWith('http')
                ? Image.network(
                    category.imagePath,
                    height: 170.h,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 178.h,
                        width: double.maxFinite,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(appTheme.deepPurple400),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 170.h,
                      width: double.maxFinite,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                        size: 40,
                      ),
                    ),
                  )
                : Container(
                    height: 170.h,
                    width: double.maxFinite,
                    color: appTheme.deepPurple50,
                    child: Icon(
                      Icons.category,
                      color: appTheme.deepPurple400,
                      size: 40,
                    ),
                  ),
            ),
            SizedBox(height: 5.h),
            Text(
              category.categoryName,
              style: CustomTextStyles.bodyLargeBalooBhaijaanGray700,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }
}
