import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton_one.dart';
import '../../widgets/app_bar/appbar_title_searchview.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../controller/product_controller.dart';
import '../../model/product.dart';
import 'search_result_screen.dart';

// ignore_for_file: must_be_immutable
class SearchResultEmptyScreen extends StatelessWidget {
  final String searchQuery;

  SearchResultEmptyScreen({
    super.key,
    this.searchQuery = "",
  });

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Thiết lập giá trị tìm kiếm từ tham số nếu controller trống
    if (searchController.text.isEmpty && searchQuery.isNotEmpty) {
      searchController.text = searchQuery;
    }

    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Replace CustomImageView with Icon
              Icon(
                Icons.search_off, // Icon for empty search result
                size: 120.h, // Match the size of the original image
                color: appTheme.gray900, // Match the text color theme
              ),
              SizedBox(height: 24.h),
              Text(
                "Xin lỗi, chúng tôi không tìm thấy sản phẩm bạn yêu cầu",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTextStyles.headlineSmallBalooBhai,
              ),
              SizedBox(height: 32.h),
              CustomElevatedButton(
                height: 56.h,
                text: "Tiếp tục mua sắm",
                margin: EdgeInsets.symmetric(horizontal: 40.h),
                buttonStyle: CustomButtonStyles.fillPrimaryTL30,
                buttonTextStyle: CustomTextStyles.titleLargeBalooBhaijaan,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
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
              hintText: searchQuery.isNotEmpty ? searchQuery : "Tìm kiếm sản phẩm",
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

  // Phương thức tìm kiếm
  void _performSearch(BuildContext context, String query) async {
    if (query.trim().isEmpty) return;

    try {
      // Sử dụng ProductController để tìm kiếm
      final productController = ProductController();
      final searchResult =
          await productController.searchProductsPaginated(query);
      final List<ProductModel> results =
          searchResult['products'] as List<ProductModel>;

      if (results.isNotEmpty) {
        // Nếu có kết quả, chuyển đến màn hình kết quả tìm kiếm
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
        // Nếu không có kết quả, cập nhật màn hình hiện tại
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
}