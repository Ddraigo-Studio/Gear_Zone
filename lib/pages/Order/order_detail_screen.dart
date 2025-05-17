import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/items/order_item.dart';
import '../../widgets/items/order_timeline_item.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/bottom_sheet/add_voucher_bottomsheet.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';

class OrdersDetailScreen extends StatelessWidget {
  const OrdersDetailScreen({super.key});

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
              padding: EdgeInsets.only(
                left: 16.h,
                top: 24.h,
                right: 16.h,
              ),
              child: Column(
                children: [
                  _buildOrderInformation(context),
                  SizedBox(height: 48.h),
                  _buildOrderList(context),
                  SizedBox(height: 48.h),
                  _buildPromoCode(context),
                  SizedBox(height: 16.h),
                  _buildPaymentInfo(context),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildReviewAndReturn(context),
    );
  }


  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 80.h,
      backgroundColor: Colors.white,
      centerTitle: true,
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
        text: "Thông tin đơn hàng",
        
      ),
    );
  }

  /// Section Widget
  Widget _buildOrderInformation(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 8.h,
      ),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Mã đơn hàng",
                  style: theme.textTheme.bodyMedium,
                ),
                Spacer(),
                Text(
                  "sgssahrhsvs",
                  style: theme.textTheme.bodyMedium,
                ),
                Container(
                  margin: EdgeInsets.only(left: 8.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.h,
                    vertical: 2.h,
                  ),
                  decoration: AppDecoration.outlineGray50001.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder8,
                  ),
                  child: Text(
                    "COPY",
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.labelLargeBaloo2Gray900,
                  ),
                ),

              ],
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 158.h,
                  child: Text(
                    "Phương thức thanh toán",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Text(
                  "Tiền mặt",
                  style: CustomTextStyles.bodyMedium13,
                )
              ],
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.maxFinite,
            child: Divider(
              color: appTheme.gray500.withValues(
                alpha: 0.9,
              ),
            ),
          ),
          SizedBox(height: 14.h),
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 12.h,
              );
            },
            itemCount: 3,
            itemBuilder: (context, index) {
              return OrderTimeLineItem();
            },
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildOrderList(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 16.h,
        );
      },
      itemCount: 2,
      itemBuilder: (context, index) {
        return OrderItem();
      },
    );
  }

  /// Section Widget
  Widget _buildPromoCode(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 8.h,
      ),
      decoration: AppDecoration.outlineBlack9004.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
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
                  imagePath: ImageConstant.imgIconsaxBrokenDiscountshape,
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
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.h),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return AddVoucherBottomsheet();
                      },
                    );
                  },
                  icon: CustomImageView(
                    imagePath: ImageConstant.imgArrowRight,
                  ),
                ),
              ],
            ),
          ),
          PromoItem(),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPaymentInfo(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 8.h,
        vertical: 6.h,
      ),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgReviewCheckmark,
                  height: 24.h,
                  width: 24.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.h),
                  child: Text(
                    "Chi tiết thanh toán",
                    style: CustomTextStyles.titleMediumBalooBhai2Gray700,
                  ),
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
              children: [
                Text(
                  "Tổng tiền hàng",
                  style: CustomTextStyles.bodyLargeGray50001,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Text(
                    "(3 món)",
                    style: CustomTextStyles.bodyLargeGray50001,
                  ),
                ),
                Spacer(),
                Text(
                  "\$8.00",
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: _buildInfoRow(
              context,
              uiphvnchuyOne: "Phí vận chuyển",
              priceThree: "\$8.00",
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: _buildInfoRow(
              context,
              uiphvnchuyOne: "Ưu đãi phí vận chuyển",
              priceThree: "\$8.00",
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: _buildInfoRow(
              context,
              uiphvnchuyOne: "Thuế",
              priceThree: "\$0.00",
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: _buildInfoRow(
              context,
              uiphvnchuyOne: "Voucher",
              priceThree: "- 8.000 đ",
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
            child: _buildInfoRow(
              context,
              uiphvnchuyOne: "Thành tiền:",
              priceThree: "17.390.000 đ",
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildReviewAndReturn(BuildContext context) {
    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(
        horizontal: 24.h,
        vertical: 20.h,
      ),
      decoration: AppDecoration.fillWhiteA,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomOutlinedButton(
            height: 38.h,
            width: 134.h,
            text: "Xem đánh giá",
            buttonStyle: CustomButtonStyles.outlinePrimary,
            buttonTextStyle: CustomTextStyles.bodyMediumDeeppurple400,
          ),
          CustomOutlinedButton(
            height: 38.h,
            width: 152.h,
            text: "Yêu cầu trả hàng",
            buttonStyle: CustomButtonStyles.outlineGrayTL10,
            buttonTextStyle: theme.textTheme.bodyMedium!,
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildInfoRow(
    BuildContext context, {
    required String uiphvnchuyOne,
    required String priceThree,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          uiphvnchuyOne,
          style: CustomTextStyles.bodyLargeGray900.copyWith(
            color: appTheme.gray900.withValues(
              alpha: 0.5,
            ),
          ),
        ),
        Text(
          priceThree,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: appTheme.gray900,
          ),
        ),
      ],
    );
  }

}

class PromoItem extends StatefulWidget {
  const PromoItem({
    super.key,
  });

  @override
  State<PromoItem> createState() => _PromoItemState();
}

class _PromoItemState extends State<PromoItem> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return SizedBox.shrink(); // Return an empty widget if not visible

    return Container(
      width: double.maxFinite,
      
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Divider(
              color: appTheme.gray500.withValues(
                alpha: 0.9,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 4.h, right: 10.h),
                child: CustomIconButton(
                  height: 34.h,
                  width: 34.h,
                  padding: EdgeInsets.all(6.h),
                  decoration: IconButtonStyleHelper.fillDeepPurpleTL16,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgDiscount,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Giảm 10%",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.titleMediumBalooBhai2Gray700.copyWith(
                        height: 1.60,
                      ),
                    ),
                    Row(
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
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isVisible = false; // Hide the widget when delete is pressed
                  });
                },
                icon: CustomImageView(
                  imagePath: ImageConstant.imgDelete,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}