import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/items/product_carousel_item_widget.dart';
import '../../widgets/app_bar/appbar_title_searchview.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../model/product.dart';
import '../../controller/product_controller.dart';
import 'search_result_empty_screen.dart';

class SearchResultScreen extends StatefulWidget {
  final String searchQuery;
  final List<ProductModel> searchResults;

  SearchResultScreen({
    super.key,
    this.searchQuery = "",
    this.searchResults = const [],
  });

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late TextEditingController searchController;
  late List<ProductModel> sortedResults;
  bool isSortByNameAscending = true; // True: A-Z, False: Z-A
  bool isSortByPriceAscending = true; // True: Low to High, False: High to Low

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.searchQuery);
    sortedResults = List.from(widget.searchResults); // Create a mutable copy
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _sortByName() {
    setState(() {
      isSortByNameAscending = !isSortByNameAscending;
      sortedResults.sort((a, b) {
        final comparison = a.name.compareTo(b.name);
        return isSortByNameAscending ? comparison : -comparison;
      });
    });
  }

  void _sortByPrice() {
    setState(() {
      isSortByPriceAscending = !isSortByPriceAscending;
      sortedResults.sort((a, b) {
        final comparison = a.price.compareTo(b.price);
        return isSortByPriceAscending ? comparison : -comparison;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              _buildSettingsRow(context),
              SizedBox(height: 32.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.h),
                child: Text(
                  "${sortedResults.length} Kết quả",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.titleMediumGabaritoGray900,
                ),
              ),
              SizedBox(height: 6.h),
              _buildSearchResultsGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        color: const Color.fromARGB(255, 235, 230, 236), // Light pastel purple
        child: CustomAppBar(
          leadingWidth: 56.h,
          leading: Container(
            margin: EdgeInsets.only(left: 16.h, top: 8.h, bottom: 8.h),
            child: IconButton(
              icon: CustomImageView(
                imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
                height: 24.h,
                width: 24.h,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                padding: EdgeInsets.all(8.h),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: SizedBox(
            width: double.maxFinite,
            child: AppbarTitleSearchview(
              margin: EdgeInsets.only(left: 10.h, right: 10.h),
              hintText: widget.searchQuery.isNotEmpty ? widget.searchQuery : "Tìm kiếm sản phẩm",
              controller: searchController,
              onSubmitted: (value) {
                _performSearch(context, value);
              },
            ),
          ),
          actions: [
            AppbarTrailingIconbuttonOne(
              imagePath: ImageConstant.imgFilter,
              height: 44.h,
              width: 44.h,
              margin: EdgeInsets.only(top: 5.h, right: 17.h, bottom: 6.h),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch(BuildContext context, String query) async {
    if (query.trim().isEmpty) return;

    try {
      final productController = ProductController();
      final searchResult = await productController.searchProductsPaginated(query);
      final List<ProductModel> results = searchResult['products'] as List<ProductModel>;

      if (results.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultScreen(
              searchQuery: query,
              searchResults: results,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultEmptyScreen(
              searchQuery: query,
            ),
          ),
        );
      }
    } catch (e) {
      print('Lỗi khi tìm kiếm: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi khi tìm kiếm. Vui lòng thử lại.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildSortByNameButton(BuildContext context) {
    return Expanded(
      child: CustomElevatedButton(
        height: 35.h,
        text: "Sắp xếp theo tên",
        margin: EdgeInsets.only(left: 10.h),
        rightIcon: Container(
          margin: EdgeInsets.only(left: 4.h),
          child: Icon(
            isSortByNameAscending ? Icons.arrow_upward : Icons.arrow_downward,
            size: 16.h,
            color: Colors.white, // Match button text color
          ),
        ),
        buttonStyle: CustomButtonStyles.fillPrimaryTL12,
        buttonTextStyle: CustomTextStyles.bodySmallBasicWhiteA700,
        onPressed: _sortByName,
      ),
    );
  }

  Widget _buildSortByPriceButton(BuildContext context) {
    return Expanded(
      child: CustomElevatedButton(
        height: 35.h,
        text: "Sắp xếp theo giá",
        margin: EdgeInsets.only(left: 10.h),
        rightIcon: Container(
          margin: EdgeInsets.only(left: 4.h),
          child: Icon(
            isSortByPriceAscending ? Icons.arrow_upward : Icons.arrow_downward,
            size: 16.h,
            color: appTheme.gray900, // Match button text color
          ),
        ),
        buttonStyle: CustomButtonStyles.fillGray,
        buttonTextStyle: CustomTextStyles.bodySmallBasicGray900,
        onPressed: _sortByPrice,
      ),
    );
  }

  Widget _buildSettingsRow(BuildContext context) {
    return Row(
      children: [
        _buildSortByNameButton(context),
        _buildSortByPriceButton(context),
      ],
    );
  }

  Widget _buildSearchResultsGrid(BuildContext context) {
    if (sortedResults.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            "Không tìm thấy sản phẩm nào",
            style: CustomTextStyles.titleMediumGabaritoGray900,
          ),
        ),
      );
    }

    return Expanded(
      child: ResponsiveGridListBuilder(
        minItemWidth: 120.h,
        minItemsPerRow: 2,
        maxItemsPerRow: 3,
        horizontalGridSpacing: 22.h,
        verticalGridSpacing: 22.h,
        builder: (context, items) => ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          children: items,
        ),
        gridItems: List.generate(
          sortedResults.length,
          (index) => ProductCarouselItem(product: sortedResults[index]),
        ),
      ),
    );
  }
}