import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CategoriesGridItem extends StatelessWidget {
  const CategoriesGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 10.h,
        right: 10.h,
        bottom: 8.h,
        top: 8.h,
      ),
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
