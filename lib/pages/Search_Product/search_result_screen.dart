import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/Items/product_carousel_item_widget.dart';
import '../../widgets/Items/search_results_grid_item_widget.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton_one.dart';
import '../../widgets/app_bar/appbar_title_searchview.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';

// ignore_for_file: must_be_immutable
class SearchResultScreen extends StatelessWidget {
  SearchResultScreen({super.key});

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
                _buildSettingsRow(context),
                SizedBox(height: 32.h),
                Text(
                  "53 Kết quả",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.titleMediumGabaritoGray900,
              ),
              SizedBox(height: 6.h),
              _buildSearchResultsGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 56.h,
      leading: AppbarLeadingIconbuttonOne(
        imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 8.h,
          bottom: 8.h,
        ),
      ),
      title: SizedBox(
        width: double.maxFinite,
        child: AppbarTitleSearchview(
          margin: EdgeInsets.only(left: 16.h),
          hintText: "Jacket",
          controller: searchController,
        ),
      ),
      actions: [
        AppbarTrailingIconbuttonOne(
          imagePath: ImageConstant.imgFilter,
          height: 44.h,
          width: 44.h,
          margin: EdgeInsets.only(
            top: 5.h,
            right: 17.h,
            bottom: 6.h,
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildSortByNameButton(BuildContext context) {
    return CustomElevatedButton(
      height: 26.h,
      width: 126.h,
      text: "Sắp xếp theo tên",
      margin: EdgeInsets.only(left: 8.h),
      rightIcon: Container(
        margin: EdgeInsets.only(left: 4.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgIconsaxBrokenArrowdown2WhiteA700,
          height: 16.h,
          width: 16.h,
          fit: BoxFit.contain,
        ),
      ),
      buttonStyle: CustomButtonStyles.fillPrimaryTL12,
      buttonTextStyle: CustomTextStyles.bodySmallBasicWhiteA700,
    );
  }

  /// Section Widget
  Widget _buildSortByPriceButton(BuildContext context) {
    return CustomElevatedButton(
      height: 26.h,
      width: 124.h,
      text: "Sắp xếp theo giá",
      margin: EdgeInsets.only(left: 8.h),
      rightIcon: Container(
        margin: EdgeInsets.only(left: 4.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgIconsaxBrokenArrowdown2,
          height: 16.h,
          width: 16.h,
          fit: BoxFit.contain,
        ),
      ),
      buttonStyle: CustomButtonStyles.fillGray,
      buttonTextStyle: CustomTextStyles.bodySmallBasicGray900,
    );
  }

  /// Section Widget
  Widget _buildSettingsRow(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          CustomIconButton(
            height: 26.h,
            width: 36.h,
            padding: EdgeInsets.all(2.h),
            decoration: IconButtonStyleHelper.fillPrimary,
            child: CustomImageView(
              imagePath: ImageConstant.imgSettingsWhiteA70001,
            ),
          ),
          _buildSortByNameButton(context),
          _buildSortByPriceButton(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSearchResultsGrid(BuildContext context) {
    final List<Map<String, String>> products = [
      {
        'imagePath': ImageConstant.imgImage1,
        'productName': 'Huawei Matebook X13',
        'discountPrice': '17.390.000đ',
        'originalPrice': '20.990.000đ',
        'discountPercent': '31%',
        'rating': '5.0',
      },
      {
        'imagePath': ImageConstant.imgProduct4,
        'productName': 'Dell XPS 13',
        'discountPrice': '21.990.000đ',
        'originalPrice': '24.990.000đ',
        'discountPercent': '20%',
        'rating': '4.5',
      },
      // Thêm các sản phẩm khác ở đây
    ];
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
          products.length,
          (index) {
            final product = products[index];
            return ProductCarouselItem(
              imagePath: product['imagePath']!,
              productName: product['productName']!,
              discountPrice: product['discountPrice']!,
              originalPrice: product['originalPrice']!,
              discountPercent: product['discountPercent']!,
              rating: product['rating']!,
            );
          },
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildPaginationControls(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      child: Row(
        children: [
          CustomIconButton(
            height: 34.h,
            width: 34.h,
            padding: EdgeInsets.all(6.h),
            decoration: IconButtonStyleHelper.outlineDeepPurpleA,
            child: CustomImageView(
              imagePath: ImageConstant.imgArrowLeft,
            ),
          ),
          Container(
            width: 34.h,
            height: 34.h,
            alignment: Alignment.center,
            decoration: AppDecoration.secondaryVariant100.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder16,
            ),
            child: Text(
              "1",
              textAlign: TextAlign.center,
              style: CustomTextStyles.labelLargePoppinsDeeppurple500,
            ),
          ),
          Container(
            width: 34.h,
            height: 34.h,
            alignment: Alignment.center,
            decoration: AppDecoration.fillDeepPurpleA.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder16,
            ),
            child: Text(
              "2",
              textAlign: TextAlign.center,
              style: CustomTextStyles.labelLargePoppinsDeeppurple50,
            ),
          ),
          Container(
            width: 34.h,
            height: 34.h,
            alignment: Alignment.center,
            decoration: AppDecoration.secondaryVariant100.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder16,
            ),
            child: Text(
              "3",
              textAlign: TextAlign.center,
              style: CustomTextStyles.labelLargePoppinsDeeppurple500,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              "...",
              style: CustomTextStyles.bodyMediumPoppinsBluegray300,
            ),
          ),
          Container(
            width: 34.h,
            height: 34.h,
            alignment: Alignment.center,
            decoration: AppDecoration.secondaryVariant100.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder16,
            ),
            child: Text(
              "15",
              textAlign: TextAlign.center,
              style: CustomTextStyles.labelLargePoppinsDeeppurple500,
            ),
          ),
          CustomIconButton(
            height: 34.h,
            width: 34.h,
            padding: EdgeInsets.all(6.h),
            decoration: IconButtonStyleHelper.outlineDeepPurpleA,
            child: CustomImageView(
              imagePath: ImageConstant.imgArrowRightDeepPurple500,
            ),
          ),
        ],
      ),
    );
  }


}
