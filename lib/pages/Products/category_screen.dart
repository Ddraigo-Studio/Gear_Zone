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
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: Container(
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
    return CustomAppBar(
      height: 70.h,
      leadingWidth: 50.h,
      leading: Container(
        padding: const EdgeInsets.all(4.0),
        child: AppbarLeadingImage(
          imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
          width: 50.h,
          
          margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
        ),
      ),
      title: Text(
        "Danh mục",
        style: CustomTextStyles.titleLargeGabaritoBlack900,
      ),
      actions: [
        Container(
          width: 50.h,
          height: 50.h,
          margin: EdgeInsets.only(right: 16.h),
          decoration: AppDecoration.outlineBlack.copyWith(
            borderRadius: BorderRadiusStyle.circleBorder28,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(0, 2),
                blurRadius: 2,
              ),
            ]
          ),
          padding: EdgeInsets.all(8.h),
          child: AppbarImage(
            imagePath: ImageConstant.imgIconsaxBrokenBag2Gray100,
            height: 20.h,
            width: 20.h,
          ),
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
        // horizontalGridSpacing: 0.h,
        // verticalGridSpacing: 00.h,
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
