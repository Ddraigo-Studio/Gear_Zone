import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/cart_controller.dart';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/items/cart_item.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/custom_checkbox_button.dart';
import '../Checkout/checkout_screen.dart';
import '../../model/product.dart'; // Import for price formatting

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      backgroundColor: appTheme.gray10001,
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 120.h : 16.h, vertical: 24.h),
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
            if (cartController.items.isEmpty)
              _buildEmptyCartState(context)
            else
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
                          item.productId, item.color, selected);
                    },
                  );
                },
              )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCartState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 60.h),
          // Animated or decorative shopping cart icon
          Container(
            height: 120.h,
            width: 120.h,
            decoration: BoxDecoration(
              color: appTheme.deepPurpleA200.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 70.h,
              color: appTheme.deepPurpleA200,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            "Giỏ hàng của bạn đang trống",
            style: TextStyle(
              fontSize: 20.h,
              fontWeight: FontWeight.bold,
              color: appTheme.gray900,
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.h),
            child: Text(
              "Hãy thêm sản phẩm vào giỏ hàng để tiếp tục mua sắm",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.h,
                color: appTheme.gray600,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 32.h),
          Container(
            height: 50.h,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: appTheme.deepPurpleA200.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              icon: Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 24.h,
              ),
              label: Text(
                "Mua sắm ngay",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.h,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.deepPurpleA200,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.h),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 16.h),
                elevation:
                    0, // Remove default elevation since we're using custom shadow
              ),
              onPressed: () {
                Navigator.pop(
                    context); // Return to previous screen to continue shopping
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPaymentInfoSection(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    final selectedPrice = cartController.selectedItemsPrice;
      // Cập nhật giá trị theo yêu cầu
    final shippingFee = 30000.0;  // Phí vận chuyển cố định 30,000
    final taxRate = 0.02;  // Thuế 2% trên giá sản phẩm
    final tax = selectedPrice * taxRate;  // Tính thuế dựa trên giá sản phẩm đã chọn
    
    final totalPrice = selectedPrice + shippingFee + tax;

    // Không hiển thị thông tin thanh toán nếu không có sản phẩm nào được chọn
    if (cartController.selectedItemCount == 0) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 16.h,
      ),
      decoration: BoxDecoration(
        color: appTheme.deepPurple1003f, // Màu tím nhạt
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSummaryRow(
            title: "Tổng tiền sản phẩm",
            price: ProductModel.formatPrice(selectedPrice),
          ),
          SizedBox(height: 10.h),
          _buildSummaryRow(
            title: "Phí vận chuyển",
            price: ProductModel.formatPrice(shippingFee),
          ),
          SizedBox(height: 10.h),          _buildSummaryRow(
            title: "Thuế (2%)",
            price: ProductModel.formatPrice(tax),
          ),
          SizedBox(height: 10.h),
          Divider(color: appTheme.gray300),
          SizedBox(height: 10.h),
          _buildSummaryRow(
            title: "Tổng thanh toán",
            price: ProductModel.formatPrice(totalPrice),
            isTotal: true,
          ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }

  Widget _buildCheckoutRow(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    final bool isDesktop = Responsive.isDesktop(context);

    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 120.h : 24.h,
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
              cartController.selectAllItems(value);
            },
          ),
          Container(
            height: isDesktop ? 55.h : 48.h,
            width: isDesktop ? 150.h : 120.h,
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
              child: Center(
                child: Text(
                  "Thanh toán",
                  style: CustomTextStyles.bodyLargeBlack900
                      .copyWith(color: Colors.white),
                ),
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
    bool isDiscount = false,
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
              : isDiscount
                  ? CustomTextStyles.titleMediumBaloo2Gray500SemiBold.copyWith(
                      color: appTheme.green600,
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
              : isDiscount
                  ? CustomTextStyles.titleMediumBaloo2Gray500SemiBold
                      .copyWith(color: appTheme.green600)
                  : CustomTextStyles.titleMediumBaloo2Gray500SemiBold.copyWith(
                      color: appTheme.gray900,
                    ),
        ),
      ],
    );
  }
}
