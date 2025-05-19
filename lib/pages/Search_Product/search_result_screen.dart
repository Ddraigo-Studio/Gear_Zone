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
import '../../model/review.dart';
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
  // Filter states
  List<String> selectedBrands = [];
  double minPrice = 0;
  double maxPrice = double.infinity;
  int minStarRating = 0;
  Map<String, ProductReviewSummary> reviewSummaries = {};

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.searchQuery);
    sortedResults = List.from(widget.searchResults); // Create a mutable copy
    _fetchReviewSummaries();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Fetch review summaries for all products to enable rating-based filtering
  void _fetchReviewSummaries() async {
    try {
      final productController = ProductController();
      for (var product in widget.searchResults) {
        final summary = await productController.getReviewSummary(product.id);
        setState(() {
          reviewSummaries[product.id] = summary;
        });
      }
    } catch (e) {
      print('Error fetching review summaries: $e');
    }
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

  // Apply filters to the search results
  void _applyFilters() {
    setState(() {
      sortedResults = widget.searchResults.where((product) {
        // Brand filter
        bool brandMatch = selectedBrands.isEmpty || selectedBrands.contains(product.brand);
        // Price filter
        bool priceMatch = product.price >= minPrice && product.price <= maxPrice;
        // Rating filter
        double avgRating = reviewSummaries[product.id]?.averageRating ?? 0;
        bool ratingMatch = avgRating >= minStarRating;

        return brandMatch && priceMatch && ratingMatch;
      }).toList();
    });
  }

  void _showFilterBottomSheet(BuildContext context) {
  // Get unique brands from search results
  final brands = widget.searchResults.map((p) => p.brand).toSet().toList();

  // Temporary filter states for the bottom sheet
  List<String> tempSelectedBrands = List.from(selectedBrands);
  double tempMinPrice = minPrice;
  double tempMaxPrice = maxPrice;
  int tempMinStarRating = minStarRating;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // Transparent to allow custom container color
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white, // Pastel purple background
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8.h,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with drag handle
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 8.h),
                        Container(
                          width: 40.h,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: Color(0xFFB39DDB),
                            borderRadius: BorderRadius.circular(2.h),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "Bộ lọc",
                          style: TextStyle(
                            fontSize: 20.h,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF424242),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 8.h),
                      children: [
                        // Brand filter
                        Text(
                          "Thương hiệu",
                          style: TextStyle(
                            fontSize: 16.h,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF424242),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Wrap(
                          spacing: 8.h,
                          runSpacing: 8.h,
                          children: brands.map((brand) {
                            return FilterChip(
                              label: Text(
                                brand.isEmpty ? "Không xác định" : brand,
                                style: TextStyle(
                                  fontSize: 14.h,
                                  color: tempSelectedBrands.contains(brand)
                                      ? Colors.white
                                      : Color(0xFF757575),
                                ),
                              ),
                              selected: tempSelectedBrands.contains(brand),
                              selectedColor: Color(0xFFB39DDB), // Pastel purple accent
                              checkmarkColor: Colors.white,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.h),
                                side: BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.h),
                              onSelected: (selected) {
                                setModalState(() {
                                  if (selected) {
                                    tempSelectedBrands.add(brand);
                                  } else {
                                    tempSelectedBrands.remove(brand);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 24.h),
                        // Price range filter
                        Text(
                          "Khoảng giá",
                          style: TextStyle(
                            fontSize: 16.h,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF424242),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: "Giá tối thiểu",
                                  labelStyle: TextStyle(color: Color(0xFF757575)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.h),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.h),
                                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.h),
                                    borderSide: BorderSide(color: Color(0xFF9575CD)),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  tempMinPrice = double.tryParse(value) ?? 0;
                                },
                              ),
                            ),
                            SizedBox(width: 12.h),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: "Giá tối đa",
                                  labelStyle: TextStyle(color: Color(0xFF757575)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.h),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.h),
                                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.h),
                                    borderSide: BorderSide(color: Color(0xFF9575CD)),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  tempMaxPrice = double.tryParse(value) ?? double.infinity;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        // Star rating filter
                        Text(
                          "Đánh giá tối thiểu",
                          style: TextStyle(
                            fontSize: 16.h,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF424242),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(5, (index) {
                            int rating = index + 1;
                            return ChoiceChip(
                              label: Row(
                                children: [
                                  Text(
                                    "$rating",
                                    style: TextStyle(
                                      fontSize: 14.h,
                                      color: tempMinStarRating == rating
                                          ? Colors.white
                                          : Color(0xFF757575),
                                    ),
                                  ),
                                  SizedBox(width: 4.h),
                                  Icon(
                                    Icons.star,
                                    size: 16.h,
                                    color: tempMinStarRating == rating
                                        ? Colors.white
                                        : Colors.amber,
                                  ),
                                ],
                              ),
                              selected: tempMinStarRating == rating,
                              selectedColor: Color(0xFFB39DDB),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.h),
                                side: BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.h),
                              onSelected: (selected) {
                                setModalState(() {
                                  tempMinStarRating = selected ? rating : 0;
                                });
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  // Apply and Reset buttons
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF757575),
                              side: BorderSide(color: Color(0xFFE0E0E0)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.h),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 30.h),
                              elevation: 0,
                            ),
                            onPressed: () {
                              setModalState(() {
                                tempSelectedBrands.clear();
                                tempMinPrice = 0;
                                tempMaxPrice = double.infinity;
                                tempMinStarRating = 0;
                              });
                            },
                            child: Text(
                              "Đặt lại",
                              style: TextStyle(
                                fontSize: 16.h,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.h),
                        Expanded(
                          child: ElevatedButton(
                            
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF9575CD), // Primary pastel purple
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.h),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 30.h),
                              elevation: 0,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedBrands = tempSelectedBrands;
                                minPrice = tempMinPrice;
                                maxPrice = tempMaxPrice;
                                minStarRating = tempMinStarRating;
                                _applyFilters();
                              });
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Áp dụng",
                              style: TextStyle(
                                fontSize: 16.h,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ),
  );
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
              onTap: () {
                _showFilterBottomSheet(context);
              },
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