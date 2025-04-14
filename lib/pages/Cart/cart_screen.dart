import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/cart_controller.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/Items/cart_item.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/custom_checkbox_button.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';

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
            SizedBox(height: 16.h),
            _buildPromoCodeSection(context),
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
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCodeSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.h,
        vertical: 6.h,
      ),
      decoration: AppDecoration.outlineGray50001.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgIconsaxBrokenDiscountshapeGreen400,
            height: 24.h,
            width: 26.h,
            margin: EdgeInsets.only(left: 6.h),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.h),
            child: Text(
              "Mã giảm giá",
              style: CustomTextStyles.bodyMediumRed500,
            ),
          ),
          Spacer(),
          CustomIconButton(
            height: 40.h,
            width: 40.h,
            padding: EdgeInsets.all(12.h),
            decoration: IconButtonStyleHelper.fillPrimaryTL20,
            child: CustomImageView(
              imagePath: ImageConstant.imgIconsaxBrokenArrowright2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfoSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.h,
        vertical: 10.h,
      ),
      decoration: AppDecoration.fillDeepPurpleF.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPriceRow(
            context,
            title: "Phí vận chuyển",
            price: "8.000đ",
          ),
          _buildPriceRow(
            context,
            title: "Thuế",
            price: "10.000đ",
          ),
          _buildPriceRow(
            context,
            title: "Voucher",
            price: "- 8.000đ",
          ),
          const Divider(),
          _buildPriceRow(
            context,
            title: "Tổng",
            price: "17.390.000đ",
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutRow(BuildContext context) {
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
            value: true,
            onChange: (value) {},
          ),
          CustomElevatedButton(
            height: 52.h,
            width: 152.h,
            text: "Thanh toán",
            buttonStyle: CustomButtonStyles.outlineBlackTL10,
            buttonTextStyle: theme.textTheme.titleLarge!,
          )
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    BuildContext context, {
    required String title,
    required String price,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isTotal 
              ? CustomTextStyles.bodyLargeBlack900
              : CustomTextStyles.bodyLargeGray700,
        ),
        Text(
          price,
          style: isTotal
              ? theme.textTheme.titleLarge!.copyWith(color: appTheme.gray900)
              : theme.textTheme.bodyLarge!.copyWith(color: appTheme.gray900),
        )
      ],
    );
  }
}
