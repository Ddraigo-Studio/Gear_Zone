import 'package:flutter/material.dart';
import '../../core/app_export.dart';
// import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_image.dart';
import '../../widgets/app_bar/appbar_leading_image_one.dart';
import '../../widgets/app_bar/appbar_title_searchview_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/items/categorieslist_item_widget.dart';
import '../../widgets/items/productcarousel_item_widget.dart';

class HomeInitialPage extends StatefulWidget {
  const HomeInitialPage({super.key});

  @override
  HomeInitialPageState createState() => HomeInitialPageState();
}

// ignore_for_file: must_be_immutable
class HomeInitialPageState extends State<HomeInitialPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: AppDecoration.fillWhiteA,
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: _buildAppBar(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),
                    _buildLimitedOfferSection(context),
                    SizedBox(height: 40.h),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 40.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Text(
                                "Danh mục",
                                style: CustomTextStyles
                                    .titleMediumGabaritoGray900Bold,
                              ),
                            ),
                          ),
                          Text(
                            "Xem tất cả",
                            style: CustomTextStyles.bodyLargeAmaranth,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildCategoriesList(context),
                    SizedBox(height: 38.h),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 24.h),
                      child: _buildNewestRow(
                        context,
                        minhOne: "Top bán chạy",
                        xemttcTwo: "Xem tất cả",
                      ),
                    ),
                    SizedBox(height: 14.h),
                    _buildProductCarousel(context),
                    SizedBox(height: 46.h),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 24.h),
                      child: _buildNewestRow(
                        context,
                        minhOne: "Mới nhất",
                        xemttcTwo: "Xem tất cả",
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildHorizontalScrollSection(context)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildNewestRow(
    BuildContext context, {
    required String minhOne,
    required String xemttcTwo,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          minhOne,
          style: CustomTextStyles.titleMediumGabaritoRed500.copyWith(
            color: appTheme.red500,
          ),
        ),
        Text(
          xemttcTwo,
          style: CustomTextStyles.bodyLargeAmaranth.copyWith(
            color: appTheme.gray900,
          ),
        ),
      ],
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 38.h,
      leadingWidth: 70.h,
      leading: AppbarLeadingImageOne(
        imagePath: ImageConstant.imgEllipse13,
        height: 18.h,
        width: 54.h,
        margin: EdgeInsets.only(
          left: 16.h,
          bottom: 20.h,
        ),
      ),
      title: SizedBox(
        width: double.maxFinite,
        child: AppbarTitleSearchviewOne(
          margin: EdgeInsets.only(left: 17.h),
          hintText: "Tìm kiếm",
          controller: searchController,
        ),
      ),
      actions: [
        Container(
          width: 44.h,
          margin: EdgeInsets.only(
            right: 17.h,
            bottom: 20.h,
          ),
          decoration: AppDecoration.outlineBlack.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder8,
          ),
          child: Column(
            children: [
              AppbarImage(
                imagePath: ImageConstant.imgIconsaxBrokenBag2,
                height: 4.h,
                margin: EdgeInsets.symmetric(horizontal: 14.h),
              ),
              SizedBox(height: 13.h)
            ],
          ),
        ),
      ],
      styleType: Style.bgShadowBlack900_2,
    );
  }

  /// Section Widget
  Widget _buildLimitedOfferSection(BuildContext context) {
    return Container(
      height: 194.h,
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 16.h),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 188.h,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 148.h,
                    width: 358.h,
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.h),
                      gradient: LinearGradient(
                        begin: Alignment(-0.06, 0.06),
                        end: Alignment(1.02, 1),
                        colors: [
                          appTheme.pinkA700,
                          theme.colorScheme.primaryContainer
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 188.h,
                      margin: EdgeInsets.only(left: 18.h),
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              height: 188.h,
                              margin: EdgeInsets.only(left: 60.h),
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.img5eb4156d7834b2000433266d,
                                    height: 120.h,
                                    width: 154.h,
                                  ),
                                  CustomImageView(
                                    imagePath: ImageConstant.imgUnnamed1,
                                    height: 136.h,
                                    width: 138.h,
                                    alignment: Alignment.topLeft,
                                  ),
                                  CustomImageView(
                                    imagePath: ImageConstant.imgThiTKChAC,
                                    height: 102.h,
                                    width: 144.h,
                                    alignment: Alignment.topRight,
                                    margin: EdgeInsets.only(
                                      top: 10.h,
                                      right: 62.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 88.h,
                              margin: EdgeInsets.only(top: 34.h),
                              child: Text(
                                "Gear\n Zone",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextStyles
                                    .headlineSmallAoboshiOneOrange300,
                              ),
                            ),
                          ),
                          Container(
                            width: 70.h,
                            margin: EdgeInsets.only(bottom: 44.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Giảm ngay",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: CustomTextStyles
                                      .bodySmallSigmarOneWhiteA700,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 4.h),
                                  child: Text(
                                    "40%",
                                    style:
                                        CustomTextStyles.titleLargeAoboshiOne,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 22.h),
                            padding: EdgeInsets.symmetric(horizontal: 4.h),
                            decoration: AppDecoration.fillWhiteA.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder8,
                            ),
                            child: Text(
                              "free shipping".toUpperCase(),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            "Số lượng có hạn!!!",
            style: CustomTextStyles.bodySmallAlatsiGray600,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildCategoriesList(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 24.h,
          children: List.generate(
            5,
            (index) {
              return CategorieslistItemWidget();
            },
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildProductCarousel(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 16.h,
          children: List.generate(
            3,
            (index) {
              return ProductcarouselItemWidget();
            },
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHorizontalScrollSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: SizedBox(
            width: 490.h,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    decoration: AppDecoration.fillGray.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconButton(
                          height: 26.h,
                          width: 26.h,
                          padding: EdgeInsets.all(6.h),
                          decoration: IconButtonStyleHelper.none,
                          alignment: Alignment.centerRight,
                          child: CustomImageView(
                            imagePath: ImageConstant.imgHeartIconlyPro,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        CustomImageView(
                          imagePath: ImageConstant.imgHuaweiFreebuds,
                          height: 68.h,
                          width: 70.h,
                        ),
                        SizedBox(height: 22.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 6.h),
                            child: Text(
                              "Huawei Matebook X13",
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.h),
                          child: Text(
                            "\$ 20,999 ",
                            style: CustomTextStyles.labelLargePPMoriBluegray900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(left: 16.h),
                    padding: EdgeInsets.all(6.h),
                    decoration: AppDecoration.fillGray.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconButton(
                          height: 26.h,
                          width: 26.h,
                          padding: EdgeInsets.all(6.h),
                          decoration: IconButtonStyleHelper.none,
                          alignment: Alignment.centerRight,
                          child: CustomImageView(
                            imagePath: ImageConstant.imgHeartIconlyPro,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        CustomImageView(
                          imagePath: ImageConstant.imgImage1,
                          height: 72.h,
                          width: 48.h,
                        ),
                        SizedBox(height: 20.h),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: EdgeInsets.only(left: 16.h),
                            padding: EdgeInsets.all(6.h),
                            decoration: AppDecoration.fillGray.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder16,
                            ),
                            child: Column(
                              spacing: 16,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgImage1,
                                  height: 72.h,
                                  width: 48.h,
                                  margin: EdgeInsets.only(right: 28.h),
                                ),
                                Text(
                                  "Huawei Matebook X13",
                                  style: theme.textTheme.bodySmall,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 6.h),
                                    child: Text(
                                      "17.390.000đ",
                                      style: theme.textTheme.labelLarge,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(left: 16.h),
                    padding: EdgeInsets.all(6.h),
                    decoration: AppDecoration.fillGray.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconButton(
                          height: 26.h,
                          width: 26.h,
                          padding: EdgeInsets.all(6.h),
                          decoration: IconButtonStyleHelper.none,
                          alignment: Alignment.centerRight,
                          child: CustomImageView(
                            imagePath: ImageConstant.imgHeartIconlyPro,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        CustomImageView(
                          imagePath: ImageConstant.imgImage1,
                          height: 72.h,
                          width: 48.h,
                        ),
                        SizedBox(height: 20.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 6.h),
                            child: Text(
                              "Huawei Matebook X13",
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.symmetric(horizontal: 6.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "17.390.000đ",
                                style: theme.textTheme.labelLarge,
                              ),
                              CustomOutlinedButton(
                                width: 34.h,
                                text: "31%".toUpperCase(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(left: 16.h),
                    padding: EdgeInsets.all(6.h),
                    decoration: AppDecoration.fillGray.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder16,
                    ),
                    child: Column(
                      spacing: 16,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgImage1,
                          height: 72.h,
                          width: 48.h,
                          margin: EdgeInsets.only(right: 28.h),
                        ),
                        Text(
                          "Huawei Matebook X13",
                          style: theme.textTheme.bodySmall,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 6.h),
                            child: Text(
                              "17.390.000đ",
                              style: theme.textTheme.labelLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
