import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import 'component/filter_categories_item.dart';


class FilterDraweritem extends StatelessWidget {
  const FilterDraweritem({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 302.h,
                  padding: EdgeInsets.only(
                    left: 10.h,
                    top: 28.h,
                    right: 10.h,
                  ),
                  decoration: AppDecoration.fillGray1002.copyWith(
                    borderRadius: BorderRadiusStyle.customBorderTL20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.h),
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(left: 10.h),
                        child: Row(
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgArrowLeftOnprimary,
                              height: 24.h,
                              width: 26.h,
                              onTap: () {
                                onTapBackArrow(context);
                              },
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 10.h,
                                  bottom: 2.h,
                                ),
                                child: Text(
                                  "Lọc",
                                  style: CustomTextStyles.titleLargeRobotoBluegray90001,
                                ),
                              ),
                            ),
                            Spacer(),
                            CustomElevatedButton(
                              height: 36.h,
                              width: 92.h,
                              text: "Áp dụng",
                              buttonStyle: CustomButtonStyles.fillDeepPurple,
                              buttonTextStyle: CustomTextStyles.titleSmallWhiteA700,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 44.h),
                      _buildPriceRangeSection(context),
                      SizedBox(height: 44.h),
                      Padding(
                        padding: EdgeInsets.only(left: 8.h),
                        child: Text(
                          "Danh mục",
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildCategorySection(context),
                      SizedBox(height: 44.h),
                      _buildBrandSection(context),
                      SizedBox(height: 44.h),
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Text(
                              "Danh giá",
                              style: theme.textTheme.titleMedium,
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgDefaultIcon,
                              height: 18.h,
                              width: 18.h,
                              margin: EdgeInsets.only(left: 2.h),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildRatingSection(context),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildPriceRangeSection(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Khoảng giá",
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(
            width: double.maxFinite,
            child: SliderTheme(
              data: SliderThemeData(
                trackShape: RoundedRectSliderTrackShape(),
                activeTrackColor: appTheme.deepPurpleA100,
                inactiveTrackColor: appTheme.whiteA700,
                thumbColor: appTheme.deepPurpleA100,
                thumbShape: RoundSliderThumbShape(),
              ),
              child: RangeSlider(
                values: RangeValues(
                  0,
                  0,
                ),
                min: 0.0,
                max: 100.0,
                onChanged: (value) {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildCategorySection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.h),
      child: ResponsiveGridListBuilder(
        minItemWidth: 1,
        minItemsPerRow: 2,
        maxItemsPerRow: 2,
        horizontalGridSpacing: 56.h,
        verticalGridSpacing: 56.h,
        builder: (context, items) => ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          children: items,
        ),
        gridItems: List.generate(
          8,
          (index) {
            return FilterCategoryItem (category: 'Laptop',);
          },
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildBrandSection(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Thương hiệu",
            style: theme.textTheme.titleMedium,
          ),
          ResponsiveGridListBuilder(
            minItemWidth: 1,
            minItemsPerRow: 3,
            maxItemsPerRow: 3,
            horizontalGridSpacing: 4.h,
            verticalGridSpacing: 4.h,
            builder: (context, items) => ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              children: items,
            ),
            gridItems: List.generate(
              8,
              (index) {
                return FilterCategoryItem (category: 'Laptop',);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildRatingSection(BuildContext context) {
    return ResponsiveGridListBuilder(
      minItemWidth: 1,
      minItemsPerRow: 4,
      maxItemsPerRow: 4,
      horizontalGridSpacing: 6.h,
      verticalGridSpacing: 6.h,
      builder: (context, items) => ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        children: items,
      ),
      gridItems: List.generate(
        5, 
        (index) {
          return FilterCategoryItem(category: '${index + 1} sao');
        },
      ),
    );
  }

  /// Navigates back to the previous screen.
  onTapBackArrow(BuildContext context) {
    Navigator.pop(context);
  }

}
