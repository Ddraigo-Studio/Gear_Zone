import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class FilterCategoryItem extends StatelessWidget {
  final String category;  

  const FilterCategoryItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14.h,
        vertical: 6.h,
      ),
      decoration: AppDecoration.fillBlueGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder16,
      ),
      child: Text(
        category,  
        textAlign: TextAlign.center,
        style: theme.textTheme.titleSmall,
      ),
    );
  }
}
