import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class ListVoucherItem extends StatelessWidget {
  const ListVoucherItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 14.h,
      ),
      decoration: AppDecoration.row30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgFrame9217,
            height: 44.h,
            width: 44.h,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 22.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Giảm 10% ",
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
                        "1.000.000đ",
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
                            "16/12/2025",
                            style: CustomTextStyles.labelMediumInterDeeporange400,
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
                Text(
                  "Sử dụng",
                  style: CustomTextStyles.labelLargeInterRed400,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
