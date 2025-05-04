import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/cart_controller.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/items/cart_item.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/custom_checkbox_button.dart';
import '../Checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      backgroundColor: appTheme.gray10001,
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 24.h),
        child: Column(
          children: [
            _buildCartListSection(context),
            // SizedBox(height: 16.h),
            // _buildPromoCodeSection(context),
            SizedBox(height: 16.h),
            _buildPaymentInfoSection(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildCheckoutRow(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 80.h,
      backgroundColor: Colors.white,
      centerTitle: true,
      shadowColor: Colors.black.withOpacity(0.4),
      elevation: 1,
      leading: IconButton(
        icon: AppbarLeadingImage(
          imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
          height: 25.h,
          width: 25.h,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: AppbarSubtitleTwo(
        text: "Giỏ hàng",
      ),
    );
  }

  Widget _buildCartListSection(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return SizedBox(height: 16.h);
              },
              itemCount: cartController.items.length,
              itemBuilder: (context, index) {
                final item = cartController.items[index];
                return CartItem(
                  productName: item.productName,
                  imagePath: item.imagePath,
                  color: item.color,
                  quantity: item.quantity,
                  discountedPrice: item.discountedPrice,
                  originalPrice: item.originalPrice,
                  isSelected: item.isSelected,
                  onQuantityChanged: (quantity) {
                    cartController.updateQuantity(
                      item.productId,
                      item.color,
                      quantity,
                    );
                  },
                  onDelete: () {
                    cartController.removeItem(item.productId, item.color);
                  },
                  onSelectionChanged: (selected) {
                    cartController.toggleItemSelection(
                      item.productId, 
                      item.color, 
                      selected
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfoSection(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    final selectedPrice = cartController.selectedItemsPrice;
    final shippingFee = 8000.0;
    final tax = 10000.0;
    final discount = 8000.0;
    final totalPrice = selectedPrice + shippingFee + tax - discount;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.h,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
            color: appTheme.deepPurple1003f, // Màu tím nhạt
            borderRadius: BorderRadius.circular(12.h),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 6.h,
        children: [
          _buildSummaryRow(
            title: "Phí vận chuyển",
            price: "${shippingFee.toInt()}đ",
          ),
          _buildSummaryRow(
            title: "Thuế",
            price: "${tax.toInt()}đ",
          ),
          Divider(),
          _buildSummaryRow(
            title: "Tổng",
            price: "${totalPrice.toInt()}đ",
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutRow(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    
    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(
        horizontal: 24.h,
        vertical: 14.h,
      ),
      decoration: AppDecoration.fillWhiteA,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomCheckboxButton(
            text: "Chọn tất cả",
            value: cartController.allItemsSelected,
            onChange: (value) {
              cartController.selectAllItems(value ?? false);
            },
          ),
          Container(
            height: 48.h,
            width: 120.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cartController.selectedItemCount > 0 
                    ? appTheme.deepPurpleA200 
                    : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.h),
                ),
              ),
              onPressed: cartController.selectedItemCount > 0 
                  ? () {
                      // Lấy danh sách các sản phẩm đã chọn
                      final selectedItems = cartController.getSelectedItems();
                      // Chuyển đến màn hình thanh toán với danh sách sản phẩm đã chọn
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(
                            selectedItems: selectedItems,
                          ),
                        ),
                      );
                    } 
                  : null,
              child: Text(
                "Thanh toán",
                style: CustomTextStyles.bodyLargeBlack900.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String title,
    required String price,
    bool isTotal = false,
    Color? priceColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isTotal
              ? CustomTextStyles.titleMediumBaloo2Gray500SemiBold.copyWith(
                  color: appTheme.red400,
                )
              : CustomTextStyles.titleMediumBaloo2Gray500SemiBold.copyWith(
                  color: appTheme.gray70001,
                ),
        ),
        Text(
          price,
          style: isTotal
              ? CustomTextStyles.titleMediumBaloo2Gray500SemiBold
                  .copyWith(color: appTheme.red400)
              : CustomTextStyles.titleMediumBaloo2Gray500SemiBold.copyWith(color: appTheme.gray900,),
        ),
      ],
    );
  }
}
