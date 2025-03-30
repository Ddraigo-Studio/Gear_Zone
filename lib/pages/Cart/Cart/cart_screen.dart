import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/Items/cart_item.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/custom_checkbox_button.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';

// ignore_for_file: must_be_immutable
class MyCartScreen extends StatelessWidget {
  MyCartScreen({super.key});

  bool chnttccone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(
                  left: 16.h,
                  top: 24.h,
                  right: 16.h,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 2.h),
                    _buildCartListSection(context),
                    SizedBox(height: 76.h),
                    _buildPromoCodeSection(context),
                    SizedBox(height: 10.h),
                    _buildPaymentInfoSection(context)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildCheckoutRow(context),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 2,
      toolbarHeight: 80.h,
      backgroundColor: appTheme.whiteA700,
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
      centerTitle: true,
      title: AppbarSubtitleOne(
        text: "Giỏ hàng",
      ),
    );
  }

  /// Section Widget
  Widget _buildCartListSection(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Sữa",
            style: theme.textTheme.bodyLarge,
          ),
          ListView.separated(
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
              return CartItem();
            },
          )

        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPromoCodeSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      padding: EdgeInsets.symmetric(
        horizontal: 8.h,
        vertical: 6.h,
      ),
      decoration: AppDecoration.outlineGray50001.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgIconsaxBrokenDiscountshapeGreen400,
            height: 24.h,
            width: 26.h,
            margin: EdgeInsets.only(left: 6.h),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: 12.h,
                bottom: 6.h,
              ),
              child: Text(
                "Mã giảm giá",
                style: CustomTextStyles.bodyMediumRed500,
              ),
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

  /// Section Widget
  Widget _buildPaymentInfoSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      padding: EdgeInsets.symmetric(
        horizontal: 8.h,
        vertical: 10.h,
      ),
      decoration: AppDecoration.fillDeepPurpleF.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      child: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: _buildContentRow(
              context,
              title: "Phí vận chuyển",
              info: "2020.000 đ",
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: _buildContentRow(
              context,
              title: "Thuế",
              info: "10.000 đ",
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: _buildContentRow(
              context,
              title: "Voucher",
              info: "- 8.000 đ",
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: _buildContentRow(
              context,
              title: "Tổng",
              info: "17.390.000 đ",
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildCheckoutRow(BuildContext context) {
    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(
        horizontal: 24.h,
        vertical: 14.h,
      ),
      decoration: AppDecoration.fillWhiteA,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.h),
            child: CustomCheckboxButton(
              text: "Chọn tất cả",
              // value: chnttcone,
              onChange: (value) {
                // chnttcone = value;
              },
            ),
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

  /// Common widget
  Widget _buildContentRow(
    BuildContext context, {
    required String title,
    required String info,
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
          info,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: appTheme.gray900,
          ),
        ),
      ],
    );
  }


}
