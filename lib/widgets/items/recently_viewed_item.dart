import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_button.dart';
import '../../core/utils/responsive.dart';
import '../../model/product.dart';

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
        print('Tapped on ${product.name}');
      },
      child: Container(
        width: itemWidth,
        height: isDesktop
            ? 240.h
            : 220.h, // Thêm chiều cao cố định để tránh overflow
        decoration: bgDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.all(isDesktop ? 8.h : 6.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
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
                  SizedBox(height: isDesktop ? 10.h : 8.h), // Reduced space
                  CustomImageView(
                    imagePath: product.imageUrl.isEmpty
                        ? ImageConstant.imgImage1
                        : product.imageUrl,
                    height: isDesktop
                        ? 90.h
                        : isTablet
                            ? 85.h
                            : 80.h,
                    width: isDesktop
                        ? 90.h
                        : isTablet
                            ? 85.h
                            : 80.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: isDesktop ? 10.h : 8.h), // Reduced space
                  _ProductTitle(title: product.name, isDesktop: isDesktop),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _ProductRating(
                          rating: "4.5",
                          isDesktop: isDesktop), // Hardcoded rating for now
                      _AddToCartButton(isDesktop: isDesktop),
                    ],
                  )
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
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall!.copyWith(
            fontSize: isDesktop ? 12.fSize : 11.fSize,
          ),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  discountPrice,
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
          Text(
            originalPrice,
            style: theme.textTheme.labelLarge!.copyWith(
              fontSize: isDesktop ? 12.fSize : 11.fSize,
            ),
            overflow: TextOverflow.ellipsis,
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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgDefaultIcon,
          height: isDesktop ? 20.h : 18.h, // Reduced height
          width: isDesktop ? 14.h : 12.h, // Reduced width
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
        // Add your custom logic here
      },
    );
  }
}
