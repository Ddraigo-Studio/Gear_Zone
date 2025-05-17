import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';

class CategoriesListItem extends StatelessWidget {
  final String imagePath;
  final String categoryName;
  final String id;

  const CategoriesListItem({
    super.key,
    required this.imagePath,
    required this.categoryName,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/category_products', arguments: {
          'categoryId': id,
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min, // Đảm bảo không gian tối thiểu
        crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa các phần tử
        mainAxisAlignment:
            MainAxisAlignment.center, // Thay đổi từ spaceEvenly sang center
        children: [
          Container(
            width: Responsive.isDesktop(context)
                ? 75.h
                : 50.h, // Increased size for both desktop and mobile
            height: Responsive.isDesktop(context)
                ? 75.h
                : 50.h, // Increased size for both desktop and mobile
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(2, 2),
                  blurRadius: 2,
                ),
              ],
            ),
            child: imagePath.isEmpty
                ? ClipOval(
                    child: Container(
                      color: Colors.white,
                      child: Icon(
                        Icons.category_outlined,
                        size: Responsive.isDesktop(context) ? 36.h : 24.h,
                        color: appTheme.deepPurple400,
                      ),
                    ),
                  )
                : ClipOval(
                    child: CustomImageView(
                      imagePath: imagePath,
                      fit: BoxFit.cover,
                      width: Responsive.isDesktop(context) ? 75.h : 50.h,
                      height: Responsive.isDesktop(context) ? 75.h : 50.h,
                    ),
                  ),
          ),
          SizedBox(height: 4.h), // Add a small fixed space
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.h),
              child: Text(
                categoryName,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 1, // Reduced to 1 line to save space
                style: CustomTextStyles.bodySmallBalooBhaiGray700.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: Responsive.isDesktop(context)
                      ? 12.fSize
                      : 8.fSize, // Smaller font size
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
