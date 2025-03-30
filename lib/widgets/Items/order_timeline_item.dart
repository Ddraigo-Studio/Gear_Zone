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
          padding: EdgeInsets.all(8.h),
          decoration: IconButtonStyleHelper.fillPrimary,
          child: CustomImageView(
            imagePath: ImageConstant.imgCheckLine,
          ),
        ),
        Container(
          width: 120.h,
          margin: EdgeInsets.only(left: 12.h),
          child: Text(
            "Thời gian đặt hàng",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Spacer(),
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
