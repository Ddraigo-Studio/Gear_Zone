import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/color_utils.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../controller/cart_controller.dart';
import '../../model/cart_item.dart';

class ProductVariantBottomsheet extends StatefulWidget {  final Function(String, int)? onAddToCart;
  final String? initialSelectedColor;
  final List<Map<String, dynamic>>? availableColors;
  final String? productName;
  final String? productImage;
  final String? productPrice;
  final String? productOriginalPrice;
  final String? productStock;
  final String productId;
  const ProductVariantBottomsheet({
    super.key,
    this.onAddToCart,
    this.initialSelectedColor,
    this.availableColors,
    this.productName,
    this.productImage,
    this.productPrice,
    this.productOriginalPrice,
    this.productStock,
    required this.productId,
  });

  @override
  State<ProductVariantBottomsheet> createState() => _ProductVariantBottomsheetState();
}

class _ProductVariantBottomsheetState extends State<ProductVariantBottomsheet> {
  int quantity = 1;
  late String selectedColor;
  late List<Map<String, dynamic>> colorOptions;
    // Helper function để xác định nên sử dụng dấu check màu trắng trên màu tối
  bool _shouldUseWhiteCheckmark(Color color) {
    // Sử dụng phương thức tiện ích từ ColorUtils
    return ColorUtils.shouldUseWhiteText(color);
  }
  
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
                  if (colorOptions.isNotEmpty && colorOptions[0]["name"] != "Default") ...[
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
      verticalOffset: 20,
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
            border: Border.all(
              color: isSelected ? Colors.black : Colors.transparent,
              width: isSelected ? 2 : 0,
            ),
            boxShadow: [
              BoxShadow(
                color: appTheme.black900.withOpacity(0.25),
                spreadRadius: 1.h,
                blurRadius: 1.h,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: isSelected
            ? Center(
                child: Icon(
                  Icons.check,
                  color: _shouldUseWhiteCheckmark(color) ? Colors.white : Colors.black,
                  size: 18.h,
                ),
              )
            : null,
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
    final bool isDesktop = Responsive.isDesktop(context);
    
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [          
          Expanded(            child: CustomOutlinedButton(
              alignment: Alignment.center,
              height: isDesktop ? 50.h : 52.h,
              text: "Thêm vào giỏ",
              buttonStyle: CustomButtonStyles.outlinePrimaryTL26,
              buttonTextStyle: CustomTextStyles.bodyLargeBalooBhaijaanDeeppurple40018,
              onPressed: () {
                // Lấy instance của CartController
                final cartController = CartController();
                
                // Tạo CartItem mới từ thông tin sản phẩm
                final cartItem = CartItem(
                  productId: widget.productId,
                  imagePath: widget.productImage ?? '',
                  productName: widget.productName ?? 'Sản phẩm không tên',
                  color: selectedColor,
                  quantity: quantity,
                  originalPrice: double.tryParse(widget.productOriginalPrice?.replaceAll('.', '').replaceAll('đ', '').replaceAll(',', '') ?? '0') ?? 0,
                  discountedPrice: double.tryParse(widget.productPrice?.replaceAll('.', '').replaceAll('đ', '').replaceAll(',', '') ?? '0') ?? 0,
                );
                
                // Thêm vào giỏ hàng
                cartController.addItem(cartItem);
                  // Thông báo cho người dùng
                String message = 'Đã thêm $quantity sản phẩm vào giỏ hàng';
                  
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'XEM GIỎ HÀNG',                     
                      onPressed: () {
                        Navigator.pop(context); // Đóng bottom sheet
                        Navigator.pushNamed(context, AppRoutes.myCartScreen);
                      },
                    ),
                  ),
                );
                
                // Vẫn gọi callback nếu có
                if (widget.onAddToCart != null) {
                  widget.onAddToCart!(selectedColor, quantity);
                }
                
                // Đóng bottom sheet sau khi thêm vào giỏ
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(width: 10.h), // Add spacing between buttons
          Expanded(
            child: Container(
              height: isDesktop ? 50.h : 52.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.deepPurpleA200,                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26.h),
                  ),
                  padding: EdgeInsets.zero,
                ),                onPressed: () {
                  // Lấy instance của CartController
                  final cartController = CartController();
                  
                  // Tạo CartItem mới từ thông tin sản phẩm
                  final cartItem = CartItem(
                    productId: widget.productId,
                    imagePath: widget.productImage ?? '',
                    productName: widget.productName ?? 'Sản phẩm không tên',
                    color: selectedColor,
                    quantity: quantity,
                    originalPrice: double.tryParse(widget.productOriginalPrice?.replaceAll('.', '').replaceAll('đ', '').replaceAll(',', '') ?? '0') ?? 0,
                    discountedPrice: double.tryParse(widget.productPrice?.replaceAll('.', '').replaceAll('đ', '').replaceAll(',', '') ?? '0') ?? 0,
                  );
                  
                  // Thêm vào giỏ hàng
                  cartController.addItem(cartItem);
                  
                  // Gọi callback nếu có
                  if (widget.onAddToCart != null) {
                    widget.onAddToCart!(selectedColor, quantity);
                  }
                  
                  // Đóng bottom sheet
                  Navigator.pop(context);
                  
                  // Chuyển đến màn hình thanh toán
                  Navigator.pushNamed(context, AppRoutes.checkoutScreen);
                },
                child: Center(
                  child: Text(
                    "Mua ngay",
                    style: CustomTextStyles.bodyLargeBalooBhaijaanWhiteA700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
