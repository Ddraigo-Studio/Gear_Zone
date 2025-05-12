import 'package:flutter/material.dart';
import 'package:gear_zone/model/product.dart';
import '../../core/app_export.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(
                      left: 24.h,
                      top: 36.h,
                      right: 24.h,
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
            mainAxisAlignment:
                MainAxisAlignment.start, 
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
                "Còn hàng: ",
                style: CustomTextStyles.bodyMediumBalooBhaijaanGray900_1,
              ),
              Text(
                widget.product.quantity,
                style: CustomTextStyles.bodyMediumBalooBhaijaanRed500,
              ),
            ],
          ),
          if (widget.product.color.isNotEmpty)
            Row(
              children: [
                Text(
                  "Màu sắc: ${widget.product.color}",
                  style: CustomTextStyles.bodyMediumBalooBhaijaanDeeppurple500,
                ),
                Container(
                  height: 24.h,
                  width: 24.h,
                  margin: EdgeInsets.only(left: 10.h),
                  decoration: BoxDecoration(
                    color: appTheme.blueGray100,
                    borderRadius: BorderRadius.circular(12.h),
                    border: Border.all(
                      color: appTheme.gray900,
                      width: 1.5.h,
                    ),
                  ),
                ),
                Container(
                  height: 24.h,
                  width: 24.h,
                  margin: EdgeInsets.only(left: 10.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12.h),
                  ),
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    widget.product.getFormattedPrice(),
                    style: CustomTextStyles.titleMediumGabaritoPrimaryBold,
                  ),
                  if (widget.product.originalPrice > 0)
                    Padding(
                      padding: EdgeInsets.only(left: 10.h),
                      child: Text(
                        widget.product.getFormattedOriginalPrice(),
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
            return ProductVariantBottomsheet();
          },
        );
      }
    );
  }
}
