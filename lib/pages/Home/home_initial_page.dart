import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/items/categories_list_item.dart';
import '../../widgets/items/recently_viewed_item.dart';
import '../../widgets/banner_slider.dart';
import '../../widgets/cart_icon_button.dart';
import '../../widgets/items/product_carousel_item_widget.dart';
import '../Products/category_screen.dart';
import '../../model/product.dart';
import '../../model/category.dart';
import '../../controller/product_controller.dart';
import '../../controller/category_controller.dart';
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
  final ProductController _productController = ProductController();
  final CategoryController _categoryController = CategoryController();

  // Product lists
  List<ProductModel> newestProducts = [];
  List<ProductModel> promotionProducts = [];
  List<ProductModel> bestSellingProducts = [];
  List<ProductModel> laptopProducts = [];
  List<ProductModel> monitorProducts = [];
  List<ProductModel> keyboardProducts = [];
  List<ProductModel> mouseProducts = [];
  List<ProductModel> headphoneProducts = [];

  // Category list
  List<CategoryModel> categories = [];
  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCategories();
  }

  // Load category data from controller
  Future<void> _loadCategories() async {
    try {
      setState(() {
        // Initialize with empty list and set loading state if needed
        categories = [];
      });

      // Listen to Firestore stream for real-time category updates
      _categoryController.getCategories().listen((fetchedCategories) {
        if (mounted) {
          setState(() {
            categories = fetchedCategories;
          });
        }
      }, onError: (error) {
        print('Lỗi khi tải dữ liệu danh mục: $error');
      });
    } catch (e) {
      print('Lỗi khi tải dữ liệu danh mục: $e');
    }
  }

  // Load all product data from controller
  Future<void> _loadProducts() async {
    try {
      setState(() {
        // Initialize with empty lists
        newestProducts = [];
        promotionProducts = [];
        bestSellingProducts = [];
        laptopProducts = [];
        monitorProducts = [];
        keyboardProducts = [];
        mouseProducts = [];
        headphoneProducts = [];
      });

      // Nếu kết nối được Firebase, sẽ cập nhật lại dữ liệu
      _productController.getNewestProducts().listen((products) {
        if (mounted) {
          setState(() {
            newestProducts = products;
          });
        }
      }, onError: (e) {
        print('Lỗi khi tải sản phẩm mới nhất: $e');
      });

      _productController.getPromotionProducts().listen((products) {
        if (mounted) {
          setState(() {
            promotionProducts = products;
          });
        }
      }, onError: (e) {
        print('Lỗi khi tải sản phẩm khuyến mãi: $e');
      });

      try {
        final bestSelling = await _productController.getBestSellingProducts();
        if (mounted) {
          setState(() {
            bestSellingProducts = bestSelling;
          });
        }
      } catch (e) {
        print('Lỗi khi tải sản phẩm bán chạy: $e');
      }

      try {
        final laptops = await _productController.getLaptopProducts();
        if (mounted) {
          setState(() {
            laptopProducts = laptops;
          });
        }
      } catch (e) {
        print('Lỗi khi tải sản phẩm laptop: $e');
      }
      try {
        final monitors = await _productController.getMonitorProducts();
        if (mounted) {
          setState(() {
            monitorProducts = monitors;
          });
        }
      } catch (e) {
        print('Lỗi khi tải sản phẩm màn hình: $e');
      }

      try {
        final keyboards = await _productController.getKeyboardProducts();
        if (mounted) {
          setState(() {
            keyboardProducts = keyboards;
          });
        }
      } catch (e) {
        print('Lỗi khi tải sản phẩm bàn phím: $e');
      }

      try {
        final mice = await _productController.getMouseProducts();
        if (mounted) {
          setState(() {
            mouseProducts = mice;
          });
        }
      } catch (e) {
        print('Lỗi khi tải sản phẩm chuột: $e');
      }

      try {
        final headphones = await _productController.getHeadphoneProducts();
        if (mounted) {
          setState(() {
            headphoneProducts = headphones;
          });
        }
      } catch (e) {
        print('Lỗi khi tải sản phẩm tai nghe: $e');
      }
    } catch (e) {
      print('Lỗi khi tải dữ liệu sản phẩm: $e');
    }
  }

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
                          Responsive.isDesktop(context)
                              ? Container()
                              : TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CategoriesScreen()),
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
      toolbarHeight:
          isDesktop ? 70.h : 75.h, // Tăng chiều cao của AppBar trên desktop
      backgroundColor: appTheme.deepPurple400,
      automaticallyImplyLeading: false,
      leadingWidth: isDesktop ? 70.h : 70.h, // Mở rộng không gian cho logo
      leading: Container(
        padding: EdgeInsets.only(left: isDesktop ? 16.h : 16.h),
        child: Container(
          width: isDesktop ? 40.h : 35.h, // Logo lớn hơn trên desktop
          height: isDesktop ? 40.h : 35.h, // Logo lớn hơn trên desktop
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
                    fontSize: 20.fSize, // Tăng kích thước chữ logo
                  ),
                )
              : Container(), // Empty container for mobile
          Responsive.isDesktop(context)
              ? Spacer()
              : SizedBox(width: 10.h), // Empty container for mobile
          Flexible(
            child: Container(
              height: isDesktop ? 40.h : 35.h, // Tăng chiều cao thanh tìm kiếm
              width:
                  isDesktop ? 300.h : 400.h, // Tăng chiều rộng thanh tìm kiếm
              margin: EdgeInsets.symmetric(vertical: isDesktop ? 8.h : 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.h),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sản phẩm',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize:
                        isDesktop ? 14.h : 12.h, // Tăng kích thước chữ gợi ý
                  ),
                  isDense: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 8.h, right: 4.h),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: isDesktop
                          ? 20.h
                          : 15.h, // Tăng kích thước icon tìm kiếm
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth:
                        isDesktop ? 40.h : 36.h, // Tăng kích thước vùng icon
                    minHeight:
                        isDesktop ? 40.h : 36.h, // Tăng kích thước vùng icon
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      vertical:
                          isDesktop ? 10.h : 8.h), // Tăng padding nội dung
                ),
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  fontSize:
                      isDesktop ? 14.h : 12.h, // Tăng kích thước chữ nhập liệu
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 8.h : 6.h),
            child: isDesktop
                ? Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                          size: 28.h, // Tăng kích thước icon thông báo
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.white,
                          size: 28.h, // Tăng kích thước icon yêu thích
                        ),
                        onPressed: () {},
                      ),
                    ],
                  )
                : Container()),
        CartIconButton(
          iconSize: isDesktop
              ? 40.h
              : null, // Tăng kích thước icon giỏ hàng (từ 28.h lên 40.h)
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
                radius: 22.h, // Tăng kích thước avatar
                child: Icon(
                  Icons.person,
                  size: 26.h, // Tăng kích thước icon người dùng
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
    // Show loading indicator when categories are empty (still loading)
    if (categories.isEmpty) {
      return Container(
        height: Responsive.isDesktop(context) ? 100.h : 75.h,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(appTheme.deepPurple400),
          ),
        ),
      );
    }

    // Sử dụng GridView cho màn hình desktop và ListView.builder cho màn hình điện thoại
    if (Responsive.isDesktop(context)) {
      // Desktop view - sử dụng GridView với kích thước lớn hơn
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                10, // Giảm số cột để item lớn hơn (từ 10 xuống còn 8)
            childAspectRatio: 1, // Tăng tỷ lệ khung hình cho các mục to hơn
            crossAxisSpacing: 14.h, // Tăng khoảng cách giữa các cột
            mainAxisSpacing: 14.h, // Tăng khoảng cách giữa các hàng
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoriesListItem(
              imagePath: category.imagePath,
              categoryName: category.categoryName,
              id: category.id,
            );
          },
        ),
      );
    } else {
      // Mobile view - sử dụng ListView.builder với scroll ngang
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
                imagePath: category.imagePath,
                categoryName: category.categoryName,
                id: category.id,
              ),
            );
          },
        ),
      );
    }
  }

  // Widget phụ để tạo mỗi mục danh mục
  /// Section Widget  // Widget phụ để tạo mỗi mục danh mục
  /// Section Widget
  Widget _buildProductCarousel(BuildContext context) {
    // Show loading indicator if products are still loading
    if (bestSellingProducts.isEmpty) {
      return Container(
        height: Responsive.isDesktop(context) ? 200.h : 260.h,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(appTheme.deepPurple400),
          ),
        ),
      );
    }

    // For desktop view, use a grid layout with more items per row
    if (Responsive.isDesktop(context)) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.h),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: SizeUtils.getGridItemCount(),
            childAspectRatio: 0.85,
            crossAxisSpacing: 18.h,
            mainAxisSpacing: 18.h,
          ),
          itemCount: bestSellingProducts.length,
          itemBuilder: (context, index) {
            return ProductCarouselItem(
              product: bestSellingProducts[index],
            );
          },
        ),
      );
    } else {
      // For mobile view, keep the horizontal ListView
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.h),
        height: 260.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: bestSellingProducts.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: 16.h, bottom: 2.h),
              child: ProductCarouselItem(
                product: bestSellingProducts[index],
              ),
            );
          },
        ),
      );
    }
  }

  Widget _buildLaptopTopSell(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    // Show loading indicator if products are still loading
    if (laptopProducts.isEmpty) {
      return Container(
        height: isDesktop ? 200.h : 260.h,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(appTheme.deepPurple400),
          ),
        ),
      );
    }

    if (isDesktop) {
      // Desktop view - use grid layout
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.h),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: SizeUtils.getGridItemCount(),
            childAspectRatio: 0.85,
            crossAxisSpacing: 18.h,
            mainAxisSpacing: 18.h,
          ),
          itemCount: laptopProducts.length,
          itemBuilder: (context, index) {
            return ProductCarouselItem(
              product: laptopProducts[index],
            );
          },
        ),
      );
    }

    // Mobile view - use horizontal list
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      height: 260.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: laptopProducts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 16.h, bottom: 2.h),
            child: ProductCarouselItem(
              product: laptopProducts[index],
            ),
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildNeweProductSection(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    // Show loading indicator if products are still loading
    if (newestProducts.isEmpty) {
      return Container(
        height: isDesktop ? 200.h : 260.h,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(appTheme.deepPurple400),
          ),
        ),
      );
    }

    // Determine grid layout for desktop, list for mobile
    if (isDesktop) {
      // For desktop view, use a grid layout with more items per row
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.h),
        // Don't constrain height for grid
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: SizeUtils.getGridItemCount(),
            childAspectRatio: 0.85,
            crossAxisSpacing: 18.h,
            mainAxisSpacing: 18.h,
          ),
          itemCount: newestProducts.length,
          itemBuilder: (context, index) {
            return ProductCarouselItem(
              product: newestProducts[index],
            );
          },
        ),
      );
    } else {
      // For mobile view, keep the horizontal ListView
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.h),
        height: 260.h,
        child: newestProducts.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(appTheme.deepPurple400),
                ),
              )
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: newestProducts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 16.h, bottom: 2.h),
                    child: ProductCarouselItem(
                      product: newestProducts[index],
                    ),
                  );
                },
              ),
      );
    }
  }

  Widget _buildWishListSection(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    // Show loading indicator if products are still loading
    if (promotionProducts.isEmpty) {
      return Container(
        height: isDesktop ? 290.h : 260.h,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(appTheme.deepPurple400),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      height: isDesktop ? 290.h : 260.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: promotionProducts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 16.h, bottom: 2.h),
            child: WishListItem(
              index: index,
              product: promotionProducts[index],
            ),
          );
        },
      ),
    );
  }
}
