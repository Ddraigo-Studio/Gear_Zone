import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';

class ProductVariantBottomsheet extends StatefulWidget {
  final Function(String, int)? onAddToCart;

  const ProductVariantBottomsheet({
    Key? key,
    this.onAddToCart,
  }) : super(key: key);

  @override
  State<ProductVariantBottomsheet> createState() => _ProductVariantBottomsheetState();
}

class _ProductVariantBottomsheetState extends State<ProductVariantBottomsheet> {
  int quantity = 1;
  String selectedColor = "Đỏ"; // Default color
  
  // List of available colors
  final List<Map<String, dynamic>> colorOptions = [
    {"name": "Đỏ", "color": Colors.red},
    {"name": "Xanh", "color": Colors.blue},
    {"name": "Xanh lá", "color": Colors.green},
  ];

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
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 16.h,
          children: List.generate(
            colorOptions.length,  
            (index) {
              final option = colorOptions[index];
              final isSelected = selectedColor == option["name"];
              return _ProductVariantOptionsItem(
                option["color"], 
                option["name"],
                isSelected,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _ProductVariantOptionsItem(Color color, String colorName, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedColor = colorName;
        });
      },
      child: Container(
        height: 30.h,
        width: 30.h,
        decoration: BoxDecoration(
          color: color, // Set the background color
          borderRadius: BorderRadius.circular(14.h),
          border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
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
          "Chọn số lượng: $quantity",
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
                    setState(() {
                      if (quantity > 1) {
                        quantity--;
                      }
                    });
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
                          imagePath: ImageConstant.imgIconsaxBrokenMinus,
                          height: 20.h,
                          width: 20.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.h),
                child: Text(
                  "$quantity", 
                  style: CustomTextStyles.labelLargeInterDeeppurple500,
                ),
              ),
              Container(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      quantity++;
                    });
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
                          imagePath: ImageConstant.imgIconsaxBrokenAdd,
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
              onPressed: () {
                // Call the onAddToCart callback with selected values
                if (widget.onAddToCart != null) {
                  widget.onAddToCart!(selectedColor, quantity);
                }
              },
            ),
          ),
          Expanded(
            child: CustomElevatedButton(
              alignment: Alignment.center,
              height: 52.h,
              text: "Mua ngay",
              buttonStyle: CustomButtonStyles.outlineBlackTL263,
              buttonTextStyle: CustomTextStyles.bodyLargeBalooBhaijaanWhiteA700,
              onPressed: () {
                // Call the onAddToCart callback with selected values and then navigate to checkout
                if (widget.onAddToCart != null) {
                  widget.onAddToCart!(selectedColor, quantity);
                  
                  // Close the bottom sheet
                  Navigator.pop(context);
                  
                  // Navigate to checkout screen
                  Navigator.pushNamed(context, AppRoutes.checkoutScreen);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

}
