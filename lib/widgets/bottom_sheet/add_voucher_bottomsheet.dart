import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/Items/voucher_item.dart';
import '../app_bar/appbar_leading_image.dart'; // ignore_for_file: must_be_immutable

class AddVoucherBottomsheet extends StatelessWidget {
  const AddVoucherBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 14.h,
      ),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.customBorderTL16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVoucherSelectionColumn(context),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.only(left: 4.h),
                      child: Text(
                        " Không khả dụng",
                        style: CustomTextStyles.titleMediumInterBluegray600,
                      ),
                    ),
                    SizedBox(height: 22.h),
                    _buildDiscountRow(context),
                    SizedBox(height: 12.h),
                    Text(
                      "Đơn hàng của bạn chưa đủ điều kiện áp dụng",
                      style: CustomTextStyles.titleSmallInterYellow900,
                    ),
                    SizedBox(height: 12.h),
                    _buildAdditionalDiscount(context),
                    SizedBox(height: 12.h),
                    Text(
                      "Đơn hàng của bạn chưa đủ điều kiện áp dụng",
                      style: CustomTextStyles.titleSmallInterYellow900,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 6.h),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildVoucherSelectionColumn(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 24,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chọn mã giảm giá",
                  style: CustomTextStyles.titleMediumInterBluegray600,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: AppbarLeadingImage(
                    imagePath: ImageConstant.imgX,
                    height: 20.h,
                    width: 20.h,
                  ),
                ),
                
              ],
            ),
          ),
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 10.h,
              );
            },
            itemCount: 3,
            itemBuilder: (context, index) {
              return ListVoucherItem();
            },
          )
        ],
      ),
    );
  }

  Widget _buildDiscountRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 10.h,
      ),
      decoration: AppDecoration.row30,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgDiscountPercentGrey,
            height: 25.h,
            width: 25.h,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 22.h),
              child: _buildDiscountDetails(
                context,
                discount: "Giảm 10% ",
                condition: "1.000.000đ",
                date: "16/12/2021",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.h),
            child: _buildUsageCondition(
              context
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalDiscount(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 10.h,
      ),
      decoration: AppDecoration.row30,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgDiscountPercentGrey,
            height: 25.h,
            width: 25.h,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 22.h),
              child: _buildDiscountDetails(
                context,
                discount: "Giảm 10% ",
                condition: "1.000.000đ",
                date: "16/12/2021",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.h),
            child: _buildUsageCondition(
              context
            ),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildUsageCondition(BuildContext context) {
    return Column(
      spacing: 26,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "Điều kiện",
          style: CustomTextStyles.labelLargeInterBlue300.copyWith(
            color: appTheme.blue300,
          ),
        ),
        Text(
          "Sử dụng",
          style: CustomTextStyles.labelLargeInterGray50001.copyWith(
            color: appTheme.gray50001,
          ),
        ),
      ],
    );
  }

  /// Common widget
  Widget _buildDiscountDetails(
    BuildContext context, {
    required String discount,
    required String condition,
    required String date,
  }) {
    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          discount,
          style: CustomTextStyles.labelLargeInterGray700.copyWith(
            color: appTheme.gray700,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Đơn tối thiểu',
              style: CustomTextStyles.bodyMediumInter.copyWith(
                color: appTheme.gray700,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.h),
              child: Text(
                condition,
                style: CustomTextStyles.bodyMediumInter.copyWith(
                  color: appTheme.gray700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: double.maxFinite,
          child: Row(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "HSD",
                  style: CustomTextStyles.labelMediumInter.copyWith(
                    color: appTheme.gray700,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.h),
                child: Text(
                  date,
                  style: CustomTextStyles.labelMediumInterGray50001.copyWith(
                    color: appTheme.gray50001,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

