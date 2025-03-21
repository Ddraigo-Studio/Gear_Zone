import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CategoriesgridItemWidget extends StatelessWidget {
  const CategoriesgridItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: AppDecoration.shadow.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder16,
      ),
      child: Column(
        spacing: 14,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgImage178x158,
            height: 178.h,
            width: double.maxFinite,
            radius: BorderRadius.circular(16.h),
          ),
          Text(
            "Laptop",
            style: CustomTextStyles.bodyLargeFredokaBluegray900,
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
