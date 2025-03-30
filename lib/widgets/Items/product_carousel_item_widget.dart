import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../pages/Products/product_detail.dart';
import '../../widgets/custom_icon_button.dart';

class ProductCarouselItem extends StatelessWidget {
  final String imagePath;
  final String productName;
  final String discountPrice;
  final String originalPrice;
  final String discountPercent;
  final String rating;

  const ProductCarouselItem({
    super.key,
    required this.imagePath,
    required this.productName,
    required this.discountPrice,
    required this.originalPrice,
    required this.discountPercent,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailScreen()),
        );
      },
      child: Container(
        width: 165.h,
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
                    height: 30.h,
                    width: 30.h,
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
                  SizedBox(height: 14.h),
                  CustomImageView(
                    imagePath: imagePath,
                    height: 80.h,
                    width: 80.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 18.h),
                  _ProductTitle(title: productName), // tên sản phẩm
                  SizedBox(height: 4.h),
                  _ProductPrice(
                    originalPrice: originalPrice,
                    discountPrice: discountPrice,
                    discountPercent: discountPercent,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ProductRating(rating: rating),
                      SizedBox(height: 4.h),
                      _AddToCartButton(),
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

  const _ProductTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 6.h),
        child: Text(
          title,
          style: theme.textTheme.bodySmall,
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

  const _ProductPrice({
    required this.originalPrice,
    required this.discountPrice,
    required this.discountPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.h,
                    vertical: 3.h,
                  ),
                  decoration: AppDecoration.outlineRed.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder8,
                  ),
                  child: RotationTransition(
                    turns: AlwaysStoppedAnimation(0),
                    child: Text(
                      discountPercent.toUpperCase(),
                      textAlign: TextAlign.left,
                      style: CustomTextStyles.labelMediumInterRed500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            originalPrice,
            style: theme.textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

// Widget cho đánh giá sản phẩm
class _ProductRating extends StatelessWidget {
  final String rating;

  const _ProductRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgDefaultIcon,
          height: 29.h,
          width: 20.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 4.h),
          child: Text(
            rating,
            style: CustomTextStyles.bodySmallEncodeSansGray90001,
          ),
        ),
      ],
    );
  }
}

// Widget cho nút "Thêm vào giỏ hàng"
class _AddToCartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      height: 30.h,
      width: 30.h,
      padding: EdgeInsets.all(4.h),
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
