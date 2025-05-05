import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CategoriesListItem extends StatelessWidget {
  final String imagePath;
  final String categoryName;

  const CategoriesListItem({
    super.key,
    required this.imagePath,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Tapped on $categoryName');
      },
      child: Column(
        mainAxisSize: MainAxisSize.min, // Đảm bảo không gian tối thiểu
        crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa các phần tử
        mainAxisAlignment:  MainAxisAlignment.spaceEvenly, //
        children: [
          Container(
            width: 60.h,
            height: 60.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: appTheme.gray100,  
              shape: BoxShape.circle, 
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(0, 2),
                  blurRadius: 2,
                ),
              ],
            ),
            child: ClipOval( 
              child: Image.asset(
                imagePath,  // Your image asset
                fit: BoxFit.cover,  
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
            child: Text(
              categoryName, 
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.bodySmallBalooBhaiGray700,
            ),
          ),
          
        ],
      ),
    );
  }
}
