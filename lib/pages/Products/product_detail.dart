import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
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
import '../../controller/review_controller.dart';
import '../../model/product.dart';
import '../../model/review.dart';
import '../../widgets/product_review_list.dart';
import 'dialog_review.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedColor = "";
  List<Map<String, dynamic>> colorOptions = [];
  late WebSocketChannel _channel;
  ProductReviewSummary? _summary;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.product.color;
    _parseProductColors();
    // Connect to WebSocket
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8080?productId=${widget.product.id}'),
    );
    // Listen for summary updates
    _channel.stream.listen(
      (message) {
        final data = jsonDecode(message);
        if (data['type'] == 'summary_update') {
          final summaryData = data['summary'];
          setState(() {
            _summary = ProductReviewSummary(
              productId: summaryData['productId'],
              averageRating: (summaryData['averageRating'] as num).toDouble(),
              numberOfReviews: (summaryData['numberOfReviews'] as num).toInt(),
              ratingDistribution: Map<int, int>.fromEntries(
                (summaryData['ratingDistribution'] as Map<String, dynamic>)
                    .entries
                    .map((e) => MapEntry(int.parse(e.key), (e.value as num).toInt())),
              ),
            );
          });
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket closed');
      },
    );
    // Fetch initial summary
    _fetchInitialSummary();
  }

  Future<void> _fetchInitialSummary() async {
    final summary = await ReviewController().getProductReviewSummary(widget.product.id);
    setState(() {
      _summary = summary;
    });
  }

  void _parseProductColors() {
    List<String> colorsList = [];
    if (widget.product.color.contains(",")) {
      colorsList = widget.product.color.split(",").map((color) => color.trim()).toList();
    } else if (widget.product.color.isNotEmpty) {
      colorsList.add(widget.product.color.trim());
    }
    colorOptions = colorsList.map((colorName) {
      return {
        "name": colorName,
        "color": ColorUtils.getColorFromName(colorName)
      };
    }).toList();
    if (colorsList.isNotEmpty && !colorsList.contains(selectedColor)) {
      selectedColor = colorsList.first;
    } else if (colorsList.isEmpty) {
      selectedColor = "";
      colorOptions = [];
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
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
                      _buildRatingSection(context),
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

  Widget _buildCommentButton(BuildContext context) {
    bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return CustomOutlinedButton(
      height: 40.h,
      text: "Bình luận",
      margin: EdgeInsets.symmetric(horizontal: 70.h),
      buttonStyle: CustomButtonStyles.outlinePrimaryTL20,
      buttonTextStyle: CustomTextStyles.bodyLargeBalooBhaijaanDeeppurple400,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ProductReviewSubmissionDialog(
              productId: widget.product.id,
              isLoggedIn: isLoggedIn,
              onReviewSubmitted: () {
                // No setState needed; WebSocket handles updates
              },
            );
          },
        );
      },
    );
  }

  Widget _buildRatingSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Đánh giá sản phẩm',
                style: CustomTextStyles.titleMediumBalooBhai2Gray700,
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full reviews page
                },
                child: Row(
                  children: [
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
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _summary != null ? "${_summary!.averageRating.toStringAsFixed(1)}/5" : "0.0/5",
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
                  _summary != null
                      ? "${_summary!.numberOfReviews} lượt đánh giá"
                      : "0 lượt đánh giá",
                  style: CustomTextStyles.bodySmallBalooBhaiDeeppurple400,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ProductReviewList(
            productId: widget.product.id,
          ),
          SizedBox(height: 16.h),
          _buildCommentButton(context),
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
          ),
          if (widget.product.color.isNotEmpty && colorOptions.isNotEmpty && colorOptions[0]["name"] != "Default")
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
                      final bool isSelected = selectedColor == colorOption["name"];
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
                                color: isSelected ? Colors.black : Colors.transparent,
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
                                ? Center(
                                    child: Icon(
                                      Icons.check,
                                      color: ColorUtils.shouldUseWhiteText(colorOption["color"])
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
                        style: CustomTextStyles.titleSmallGabaritoGray900.copyWith(
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
                    decoration: IconButtonStyleHelper.outline,
                    child: CustomImageView(
                      imagePath: ImageConstant.imgIconsaxBrokenHeart,
                    ),
                  ),
                  onPressed: () {
                    // Handle favorite action
                  },
                ),
              ),
            ],
          ),
        ],
      ),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã thêm $quantity sản phẩm màu $color vào giỏ hàng'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}