import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../pages/Products/product_detail.dart';
import '../custom_icon_button.dart';
import '../../core/utils/responsive.dart';
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

    // Tính phần trăm giảm giá
    String discountPercent = '';
    if (product.originalPrice > 0 && product.price < product.originalPrice) {
      double discount =
          ((product.originalPrice - product.price) / product.originalPrice) *
              100;
      discountPercent = "${discount.round()}%";
    } else {
      discountPercent = "${product.discount}%";
    }

    // Format giá tiền
    String formattedPrice = "${product.price.toStringAsFixed(0)}đ";
    String formattedOriginalPrice =
        "${product.originalPrice.toStringAsFixed(0)}đ";

    // Adjust item width based on device type
    // Desktop should be proportionally sized for larger screens
    // Tablet gets medium sizing
    // Mobile gets smallest size
    final double itemWidth = 165.h; // Smallest width for mobile
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailScreen()),
        );
      },
      child: Container(
        width: itemWidth,
        // Add a fixed height based on device type to prevent overflow
        height: isDesktop ? 275.h : 250.h,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.all(6.h),
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
                  SizedBox(
                      height:
                          isDesktop ? 10.h : 8.h), // Further reduced spacing
                  CustomImageView(
                    imagePath: product.imageUrl.isEmpty
                        ? ImageConstant.imgImage1
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
                      _AddToCartButton(isDesktop: isDesktop),
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
      margin: EdgeInsets.symmetric(horizontal: 6.h),
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
                  discountPrice,
                  style: theme.textTheme.labelMedium!.copyWith(
                    decoration: TextDecoration.lineThrough,
                    fontSize:
                        isDesktop ? 10.fSize : 9.fSize, // Reduced font size
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
            originalPrice,
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

  const _AddToCartButton({this.isDesktop = false});

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
        // Add your custom logic here
      },
    );
  }
}
