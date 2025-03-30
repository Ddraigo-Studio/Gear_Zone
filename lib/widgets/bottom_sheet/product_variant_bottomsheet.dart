import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';

class ProductVariantBottomsheet extends StatelessWidget {
  const ProductVariantBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20.h,
        vertical: 24.h,
      ),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.customBorderTL201,
      ),
      child: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Chọn phân loại",
            style: CustomTextStyles.titleLargeRobotoBluegray90001,
          ),
          Divider(),
          _buildCartItem(context),
          Divider(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Màu sắc",
              style: theme.textTheme.titleMedium,
            ),
          ),
          _buildProductVariantOptions(context),
          Divider(),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context) {
    return Container(
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      width: double.infinity,
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgImage33,
            height: 42.h,
            width: 64.h,
          ),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Laptop ASUS Vivobook 14 OLED A1405VA KM095W",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.titleMediumBalooBhai2Gray900.copyWith(
                    height: 1.60,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Kho: ",
                        style: CustomTextStyles.labelLargeGray60001,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.h),
                        child: Text(
                          "200",
                          style: CustomTextStyles.labelLargePrimary,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "17.390.000đ",
                                style:
                                    CustomTextStyles.titleSmallGabaritoRed500,
                              ),
                              Text(
                                "20.990.000đ",
                                style: CustomTextStyles.labelMedium11.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: _buidQuantityButton(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductVariantOptions(BuildContext context) {
  // List of colors you want to display for the options
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
  ];

  return Container(
    width: double.infinity,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 16.h,
        children: List.generate(
          colors.length,  
          (index) {
            return _ProductVariantOptionsItem(colors[index]);
          },
        ),
      ),
    ),
  );
}

  Widget _ProductVariantOptionsItem(Color color) {
    return InkWell(
      onTap: () {
        
        print("Selected color: $color");
      },
      child: Container(
        height: 30.h,
        width: 30.h,
        decoration: BoxDecoration(
          color: color, // Set the background color
          borderRadius: BorderRadius.circular(14.h),
          boxShadow: [
            BoxShadow(
              color: appTheme.black900.withValues(alpha: 0.25),
              spreadRadius: 1.h,
              blurRadius: 1.h,
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buidQuantityButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          "Chọn số lượng: 1",
          style: CustomTextStyles.labelLargeGray60001,
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: InkWell(
                  onTap: () {
                    // Handle the decrement action here
                  },
                  child: Container(
                    height: 30.h,
                    width: 30.h,
                    decoration: AppDecoration.fillPrimary.copyWith(
                      borderRadius: BorderRadiusStyle.circleBorder20,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant
                              .imgIconsaxBrokenMinus, // Path for the minus icon
                          height: 20.h,
                          width: 20.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10.h), // Add some space between minus and plus
                child: Text(
                  "1", 
                  style: CustomTextStyles.labelLargeInterDeeppurple500,
                ),
              ),
              Container(
                child: InkWell(
                  onTap: () {
                    // Handle the increment action here
                  },
                  child: Container(
                    height: 30.h,
                    width: 30.h,
                    decoration: AppDecoration.fillPrimary.copyWith(
                      borderRadius: BorderRadiusStyle.circleBorder20,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant
                              .imgIconsaxBrokenAdd, // Path for the plus icon
                          height: 20.h,
                          width: 20.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        spacing: 30.h,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomOutlinedButton(
              alignment: Alignment.center,
              height: 52.h,
              text: "Thêm vào giỏ",
              buttonStyle: CustomButtonStyles.outlinePrimaryTL26,
              buttonTextStyle: CustomTextStyles.bodyLargeBalooBhaijaanDeeppurple40018,
            ),
          ),
          Expanded(
            child: CustomElevatedButton(
              alignment: Alignment.center,
              height: 52.h,
              text: "Mua ngay",
              buttonStyle: CustomButtonStyles.outlineBlackTL263,
              buttonTextStyle: CustomTextStyles.bodyLargeBalooBhaijaanWhiteA700,
            ),
          ),
        ],
      ),
    );
  }

}
