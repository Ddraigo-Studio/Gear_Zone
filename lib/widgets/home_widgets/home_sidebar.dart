import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../pages/Products/category_screen.dart';

class HomeSidebar extends StatelessWidget {
  const HomeSidebar({super.key});

  @override
  Widget build(BuildContext context) {    // List of categories to display in the sidebar
    final List<Map<String, dynamic>> categories = [
      {
        'imagePath': ImageConstant.imgMacbookAirRetinaM1240x160,
        'categoryName': 'Laptop',
        'icon': Icons.laptop
      },
      {
        'imagePath': ImageConstant.imgProfile,
        'categoryName': 'Laptop Gaming',
        'icon': Icons.laptop_mac
      },
      {
        'imagePath': ImageConstant.imgEllipse3,
        'categoryName': 'PC',
        'icon': Icons.desktop_windows
      },
      {
        'imagePath': ImageConstant.imgEllipse4,
        'categoryName': 'Màn hình',
        'icon': Icons.monitor
      },
      {
        'imagePath': ImageConstant.imgEllipse356x56,
        'categoryName': 'Mainboard',
        'icon': Icons.dashboard
      },
      {
        'imagePath': ImageConstant.imgEllipse356x56,
        'categoryName': 'CPU',
        'icon': Icons.memory
      },
      {
        'imagePath': ImageConstant.imgEllipse356x56,
        'categoryName': 'VGA',
        'icon': Icons.video_settings
      },
      {
        'imagePath': ImageConstant.imgEllipse356x56,
        'categoryName': 'RAM',
        'icon': Icons.sd_card
      },
      {
        'imagePath': ImageConstant.imgEllipse356x56,
        'categoryName': 'Ổ cứng',
        'icon': Icons.storage
      },
      {
        'imagePath': ImageConstant.imgEllipse356x56,
        'categoryName': 'Bàn phím',
        'icon': Icons.keyboard
      },
      {
        'imagePath': ImageConstant.imgEllipse356x56,
        'categoryName': 'Chuột',
        'icon': Icons.mouse
      },
      {
        'imagePath': ImageConstant.imgEllipse356x56,
        'categoryName': 'Tai nghe',
        'icon': Icons.headset
      },
      {
        'imagePath': ImageConstant.imgEllipse356x56,
        'categoryName': 'Loa',
        'icon': Icons.speaker
      },
      {
        'imagePath': ImageConstant.imgEllipse356x56,
        'categoryName': 'Micro',
        'icon': Icons.mic
      },
    ];    return Container(
      width: 250,
      color: appTheme.deepPurple400,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.h),
            child: Row(
              children: [
                Container(
                  width: 40.h,
                  height: 40.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      ImageConstant.imgLogo,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GearZone',
                      style: TextStyle(
                        fontSize: 18.fSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Tech Store',
                      style: TextStyle(
                        fontSize: 12.fSize,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10.h),
                  height: 24.h,
                  width: 6.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.h),
                  ),
                ),
                Text(
                  "Danh mục sản phẩm",
                  style: CustomTextStyles.titleMediumGabaritoRed500.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.h),
              child: GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10.h,
                  mainAxisSpacing: 10.h,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _buildGridCategoryItem(
                    context,
                    categories[index]['categoryName']!,
                    categories[index]['icon'] as IconData,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCategoryItem(
    BuildContext context,
    String categoryName,
    IconData icon,
  ) {
    return InkWell(
      onTap: () {
        // Navigate to category screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoriesScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.h),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28.h,
            ),
            SizedBox(height: 8.h),
            Text(
              categoryName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.fSize,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    String imagePath,
    String categoryName,
    {bool isActive = false}
  ) {
    return InkWell(
      onTap: () {
        // Navigate to category screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoriesScreen(),
          ),
        );
      },      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.h),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.h),
        ),
        child: Row(
          children: [
            Container(
              width: 36.h,
              height: 36.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: Text(
                categoryName,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14.fSize,
                  color: Colors.white,
                ),
              ),
            ),
            if (isActive)
              Icon(
                Icons.arrow_forward_ios,
                size: 14.h,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}
