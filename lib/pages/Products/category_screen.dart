import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_image.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/items/categoriesgrid_item_widget.dart';

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
            left: 24.h,
            top: 20.h,
            right: 24.h,
          ),
          child: Column(
            spacing: 14,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Danh mục",
                style: CustomTextStyles.titleLargeGabaritoBlack900,
              ),
              _buildCategoriesGrid(context),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 38.h,
      leadingWidth: 48.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgInbox,
        width: 40.h,
        margin: EdgeInsets.only(
          left: 8.h,
          bottom: 24.h,
        ),
      ),
      actions: [
        Container(
          width: 46.h,
          margin: EdgeInsets.only(
            right: 15.h,
            bottom: 18.h,
          ),
          decoration: AppDecoration.outlineBlack.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder8,
          ),
          child: Column(
            children: [
              AppbarImage(
                imagePath: ImageConstant.imgIconsaxBrokenBag2WhiteA7006x16,
                height: 6.h,
                margin: EdgeInsets.only(
                  left: 14.h,
                  right: 13.h,
                ),
              ),
              SizedBox(height: 14.h)
            ],
          ),
        )
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
        horizontalGridSpacing: 22.h,
        verticalGridSpacing: 22.h,
        builder: (context, items) => ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          children: items,
        ),
        gridItems: List.generate(
          5,
          (index) {
            return CategoriesgridItemWidget();
          },
        ),
      ),
    );
  }
}
