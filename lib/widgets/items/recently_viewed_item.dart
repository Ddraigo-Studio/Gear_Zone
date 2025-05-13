import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_button.dart';
import '../../core/utils/responsive.dart';
import '../../model/product.dart';
import '../../pages/Products/product_detail.dart';

class WishListItem extends StatelessWidget {
  final int index;
  final ProductModel product;

  const WishListItem({
    super.key,
    required this.index,
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

    // Adjust item width based on device type
    final double itemWidth = isDesktop
        ? 180.h // Larger width for desktop
        : isTablet
            ? 170.h // Medium width for tablet
            : 165.h; // Original width for mobile

    final bgDecoration = index % 2 == 0
        ? AppDecoration.fillYellow.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder16,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(0, 2),
                blurRadius: 2,
              ),
            ],
          )
        : AppDecoration.fillPink.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder16,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(0, 2),
                blurRadius: 1,
              ),
            ],
          );
    
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
        height: isDesktop ? 240.h : 220.h,
        decoration: bgDecoration,
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? 8.h : 6.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heart button aligned to the right
              Align(
                alignment: Alignment.topRight,
                child: CustomIconButton(
                  height: isDesktop ? 34.h : 30.h,
                  width: isDesktop ? 34.h : 30.h,
                  padding: EdgeInsets.all(6.h),
                  decoration: IconButtonStyleHelper.none,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgHeartIconlyPro,
                  ),
                  onTap: () {
                    // Wishlist logic
                  },
                ),
              ),
              
              // Product image centered
              Align(
                alignment: Alignment.center,
                child: CustomImageView(
                  imagePath: product.imageUrl.isEmpty
                      ? ImageConstant.imgImage1
                      : product.imageUrl,
                  height: isDesktop ? 80.h : 70.h,
                  width: isDesktop ? 80.h : 70.h,
                  fit: BoxFit.contain,
                ),
              ),
              
              // Spacer to push remaining content to the bottom
              SizedBox(height: 8.h),
              
              // Fixed height container for product title (2 lines max)
              Container(
                height: isDesktop ? 36.h : 32.h,
                alignment: Alignment.topLeft,
                child: Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: isDesktop ? 12.fSize : 11.fSize,
                  ),
                ),
              ),
              
              // Price section
              Container(
                margin: EdgeInsets.only(top: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        formattedOriginalPrice,
                        style: theme.textTheme.labelMedium!.copyWith(
                          decoration: TextDecoration.lineThrough,
                          fontSize: isDesktop ? 11.fSize : 10.fSize,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.h,
                        vertical: 2.h,
                      ),
                      decoration: AppDecoration.outlineRed.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder8,
                      ),
                      child: Text(
                        discountPercent.toUpperCase(),
                        textAlign: TextAlign.left,
                        style: CustomTextStyles.labelMediumInterRed500.copyWith(
                          fontSize: isDesktop ? 10.fSize : 9.fSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Discount price
              Container(
                margin: EdgeInsets.only(top: 2.h),
                child: Text(
                  formattedPrice,
                  style: theme.textTheme.labelLarge!.copyWith(
                    fontSize: isDesktop ? 12.fSize : 11.fSize,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              // Bottom row with rating and cart button
              Spacer(), // Push to bottom of available space
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _ProductRating(
                    rating: "4.5",
                    isDesktop: isDesktop,
                  ),
                  _AddToCartButton(isDesktop: isDesktop),
                ],
              ),
            ],
          ),
        ),
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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgDefaultIcon,
          height: isDesktop ? 18.h : 16.h,
          width: isDesktop ? 12.h : 10.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 2.h),
          child: Text(
            rating,
            style: CustomTextStyles.bodySmallEncodeSansGray90001.copyWith(
              fontSize: isDesktop ? 10.fSize : 9.fSize,
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
      height: isDesktop ? 32.h : 28.h,
      width: isDesktop ? 32.h : 28.h,
      padding: EdgeInsets.all(isDesktop ? 5.h : 4.h),
      decoration: IconButtonStyleHelper.fillDeepPurple,
      child: CustomImageView(
        imagePath: ImageConstant.imgIconsaxBrokenBag2Gray100,
        height: isDesktop ? 18.h : 16.h,
        width: isDesktop ? 18.h : 16.h,
      ),
      onTap: () {
        // Add to cart logic
      },
    );
  }
}
