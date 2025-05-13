import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../pages/Products/product_detail.dart';
import '../bottom_sheet/product_variant_bottomsheet.dart';
import '../custom_icon_button.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/color_utils.dart';
import '../../model/product.dart';

class ProductCarouselItem extends StatelessWidget {
  final ProductModel product;

  const ProductCarouselItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final bool isTablet = Responsive.isTablet(context);

    // Lấy dữ liệu đã được xử lý từ model
    String discountPercent = product.getDiscountPercent();
    String formattedPrice = product.getFormattedPrice();
    String formattedOriginalPrice = product.getFormattedOriginalPrice();

    final double itemWidth = 160.h; // Smallest width for mobile
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        width: itemWidth,
        decoration: AppDecoration.fillGray.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder16,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: Offset(0, 2),
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconButton(
                    height: isDesktop ? 34.h : 30.h,
                    width: isDesktop ? 34.h : 30.h,
                    padding: EdgeInsets.all(6.h),
                    decoration: IconButtonStyleHelper.none,
                    alignment: Alignment.centerRight,
                    child: CustomImageView(
                      imagePath: ImageConstant.imgHeartIconlyPro,
                    ),
                    onTap: () {
                      // Add your custom logic here
                    },
                  ),
                  SizedBox(height: 10.h), // Further reduced spacing
                  CustomImageView(
                    imagePath: product.imageUrl.isEmpty
                        ? ImageConstant.imgLogo
                        : product.imageUrl,
                    height: Responsive.isDesktop(context)
                        ? 95.h // Reduced height
                        : Responsive.isTablet(context)
                            ? 70.h // Reduced height
                            : 70.h, // Reduced height
                    width: Responsive.isDesktop(context)
                        ? 95.h // Reduced width
                        : Responsive.isTablet(context)
                            ? 70.h // Reduced width
                            : 70.h, // Reduced width
                    fit: BoxFit.contain,
                    placeHolder: ImageConstant
                        .imgLogo, // Sử dụng icon mặc định thay vì image_not_found
                  ),
                  SizedBox(height: isDesktop ? 12.h : 10.h), // Reduced spacing
                  _ProductTitle(
                      title: product.name,
                      isDesktop: isDesktop), // tên sản phẩm
                  SizedBox(height: 3.h), // Reduced spacing
                  _ProductPrice(
                    originalPrice: formattedOriginalPrice,
                    discountPrice: formattedPrice,
                    discountPercent: discountPercent,
                    isDesktop: isDesktop,
                  ),
                  SizedBox(height: 3.h), // Reduced spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ProductRating(
                          rating: "4.5",
                          isDesktop: isDesktop), // Hardcoded rating for now
                      _AddToCartButton(
                        isDesktop: isDesktop,
                        product: product,
                      ),
                    ],
                  ) //  nút thêm vào giỏ hàng
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget cho tên sản phẩm
class _ProductTitle extends StatelessWidget {
  final String title;
  final bool isDesktop;

  const _ProductTitle({required this.title, this.isDesktop = false});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 6.h),
        child: Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: isDesktop ? 12.fSize : 11.fSize,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1, // Limit to 1 line to save space
        ),
      ),
    );
  }
}

// Widget cho giá sản phẩm
class _ProductPrice extends StatelessWidget {
  final String originalPrice;
  final String discountPrice;
  final String discountPercent;
  final bool isDesktop;

  const _ProductPrice({
    required this.originalPrice,
    required this.discountPrice,
    required this.discountPercent,
    this.isDesktop = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Add this to minimize vertical space
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  originalPrice,
                  style: theme.textTheme.labelMedium!.copyWith(
                    decoration: TextDecoration.lineThrough,
                    fontSize:
                        isDesktop ? 12.fSize : 9.fSize, // Reduced font size
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.h, // Reduced horizontal padding
                    vertical: 2.h, // Reduced vertical padding
                  ),
                  decoration: AppDecoration.outlineRed.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder8,
                  ),
                  child: RotationTransition(
                    turns: AlwaysStoppedAnimation(0),
                    child: Text(
                      discountPercent.toUpperCase(),
                      textAlign: TextAlign.left,
                      style: CustomTextStyles.labelMediumInterRed500.copyWith(
                        fontSize:
                            isDesktop ? 9.fSize : 8.fSize, // Reduced font size
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            discountPrice,
            style: theme.textTheme.labelLarge?.copyWith(
              fontSize: isDesktop ? 12.fSize : 11.fSize, // Reduced font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget cho đánh giá sản phẩm
class _ProductRating extends StatelessWidget {
  final String rating;
  final bool isDesktop;

  const _ProductRating({required this.rating, this.isDesktop = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgDefaultIcon,
          height: isDesktop ? 32.h : 25.h, // Reduced height
          width: isDesktop ? 22.h : 18.h, // Reduced width
        ),
        Padding(
          padding: EdgeInsets.only(left: 4.h),
          child: Text(
            rating,
            style: CustomTextStyles.bodySmallEncodeSansGray90001.copyWith(
              fontSize: isDesktop ? 10.fSize : 9.fSize, // Smaller font size
            ),
          ),
        ),
      ],
    );
  }
}

// Widget cho nút "Thêm vào giỏ hàng"
class _AddToCartButton extends StatelessWidget {
  final bool isDesktop;
  final ProductModel product;

  const _AddToCartButton({this.isDesktop = false, required this.product});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      height: isDesktop ? 36.h : 28.h, // Reduced height
      width: isDesktop ? 36.h : 28.h, // Reduced width
      padding: EdgeInsets.all(isDesktop ? 5.h : 4.h),
      decoration: IconButtonStyleHelper.fillDeepPurple,
      child: CustomImageView(
        imagePath: ImageConstant.imgIconsaxBrokenBag2Gray100,
      ),
      onTap: () {
        // Tạo danh sách các màu từ thông tin sản phẩm
        List<Map<String, dynamic>> colorOptions = [];
        // Nếu không có màu được chỉ định, để colorOptions trống
        if (!product.color.isEmpty) {
          // Sử dụng ColorUtils để chuyển đổi tên màu sang đối tượng Color
          if (product.color is List<String>) {
            for (String colorName in product.color as List<String>) {
              colorOptions.add({
                "name": colorName,
                "color": ColorUtils.getColorFromName(colorName),
              });
            }
          } else {
            // Assume product.color is a single String
            colorOptions.add({
              "name": product.color,
              "color": ColorUtils.getColorFromName(product.color),
            });
          }
        }

        String selectedColor =
            colorOptions.isNotEmpty ? colorOptions[0]["name"] : "Default";

        showModalBottomSheet(
            context: context,
            builder: (context) {
              return ProductVariantBottomsheet(
                initialSelectedColor: selectedColor,
                availableColors: colorOptions,
                productName: product.name,
                productImage: product.imageUrl,
                productPrice: product.getFormattedPrice(),
                productOriginalPrice: product.originalPrice > 0
                    ? product.getFormattedOriginalPrice()
                    : "",
                productStock: product.quantity,
                productId: product.id,
                onAddToCart: (color, quantity) {
                  
                },
              );
            });
      },
    );
  }
}
