import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_button.dart';

class OrderTimeLineItem extends StatelessWidget {
  const OrderTimeLineItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIconButton(
          height: 24.h,
          width: 24.h,
          padding: EdgeInsets.all(6.h),
          decoration: IconButtonStyleHelper.fillPrimary,
          child: CustomImageView(
            imagePath: ImageConstant.imgCheckLine,
          ),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Text(
            "Thời gian đặt hàng",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.titleMediumBalooBhai2Gray700.copyWith(fontSize: 14.h),
          ),
        ),
        Text(
          "02-10-2024",
          style: CustomTextStyles.bodyMedium13,
        ),
        Padding(
          padding: EdgeInsets.only(left: 6.h),
          child: Text(
            " 12:14",
            style: CustomTextStyles.bodyMedium13,
          ),
        ),
      ],
    );
  }
}
