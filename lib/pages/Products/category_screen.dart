import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_image.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/items/categories_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

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
        IconButton(
          icon: Container(
            width: 45.h,
            height: 45.h,
            decoration: AppDecoration.fillDeepPurpleF.copyWith(
              borderRadius: BorderRadiusStyle.circleBorder28,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(0, 2),
                  blurRadius: 2,
                ),
              ],
            ),
            padding: EdgeInsets.all(8.h),
            child: AppbarImage(
              imagePath: ImageConstant.imgIconsaxBrokenBag2Gray100,
              height: 20.h,
              width: 20.h,
            ),
          ),
          onPressed: () {
            // Hành động khi nhấn vào nút giỏ hàng
          },
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildCategoriesGrid(BuildContext context) {
    return Expanded(
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
          5,
          (index) {
            return CategoriesGridItem();
          },
        ),
      ),
    );
  }
}
