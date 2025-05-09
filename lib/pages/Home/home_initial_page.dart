import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/items/categories_list_item.dart';
import '../../widgets/items/recently_viewed_item.dart';
import '../../widgets/banner_slider.dart';
import '../../widgets/cart_icon_button.dart';
import '../../widgets/items/product_carousel_item_widget.dart';
import '../Products/category_screen.dart';
import '../../model/sample_data.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/service_section.dart';

class HomeInitialPage extends StatefulWidget {
  const HomeInitialPage({super.key});

  @override
  HomeInitialPageState createState() => HomeInitialPageState();
}

// ignore_for_file: must_be_immutable
class HomeInitialPageState extends State<HomeInitialPage> {
  TextEditingController searchController = TextEditingController();
  final List<Map<String, dynamic>> categories = [
    {
      'imagePath': 'category/img_laptop.png',
      'categoryName': 'Laptop',
      'icon': Icons.laptop
    },
    {
      'imagePath': 'category/img_laptop.png',
      'categoryName': 'Laptop Gaming',
      'icon': Icons.laptop_mac
    },
    {
      'imagePath': 'category/img_pc.png',
      'categoryName': 'PC',
      'icon': Icons.desktop_windows
    },
    {
      'imagePath': 'category/img_screen.png',
      'categoryName': 'Màn hình',
      'icon': Icons.monitor
    },
    {
      'imagePath': 'category/img_mainboard.png',
      'categoryName': 'Mainboard',
      'icon': Icons.dashboard
    },
    {
      'imagePath': 'category/img_cpu.png',
      'categoryName': 'CPU',
      'icon': Icons.memory
    },
    {
      'imagePath': 'category/ing_VGA.png',
      'categoryName': 'VGA',
      'icon': Icons.video_settings
    },
    {
      'imagePath': 'category/img_ram.png',
      'categoryName': 'RAM',
      'icon': Icons.sd_card
    },
    {
      'imagePath': 'category/img_hard_dish.png',
      'categoryName': 'Ổ cứng',
      'icon': Icons.storage
    },
    {
      'imagePath': 'category/img_case.png',
      'categoryName': 'Case',
      'icon': Icons.computer
    },
    {
      'imagePath': 'category/img_fan.png',
      'categoryName': 'Tản nhiệt',
      'icon': Icons.ac_unit
    },
    {
      'imagePath': 'category/img_nguon.png',
      'categoryName': 'Nguồn',
      'icon': Icons.power
    },
    {
      'imagePath': 'category/img_mainboard.png',
      'categoryName': 'Bàn phím',
      'icon': Icons.keyboard
    },
    {
      'imagePath': 'category/img_mouse.png',
      'categoryName': 'Chuột',
      'icon': Icons.mouse
    },
    {
      'imagePath': 'category/img_headphone.png',
      'categoryName': 'Tai nghe',
      'icon': Icons.headset
    },
    {
      'imagePath': 'category/img_volumn.png',
      'categoryName': 'Loa',
      'icon': Icons.speaker
    },
    {
      'imagePath': 'category/img_micro.png',
      'categoryName': 'Micro',
      'icon': Icons.mic
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Responsive.isDesktop(context) ? Colors.white : Colors.grey[100],
      ),
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
                    SizedBox(height: 0.h),
                    MyBannerSlider(),
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.h, 16.h, 16.h, 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4.h,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  color: appTheme.deepPurple400,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              SizedBox(width: 8.h),
                              Text(
                                "Danh mục sản phẩm",
                                style: TextStyle(
                                  fontSize: 16.fSize,
                                  fontWeight: FontWeight.bold,
                                  color: appTheme.deepPurple400,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CategoriesScreen()),
                              );
                            },
                            child: Text(
                              "Xem tất cả",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.fSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildCategoriesList(context), SizedBox(height: 20.h),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 16.h),
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
                      margin: EdgeInsets.symmetric(horizontal: 16.h),
                      child: _buildTitleRow(
                        context,
                        titleName: "Top bán chạy",
                        seeAll: "Xem tất cả",
                        color: appTheme.deepPurple500,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildProductCarousel(context), SizedBox(height: 20.h),

                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 16.h),
                      child: _buildTitleRow(
                        context,
                        titleName: "PC bán chạy nhất",
                        seeAll: "Xem tất cả",
                        color: appTheme.deepPurple500,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildLaptopTopSell(context), SizedBox(height: 20.h),

                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 16.h),
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
                    // Service section
                    ServiceSection(),
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
          children: [
            Container(
              width: 4.h,
              height: 20.h,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 8.h),
            Text(
              titleName,
              style: TextStyle(
                fontSize: 16.fSize,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            seeAll,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.fSize,
            ),
          ),
        ),
      ],
    );
  }

  /// Section Widget: AppBar  PreferredSizeWidget _buildAppBar(BuildContext context) {

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    return AppBar(
      elevation: 0,
      toolbarHeight: isDesktop ? 55.h : 75.h,
      backgroundColor: appTheme.deepPurple400,
      automaticallyImplyLeading: false,
      leadingWidth: isDesktop ? 55.h : 70.h,
      leading: Container(
        padding: EdgeInsets.only(left: isDesktop ? 12.h : 16.h),
        child: Container(
          width: isDesktop ? 30.h : 35.h,
          height: isDesktop ? 30.h : 35.h,
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
      ),
      centerTitle: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Responsive.isDesktop(context)
              ? Text(
                  'GearZone',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.fSize,
                  ),
                )
              : Container(), // Empty container for mobile
          Responsive.isDesktop(context)
              ? Spacer()
              : SizedBox(width: 10.h), // Empty container for mobile
          Flexible(
            child: Container(
              height: isDesktop ? 30.h : 35.h,
              width: isDesktop ? 200.h : 400.h,
              margin: EdgeInsets.symmetric(vertical: isDesktop ? 6.h : 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.h),
              ),              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sản phẩm',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: isDesktop ? 11.h : 12.h,
                  ),
                  isDense: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 8.h, right: 4.h),
                    child: Icon(
                      Icons.search, 
                      color: Colors.grey, 
                      size: 15.h ,
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: isDesktop ? 30.h : 36.h,
                    minHeight: isDesktop ? 30.h : 36.h,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                ),
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  fontSize: isDesktop ? 11.h : 12.h,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 4.h : 6.h),
          child: isDesktop
              ? Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 22.h,
                      ),
                      onPressed: () {},
                  
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.white,
                        size: 22.h,
                      ),
                      onPressed: () {},
                  
                    ),
                ],
              )
                :Container()
        ),
        CartIconButton(
          iconSize: isDesktop ? 22.h : null,
          buttonColor: Colors.white,
          iconColor: appTheme.deepPurple400,
        ),
        if (Responsive.isDesktop(context))
          Container(
            margin: EdgeInsets.only(left: 6.h, right: 12.h),
            child: InkWell(
              onTap: () {
                // TODO: Xử lý khi nhấp vào user
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 16.h,
                child: Icon(
                  Icons.person,
                  size: 20.h,
                  color: appTheme.deepPurple400,
                ),
              ),
            ),
          )
        else
          SizedBox(width: 8.h),
      ],
    );
  }

  /// Section Widget
  Widget _buildCategoriesList(BuildContext context) {
    // Sử dụng GridView cho màn hình desktop và ListView.builder cho màn hình điện thoại
    if (Responsive.isDesktop(context)) {
      // Desktop view - sử dụng GridView như cũ
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.h),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 10,
            childAspectRatio: 0.95,
            crossAxisSpacing: 4.h,
            mainAxisSpacing: 8.h,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoriesListItem(
              imagePath: category['imagePath'] as String,
              categoryName: category['categoryName'] as String,
              icon: category['icon'] as IconData,
            );
          },
        ),
      );
    } else {      // Mobile view - sử dụng ListView.builder với scroll ngang
      return Container(
        height: 75.h, // Tăng chiều cao để tránh overflow
        margin: EdgeInsets.symmetric(vertical: 4.h),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          padding: EdgeInsets.symmetric(horizontal: 12.h),
          itemBuilder: (context, index) {
            final category = categories[index];
            return Container(
              width: 58.h,
              margin: EdgeInsets.symmetric(horizontal: 3.h),
              child: CategoriesListItem(
                imagePath: category['imagePath'] as String,
                categoryName: category['categoryName'] as String,
                icon: category['icon'] as IconData,
              ),
            );
          },
        ),
      );
    }
  }

  // Widget phụ để tạo mỗi mục danh mục

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
    final List<Map<String, String>> products = SampleData.uiProducts;

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
    final List<Map<String, String>> products = SampleData.uiProducts;

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
