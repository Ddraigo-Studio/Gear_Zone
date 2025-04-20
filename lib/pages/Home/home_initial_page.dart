import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/Items/recently_viewed_item.dart';
import '../../widgets/app_bar/appbar_title_searchview_one.dart';
import '../../widgets/banner_slider.dart';
import '../../widgets/cart_icon_button.dart';
import '../../widgets/items/categories_list_item.dart';
import '../../widgets/items/product_carousel_item_widget.dart';
import '../Products/category_screen.dart';

class HomeInitialPage extends StatefulWidget {
  const HomeInitialPage({super.key});

  @override
  HomeInitialPageState createState() => HomeInitialPageState();
}

// ignore_for_file: must_be_immutable
class HomeInitialPageState extends State<HomeInitialPage> {
  TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> categories = [
    {
      'imagePath': ImageConstant.imgMacbookAirRetinaM1240x160,
      'categoryName': 'Laptop'
    },
    {'imagePath': ImageConstant.imgProfile, 'categoryName': 'Laptop Gaming'},
    {'imagePath': ImageConstant.imgEllipse3, 'categoryName': 'PC'},
    {'imagePath': ImageConstant.imgEllipse4, 'categoryName': 'Tản nhiệt'},
    {
      'imagePath': ImageConstant.imgEllipse356x56,
      'categoryName': 'Accessories'
    },
  ];


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
                    // _buildBannerSection(context),
                    MyBannerSlider(),
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CategoriesScreen()),
                              );
                            },
                            child: Text(
                              "Xem tất cả",
                              style: CustomTextStyles.labelLargePoppinsBlack900,
                            ),
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
                      child: _buildTitleRow(
                        context,
                        titleName: "Mới nhất",
                        seeAll: "Xem tất cả",
                        color: appTheme.deepPurple500,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    _buildNeweProductSection(context),
                    SizedBox(height: 40.h),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 24.h),
                      child: _buildTitleRow(
                        context,
                        titleName: "Top bán chạy",
                        seeAll: "Xem tất cả",
                        color: appTheme.deepPurple500,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildProductCarousel(context),
                    SizedBox(height: 40.h),

                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 24.h),
                      child: _buildTitleRow(
                        context,
                        titleName: "PC bán chạy nhất",
                        seeAll: "Xem tất cả",
                        color: appTheme.deepPurple500,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildLaptopTopSell(context),
                    SizedBox(height: 40.h),

                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 24.h),
                      child: _buildTitleRow(
                        context,
                        titleName: "Mục yêu thích",
                        seeAll: "Xem tất cả",
                        color: appTheme.red500,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildWishListSection(context),
                    SizedBox(height: 24.h),
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
  Widget _buildTitleRow(
    BuildContext context, {
    required String titleName,
    required String seeAll,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: 10.h),
              height: 24.h,
              width: 14.h,
              decoration: ( 
                  BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6.h),
                )
              ),
            ),
            Text(
              titleName,
              style: CustomTextStyles.titleMediumGabaritoRed500.copyWith(
                color: color,
              ),
            ),
          ],
        ),
        Text(
          seeAll,
          style: CustomTextStyles.labelLargePoppinsBlack900
        ),
      ],
    );
  }

  /// Section Widget: AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 75.h,
      backgroundColor: appTheme.deepPurple400,
      leadingWidth: 70.h,
      leading: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 2),
              blurRadius: 2,
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            ImageConstant.imgLogo,
            fit: BoxFit.cover,
          ),
        ),
      ),
      centerTitle: true,
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h), 
        child: SizedBox(
          width: double.maxFinite,
          child: Center(
            child: AppbarTitleSearchviewOne(
              margin: EdgeInsets.only(left: 8.h, right: 8.h),
              hintText: "Tìm kiếm",
              controller: searchController,
            ),
          ),
        ),
      ),
      actions: [
        CartIconButton(
          buttonColor: Colors.white, // Background color of the button
          iconColor: theme.primaryColor, // Color of the icon
        ),
      ],
      
    );
  }

  // /// Section Widget
  // Widget _buildBannerSection(BuildContext context) {
  //   return Container(
  //     height: 194.h,
  //     width: double.maxFinite,
  //     margin: EdgeInsets.only(left: 16.h, right: 16.h),
  //     child: Stack(
  //       alignment: Alignment.bottomCenter,
  //       children: [
  //         Align(
  //           alignment: Alignment.center,
  //           child: Container(
  //             height: 188.h,
  //             child: Stack(
  //               alignment: Alignment.bottomCenter,
  //               children: [
  //                 Container(
  //                   height: 148.h,
  //                   width: 358.h,
  //                   margin: EdgeInsets.only(bottom: 12.h),
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(24.h),
  //                     gradient: LinearGradient(
  //                       begin: Alignment(-0.06, 0.06),
  //                       end: Alignment(1.02, 1),
  //                       colors: [
  //                         appTheme.pinkA700,
  //                         theme.colorScheme.primaryContainer
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Container(
  //                     height: 188.h,
  //                     margin: EdgeInsets.only(left: 18.h),
  //                     child: Stack(
  //                       alignment: Alignment.bottomLeft,
  //                       children: [
  //                         Align(
  //                           alignment: Alignment.centerRight,
  //                           child: Container(
  //                             height: 188.h,
  //                             margin: EdgeInsets.only(left: 60.h),
  //                             child: Stack(
  //                               alignment: Alignment.bottomRight,
  //                               children: [
  //                                 CustomImageView(
  //                                   imagePath: ImageConstant.imgSwitch,
  //                                   height: 120.h,
  //                                   width: 154.h,
  //                                 ),
  //                                 CustomImageView(
  //                                   imagePath: ImageConstant.imgUnnamed1,
  //                                   height: 136.h,
  //                                   width: 138.h,
  //                                   alignment: Alignment.topLeft,
  //                                 ),
  //                                 CustomImageView(
  //                                   imagePath: ImageConstant.imgThiTKChAC,
  //                                   height: 102.h,
  //                                   width: 144.h,
  //                                   alignment: Alignment.topRight,
  //                                   margin: EdgeInsets.only(
  //                                     top: 10.h,
  //                                     right: 62.h,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                         Align(
  //                           alignment: Alignment.topLeft,
  //                           child: Container(
  //                             width: 88.h,
  //                             margin: EdgeInsets.only(top: 34.h),
  //                             child: Text(
  //                               "Gear\n Zone",
  //                               maxLines: 2,
  //                               overflow: TextOverflow.ellipsis,
  //                               style: CustomTextStyles
  //                                   .headlineSmallAoboshiOneOrange300,
  //                             ),
  //                           ),
  //                         ),
  //                         Container(
  //                           width: 70.h,
  //                           margin: EdgeInsets.only(bottom: 44.h),
  //                           child: Column(
  //                             mainAxisSize: MainAxisSize.min,
  //                             crossAxisAlignment: CrossAxisAlignment.end,
  //                             children: [
  //                               Text(
  //                                 "Giảm ngay",
  //                                 maxLines: 1,
  //                                 overflow: TextOverflow.ellipsis,
  //                                 textAlign: TextAlign.center,
  //                                 style: CustomTextStyles
  //                                     .bodySmallSigmarOneWhiteA700,
  //                               ),
  //                               Padding(
  //                                 padding: EdgeInsets.only(right: 4.h),
  //                                 child: Text(
  //                                   "40%",
  //                                   style:
  //                                       CustomTextStyles.titleLargeAoboshiOne,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         Container(
  //                           margin: EdgeInsets.only(bottom: 22.h),
  //                           padding: EdgeInsets.symmetric(horizontal: 4.h),
  //                           decoration: AppDecoration.fillWhiteA.copyWith(
  //                             borderRadius: BorderRadiusStyle.roundedBorder8,
  //                           ),
  //                           child: Text(
  //                             "free shipping".toUpperCase(),
  //                             textAlign: TextAlign.center,
  //                             style: theme.textTheme.labelSmall,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(bottom: 12.0),
  //           child: Text(
  //             "Số lượng có hạn!!!",
  //             style: CustomTextStyles.bodyLargeBalooBhaijaanWhiteA700,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// Section Widget
  Widget _buildCategoriesList(BuildContext context) {
    return Container(
      height: 90.h,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 16.h),
            child: CategoriesListItem(
              imagePath: categories[index]['imagePath']!,
              categoryName: categories[index]['categoryName']!,
            ),
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildProductCarousel(BuildContext context) {
    // Một danh sách các sản phẩm mẫu, bạn có thể thay đổi hoặc lấy từ API.
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

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      height: 260.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length, // Sử dụng số lượng sản phẩm thay vì 10
        itemBuilder: (context, index) {
          final product = products[index]; // Lấy thông tin sản phẩm tại inde
          return Padding(
            padding: EdgeInsets.only(right: 16.h, bottom: 2.h),
            child: ProductCarouselItem(
              imagePath: product['imagePath']!,
              productName: product['productName']!,
              discountPrice: product['discountPrice']!,
              originalPrice: product['originalPrice']!,
              discountPercent: product['discountPercent']!,
              rating: product['rating']!,
            ),
          );
        },
      ),
    );
  }

  Widget _buildLaptopTopSell(BuildContext context) {
    // Một danh sách các sản phẩm mẫu, bạn có thể thay đổi hoặc lấy từ API.
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

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      height: 260.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length, // Sử dụng số lượng sản phẩm thay vì 10
        itemBuilder: (context, index) {
          final product = products[index]; // Lấy thông tin sản phẩm tại inde
          return Padding(
            padding: EdgeInsets.only(right: 16.h, bottom: 2.h),
            child: ProductCarouselItem(
              imagePath: product['imagePath']!,
              productName: product['productName']!,
              discountPrice: product['discountPrice']!,
              originalPrice: product['originalPrice']!,
              discountPercent: product['discountPercent']!,
              rating: product['rating']!,
            ),
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildNeweProductSection(BuildContext context) {
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

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      height: 260.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length, // Sử dụng số lượng sản phẩm thay vì 10
        itemBuilder: (context, index) {
          final product = products[index]; // Lấy thông tin sản phẩm tại index

          return Padding(
            padding: EdgeInsets.only(right: 16.h, bottom: 2.h),
            child: ProductCarouselItem(
              imagePath: product['imagePath']!,
              productName: product['productName']!,
              discountPrice: product['discountPrice']!,
              originalPrice: product['originalPrice']!,
              discountPercent: product['discountPercent']!,
              rating: product['rating']!,
            ),
          );
        },
      ),
    );
  }

  Widget _buildWishListSection(BuildContext context) {
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

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      height: 260.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length, // Sử dụng số lượng sản phẩm thay vì 10
        itemBuilder: (context, index) {
          final product = products[index]; // Lấy thông tin sản phẩm tại index

          return Padding(
            padding: EdgeInsets.only(right: 16.h, bottom: 2.h),
            child: WishListItem(
              index: index,
              imagePath: product['imagePath']!,
              productName: product['productName']!,
              discountPrice: product['discountPrice']!,
              originalPrice: product['originalPrice']!,
              discountPercent: product['discountPercent']!,
              rating: product['rating']!,
            ),
          );
        },
      ),
    );
  }
}
