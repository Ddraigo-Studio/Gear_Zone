import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CategoriesListItem extends StatelessWidget {  final String imagePath;
  final String categoryName;
  final IconData icon;

  const CategoriesListItem({
    super.key,
    required this.imagePath,
    required this.categoryName,
    required this.icon,
  });
  
  @override
  Widget build(BuildContext context) {    return InkWell(
      onTap: () {
        print('Tapped on $categoryName');
        // Navigate to the category screen
        Navigator.pushNamed(context, '/category_screen', arguments: {
          'categoryName': categoryName,
          'icon': icon,
        });      },
      child: Column(
        mainAxisSize: MainAxisSize.min, // Đảm bảo không gian tối thiểu
        crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa các phần tử
        mainAxisAlignment: MainAxisAlignment.center, // Thay đổi từ spaceEvenly sang center
        children: [          
          Container(
            width: 42.h,
            height: 42.h,
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
            child: ClipOval(
              child: imagePath.isNotEmpty && !imagePath.contains("imgEllipse356x56")
                ? Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: 45.h,
                    height: 45.h,
                  )
                : Icon(
                    icon,
                    size: 24.h,
                    color: appTheme.deepPurple400,
                  ),
            ),          ),
          SizedBox(height: 2.h), // Add a small fixed space
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
                  fontSize: 8.fSize, // Smaller font size
                ),
              ),
            ),
          ),],
      ),
    );  }
}
