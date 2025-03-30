import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_icon_button.dart';
import '../../widgets/Items/checkout_item.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray100,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Column(
                spacing: 22,
                children: [
                  SizedBox(height: 42.h),
                  _buildAddressSection(context),
                  _buildCartList(context),
                  _buildPaymentMethod(context),
                  _buildPromoCode(context),
                  _buildPaymentDetails(context)
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildPlaceOrderButton(context),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 64.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
        margin: EdgeInsets.only(
          left: 24.h,
          top: 10.h,
          bottom: 5.h,
        ),
      ),
      centerTitle: true,
      title: AppbarSubtitleOne(
        text: "Thanh toán",
      ),
    );
  }

  /// Section Widget
  Widget _buildAddressSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.h,
        vertical: 8.h,
      ),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      width: double.maxFinite,
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgMingcuteLocationLine,
            height: 24.h,
            width: 24.h,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Text(
                        "Nguyễn Văn A",
                        style: theme.textTheme.bodyLarge,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.h),
                        child: Text(
                          "093896356",
                          style: CustomTextStyles.bodyMediumGray900_1,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Đường 32/2 quận 10, TP. Hồ Chí Minh ",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.bodyMediumBlack900_1.copyWith(
                    height: 1.60,
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
                  height: 24.h,
                  width: 24.h,
                ),
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
            height: 24.h,
            width: 24.h,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildCartList(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 6.h,
      ),
      decoration: AppDecoration.fillWhiteA,
      child: Column(
        children: [
          Text(
            "Đơn hàng của bạn",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: CustomTextStyles.titleMediumBalooBhaijaan2Gray900.copyWith(
              height: 1.60,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.maxFinite,
            child: Divider(),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgImage33,
                  height: 42.h,
                  width: 64.h,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 222.h,
                        child: Text(
                          "Laptop ASUS Vivobook 14 OLED A1405VA KM095W",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyles.bodySmallBalooBhaiGray900
                              .copyWith(
                            height: 1.60,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Màu sắc: bạc",
                                    style:
                                        CustomTextStyles.labelMediumGray60001,
                                  ),
                                  Text(
                                    "Số lượng: 1",
                                    style:
                                        CustomTextStyles.labelMediumGray60001,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                spacing: 2,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "17.390.000đ",
                                    style: theme.textTheme.labelLarge,
                                  ),
                                  Text(
                                    "20.990.000đ",
                                    style:
                                        theme.textTheme.labelMedium!.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.maxFinite,
            child: Divider(),
          ),
          SizedBox(height: 10.h),
          ListView.builder(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, index) {
              return CheckoutItem();
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPaymentMethod(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.h,
        vertical: 8.h,
      ),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      width: double.maxFinite,
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgFluentPayment16Filled,
            height: 24.h,
            width: 24.h,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Phương thức thanh toán",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.bodyMediumBlack900_2.copyWith(
                    height: 1.60,
                  ),
                ),
                Text(
                  "Chưa chọn phương thức thanh toán",
                  style: CustomTextStyles.bodyMediumGray900_1,
                )
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
            height: 24.h,
            width: 24.h,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPromoCode(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 12.h,
      ),
      decoration: AppDecoration.outlineBlack9004.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Column(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath:
                      ImageConstant.imgIconsaxBrokenDiscountshapeGreen400,
                  height: 24.h,
                  width: 26.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Text(
                    "Mã giảm giá",
                    style: CustomTextStyles.titleMediumBalooBhai2Red500,
                  ),
                ),
                Spacer(),
                CustomImageView(
                  imagePath: ImageConstant.imgArrowRight,
                  height: 24.h,
                  width: 26.h,
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Divider(
              color: appTheme.gray500.withValues(
                alpha: 0.9,
              ),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: CustomIconButton(
                    height: 34.h,
                    width: 34.h,
                    padding: EdgeInsets.all(6.h),
                    decoration: IconButtonStyleHelper.fillGreen,
                    child: CustomImageView(
                      imagePath: ImageConstant.imgUser,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Giảm 10%",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyles.titleMediumBalooBhai2Gray700
                              .copyWith(
                            height: 1.60,
                          ),
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: Row(
                            children: [
                              Text(
                                "Đơn tối thiểu:",
                                style: CustomTextStyles.titleSmallInterGray700,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4.h),
                                child: Text(
                                  "1.000.000đ",
                                  style: CustomTextStyles.titleSmallInterRed500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgDelete,
                  height: 20.h,
                  width: 20.h,
                  margin: EdgeInsets.only(bottom: 12.h),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(10.h),
      decoration: AppDecoration.fillDeepPurpleF.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      child: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chi tiết thanh toán",
            style: CustomTextStyles.bodyLargeBlack900,
          ),
          SizedBox(
            width: double.maxFinite,
            child: _buildPriceInfo(
              context,
              title: "Tổng tiền hàng",
              price: "\$8.00",
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: _buildPriceInfo(
              context,
              title: "Tổng tiền phí vận chuyển",
              price: "\$8.00",
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: _buildPriceInfo(
              context,
              title: "Giảm giá phí vận chuyển",
              price: "\$8.00",
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: _buildPriceInfo(
              context,
              title: "Thuế",
              price: "\$0.00",
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: _buildPriceInfo(
              context,
              title: "Voucher",
              price: "- 8.000 đ",
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Divider(
              indent: 8.h,
              endIndent: 8.h,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tổng thanh toán",
                style: CustomTextStyles.bodyLargeGray900,
              ),
              Text(
                "3.000.000 VND",
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: appTheme.gray900,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPlaceOrderButton(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 24.h,
        vertical: 18.h,
      ),
      decoration: AppDecoration.fillWhiteA,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            height: 64.h,
            text: "Đặt hàng",
            buttonStyle: CustomButtonStyles.outlineBlackTL32,
            buttonTextStyle: theme.textTheme.titleLarge!,
          )
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildPriceInfo(
    BuildContext context, {
    required String title,
    required String price,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: CustomTextStyles.bodyLargeGray700.copyWith(
            color: appTheme.gray700,
          ),
        ),
        Text(
          price,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: appTheme.gray900,
          ),
        )
      ],
    );
  }
}
