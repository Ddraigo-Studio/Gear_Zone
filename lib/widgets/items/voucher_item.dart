import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/app_export.dart';
import '../../model/voucher.dart';

class ListVoucherItem extends StatelessWidget {
  final Voucher voucher;
  final VoidCallback? onTap;
  final bool isSelected;

  const ListVoucherItem({
    super.key,
    required this.voucher,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {    // Format discount amount to VND using the central formatter
    final discountText = FormatUtils.formatPrice(voucher.discountAmount);

    // Format expiry date (using createdAt + 30 days as example)
    final expiryDate = voucher.createdAt.add(const Duration(days: 30));
    final formattedExpiry = DateFormat('dd/MM/yyyy').format(expiryDate);

    // Minimum order amount (assumed to be 1,000,000đ for all vouchers)
    final minOrderAmount = "1.000.000đ";

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 14.h,
      ),
      decoration: AppDecoration.row30.copyWith(
        border:
            isSelected ? Border.all(color: appTheme.blue300, width: 2) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgDiscountPercentPur,
            height: 25.h,
            width: 25.h,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 22.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Giảm $discountText",
                    style: CustomTextStyles.labelLargeInterGray700,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Đơn tối thiểu:",
                        style: CustomTextStyles.labelLargeInterDeeppurple400,
                      ),
                      Text(
                        minOrderAmount,
                        style: CustomTextStyles.labelLargeInterGray700,
                      )
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
                            style: CustomTextStyles.labelMediumInter,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Text(
                            formattedExpiry,
                            style:
                                CustomTextStyles.labelMediumInterDeeporange400,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.h),
            child: Column(
              spacing: 22,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Điều kiện",
                  style: CustomTextStyles.labelLargeInterBlue300,
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Sử dụng",
                    style: CustomTextStyles.labelLargeInterRed400,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
