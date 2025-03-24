import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_button.dart';

class RecentlyViewedItem extends StatelessWidget {
  final int index;
  final String imagePath;
  final String productName;
  final String discountPrice;
  final String originalPrice;
  final String discountPercent;
  final String rating;

  const RecentlyViewedItem({
    super.key,
    required this.index,
    required this.imagePath,
    required this.productName,
    required this.discountPrice,
    required this.originalPrice,
    required this.discountPercent,
    required this.rating,
  });
 
  @override
  Widget build(BuildContext context) {
    final bgDecoration = index % 2 == 0
        ? AppDecoration.fillYellow.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder16,
          )
        : AppDecoration.fillPink.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder16,
          );
    return Container(
      width: 165.h,
      decoration: bgDecoration,
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
                ),
                SizedBox(height: 14.h),
                CustomImageView(
                  imagePath: imagePath,
                  height: 80.h,
                  width: 80.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 18.h),
                _ProductTitle(
                    title: productName), // Tái sử dụng widget cho tên sản phẩm
                SizedBox(height: 4.h),
                _ProductPrice(
                  originalPrice: originalPrice,
                  discountPrice: discountPrice,
                  discountPercent: discountPercent,
                ), // Tái sử dụng widget cho giá
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ProductRating(
                        rating: rating), // Tái sử dụng widget cho đánh giá
                    SizedBox(height: 4.h),
                    _AddToCartButton(),
                  ],
                ) // Tái sử dụng widget cho nút thêm vào giỏ hàng
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget cho tên sản phẩm
class _ProductTitle extends StatelessWidget {
  final String title;

  const _ProductTitle({super.key, required this.title});

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
    super.key,
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

  const _ProductRating({super.key, required this.rating});

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
    );
  }
}
