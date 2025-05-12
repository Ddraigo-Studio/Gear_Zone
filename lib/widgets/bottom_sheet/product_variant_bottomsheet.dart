import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';

class ProductVariantBottomsheet extends StatefulWidget {
  final Function(String, int)? onAddToCart;
  final String? initialSelectedColor;
  final List<Map<String, dynamic>>? availableColors;
  final String? productName;
  final String? productImage;
  final String? productPrice;
  final String? productOriginalPrice;
  final String? productStock;

  const ProductVariantBottomsheet({
    Key? key,
    this.onAddToCart,
    this.initialSelectedColor,
    this.availableColors,
    this.productName,
    this.productImage,
    this.productPrice,
    this.productOriginalPrice,
    this.productStock,
  }) : super(key: key);

  @override
  State<ProductVariantBottomsheet> createState() => _ProductVariantBottomsheetState();
}

class _ProductVariantBottomsheetState extends State<ProductVariantBottomsheet> {
  int quantity = 1;
  late String selectedColor;
  late List<Map<String, dynamic>> colorOptions;
  @override
  void initState() {
    super.initState();
    // Initialize with provided color or empty string
    selectedColor = widget.initialSelectedColor ?? "";
    
    // Initialize with provided color options or empty list
    colorOptions = widget.availableColors ?? [];
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 500.h,
      padding: EdgeInsets.symmetric(
        horizontal: 20.h,
        vertical: 24.h,
      ),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.customBorderTL201,
      ),      
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Text(
            "Chọn phân loại",
            textAlign: TextAlign.center,
            style: CustomTextStyles.titleLargeRobotoBluegray90001,
          ),
          SizedBox(height: 16.h), // Added spacing
          Divider(thickness: 0.5,),
          SizedBox(height: 16.h), // Added spacing
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCartItem(context),
                  SizedBox(height: 16.h), // Added spacing          
                  // Chỉ hiển thị phần màu sắc nếu có màu sắc thực sự để chọn (không phải màu mặc định)
                  if (colorOptions.isNotEmpty && colorOptions.length > 0 && colorOptions[0]["name"] != "Default") ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Màu sắc:",
                          style: theme.textTheme.titleMedium,
                        ),
                        SizedBox(width: 10.h),
                        _buildProductVariantOptions(context),
                      ],
                      
                    ),                    
                    SizedBox(height: 16.h), // Added spacing
                    Divider(thickness: 0.3,),    
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h), // Added spacing
          Divider(thickness: 0.3,),  
          SizedBox(height: 16.h), // Added spacing
          _buildActionButtons(context),
        ],
      ),
    );
  }  Widget _buildCartItem(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.h),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      width: double.infinity,
      child: Row(
        spacing: 16.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
            imagePath: widget.productImage ?? ImageConstant.imgLogo,
            height: 64.h,
            width: 64.h,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productName ?? "Lỗi không tìm thấy tên sản phẩm",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.titleMediumBalooBhai2Gray900
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
                          widget.productStock ?? "",
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
                                widget.productPrice ?? "17.390.000đ",
                                style:
                                    CustomTextStyles.titleSmallGabaritoRed500,
                              ),
                              if (widget.productOriginalPrice != null && widget.productOriginalPrice!.isNotEmpty)
                                Text(
                                  widget.productOriginalPrice!,
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
  }  Widget _buildProductVariantOptions(BuildContext context) {
    // Safety check - if colorOptions is empty, return an empty container
    if (colorOptions.isEmpty) {
      return Expanded(child: Container());
    }
    
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            colorOptions.length,  
            (index) {
              final option = colorOptions[index];
              final isSelected = selectedColor == option["name"];
              return Padding(
                padding: EdgeInsets.only(right: 16.h),
                child: _productVariantOptionsItem(
                  option["color"] ?? Colors.grey, 
                  option["name"] ?? "Default",
                  isSelected,
                ),
              );
            },
          ),
        ),
      ),
    );
  }  Widget _productVariantOptionsItem(Color color, String colorName, bool isSelected) {
    return Tooltip(
      message: colorName,
      preferBelow: false,
      verticalOffset: 16,
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
      textStyle: TextStyle(fontSize: 12.fSize, color: Colors.white),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.h),
        onTap: () {
          setState(() {
            selectedColor = colorName;
          });
        },
        child: Container(
          height: 30.h,
          width: 30.h,
          decoration: BoxDecoration(
            color: color,
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
              height: Responsive.isDesktop(context) ? 48.h : 40.h, // Make consistent with "Mua ngay" button
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
          SizedBox(width: 10.h), // Add spacing between buttons
          Expanded(            child: CustomElevatedButton(
              alignment: Alignment.center,
              height: Responsive.isDesktop(context) ? 48.h : 40.h,
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
