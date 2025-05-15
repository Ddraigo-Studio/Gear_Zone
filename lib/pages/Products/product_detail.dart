import 'package:flutter/material.dart';
import 'package:gear_zone/model/product.dart';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/color_utils.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/auto_image_slider.dart';
import '../../widgets/bottom_sheet/product_variant_bottomsheet.dart';
import '../../widgets/custom_floating_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/tab_page/product_tab_page.dart';
import '../../widgets/cart_icon_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // The currently selected color
  String selectedColor = "";
  // List of available color options for the product
  List<Map<String, dynamic>> colorOptions = [];
  @override
  void initState() {
    super.initState();
    // Initialize the selected color with the product's default color
    selectedColor = widget.product.color;

    // Parse and set color options from the product color data
    _parseProductColors();
  }

  // Parse colors from product data
  void _parseProductColors() {
    // Product color can be a comma-separated list of available colors
    // First, check if color contains multiple values
    List<String> colorsList = [];

    if (widget.product.color.contains(",")) {
      // Split the colors by comma if multiple colors are available
      colorsList =
          widget.product.color.split(",").map((color) => color.trim()).toList();
    } else if (widget.product.color.isNotEmpty) {
      // If only one color is available, add it to the list
      colorsList.add(widget.product.color.trim());
    }    // Convert string color names to color options with Color objects
    colorOptions = colorsList.map((colorName) {
      return {"name": colorName, "color": ColorUtils.getColorFromName(colorName)};
    }).toList(); // Make sure the selected color is in the available colors
    if (colorsList.isNotEmpty) {
      if (!colorsList.contains(selectedColor)) {
        selectedColor = colorsList.first;
      }
    } else {
      // If no colors are available, set an empty list instead of a default value
      selectedColor = "";
      colorOptions = []; // Empty list instead of default color
    }
  }


  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(
                    left: isDesktop ? 120.h : 24.h,
                    top: 36.h,
                    right: isDesktop ? 120.h : 24.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyImageSlider(product: widget.product),
                      SizedBox(height: 6.h),
                      _buildProductInfoRow(context),
                      SizedBox(height: 36.h),
                      ProductTabTabPage(product: widget.product),
                      SizedBox(height: 44.h),
                      _buildRatingRow(context),
                      SizedBox(height: 16.h),
                      _buildReviewRow(context),
                      SizedBox(height: 4.h),
                      _buildReviewRow(context),
                      SizedBox(height: 14.h),
                      _buildCommentButton(context),
                      SizedBox(height: 110.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 2,
      toolbarHeight: 80.h,
      backgroundColor: appTheme.whiteA700,
      leading: IconButton(
        icon: AppbarLeadingImage(
          imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
          height: 25.h,
          width: 25.h,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        CartIconButton(),
      ],
    );
  }

  /// Section Widget
  Widget _buildReviewRow(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgUser2,
                height: 40.h,
                width: 42.h,
                radius: BorderRadius.circular(20.h),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.h),
                child: Text(
                  "Alex Morgan",
                  style: CustomTextStyles.labelLargeGray900,
                ),
              ),
              Spacer(),
              Row(
                children: List.generate(5, (index) {
                  return CustomImageView(
                    imagePath: ImageConstant.imgDefaultIcon,
                    height: 16.h,
                    width: 18.h,
                  );
                }),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  "Gucci transcribes its heritage, creativity, and innovation into a plentitude of collections. From staple items to distinctive accessories.",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.bodySmallBalooBhaiGray900_1.copyWith(
                    height: 1.60,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  "12 ngày trước",
                  style: CustomTextStyles.bodySmallBalooBhaiGray900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfoRow(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 10.h,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.titleMediumGabaritoBlack900,
            ),
          ),
          Row(
            children: [
              Text(
                "Tình trạng: ",
                style: CustomTextStyles.bodyMediumBalooBhaijaanGray900_1,
              ),
              Text(
                widget.product.inStock ? "Còn hàng" : "Hết hàng",
                style: CustomTextStyles.bodyMediumBalooBhaijaanRed500.copyWith(
                  color: widget.product.inStock ? Colors.green : Colors.red,
                ),
              ),
            ],
          ), // Chỉ hiển thị thông tin màu sắc nếu sản phẩm có màu sắc thực sự và danh sách màu không trống
          if (widget.product.color.isNotEmpty &&
              colorOptions.isNotEmpty &&
              colorOptions[0]["name"] != "Default")
            Row(
              children: [
                Text(
                  "Màu sắc: ",
                  style: CustomTextStyles.bodyMediumBalooBhaijaanGray900_1,
                ),
                SizedBox(width: 8.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: colorOptions.map((colorOption) {
                      final bool isSelected =
                          selectedColor == colorOption["name"];
                      return Tooltip(
                        message: colorOption["name"],
                        preferBelow: false,
                        verticalOffset: 20,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedColor = colorOption["name"];
                            });
                          },
                          child: Container(
                            height: 32.h,
                            width: 32.h,
                            decoration: BoxDecoration(
                              color: colorOption["color"],
                              borderRadius: BorderRadius.circular(16.h),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.transparent,
                                width: isSelected ? 1 : 0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: appTheme.black900.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: isSelected
                                ? Center(                                    child: Icon(
                                      Icons.check,
                                      color: ColorUtils.shouldUseWhiteText(
                                              colorOption["color"])
                                          ? Colors.white
                                          : Colors.black,
                                      size: 18.h,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          SizedBox(height: 8.h),
          // Color selection options

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    ProductModel.formatPrice(widget.product.price),
                    style: CustomTextStyles.titleMediumGabaritoPrimaryBold,
                  ),
                  if (widget.product.originalPrice > 0)
                    Padding(
                      padding: EdgeInsets.only(left: 10.h),
                      child: Text(
                        ProductModel.formatPrice(widget.product.originalPrice),
                        style:
                            CustomTextStyles.titleSmallGabaritoGray900.copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                ],
              ),
              Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: CustomIconButton(
                    height: 40.h,
                    width: 40.h,
                    // padding: EdgeInsets.all(12.h),
                    decoration: IconButtonStyleHelper.outline,
                    child: CustomImageView(
                      imagePath: ImageConstant.imgIconsaxBrokenHeart,
                    ),
                  ),
                  onPressed: () {
                    // Hành động khi nhấn vào nút giỏ hàng
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "4.5/5",
            style: CustomTextStyles.headlineSmallRed500,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgDefaultIcon,
            height: 16.h,
            width: 18.h,
            margin: EdgeInsets.only(left: 2.h),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.h),
            child: Text(
              "213 lượt đánh giá",
              style: CustomTextStyles.bodySmallBalooBhaiDeeppurple400,
            ),
          ),
          Spacer(),
          Text(
            "Xem tất cả",
            style: CustomTextStyles.bodyMediumAmaranthRed500,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgIconsaxBrokenArrowright2,
            height: 16.h,
            width: 18.h,
            margin: EdgeInsets.only(left: 4.h),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentButton(BuildContext context) {
    return CustomOutlinedButton(
      height: 40.h,
      text: "Bình luận",
      margin: EdgeInsets.symmetric(horizontal: 70.h),
      buttonStyle: CustomButtonStyles.outlinePrimaryTL20,
      buttonTextStyle: CustomTextStyles.bodyLargeBalooBhaijaanDeeppurple400,
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return IconButton(
        icon: CustomFloatingButton(
          height: 50,
          width: 50,
          backgroundColor: theme.colorScheme.primary,
          shape: null,
          child: CustomImageView(
            imagePath: ImageConstant.imgIconsaxBrokenBag2WhiteA700,
            height: 25.0.h,
            width: 25.0.h,
          ),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {              
              return ProductVariantBottomsheet(
                initialSelectedColor: selectedColor,
                availableColors: colorOptions,
                productName: widget.product.name,
                productImage: widget.product.imageUrl,
                productPrice: ProductModel.formatPrice(widget.product.price),
                productOriginalPrice: widget.product.originalPrice > 0
                    ? ProductModel.formatPrice(widget.product.originalPrice)
                    : "",
                productStock: widget.product.quantity,
                productId: widget.product.id,
                onAddToCart: (color, quantity) {
                  // Handle add to cart action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Đã thêm $quantity sản phẩm màu $color vào giỏ hàng'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          );
        });
  }
}
