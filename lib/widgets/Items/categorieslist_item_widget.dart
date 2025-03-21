import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CategorieslistItemWidget extends StatelessWidget {
  const CategorieslistItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgEllipse1,
          height: 56.h,
          width: 56.h,
          radius: BorderRadius.circular(28.h),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.h),
          child: Text(
            "Laptop",
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.bodySmallBalooBhaiGray700,
          ),
        )
      ],
    );
  }
}
