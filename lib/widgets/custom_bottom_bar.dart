// ignore_for_file: duplicate_ignore

import 'package:flutter/material.dart';
import '../../core/app_export.dart';

enum BottomBarEnum { Frame50, Frame54, Frame52, Frame53 }

// ignore_for_file: must_be_immutable
class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({super.key, this.onChanged});

  Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

// ignore_for_file: must_be_immutable
class CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.imgFrame50,
      activeIcon: ImageConstant.imgFrame50,
      type: BottomBarEnum.Frame50,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgFrame54,
      activeIcon: ImageConstant.imgFrame54,
      type: BottomBarEnum.Frame54,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgFrame52,
      activeIcon: ImageConstant.imgFrame52,
      type: BottomBarEnum.Frame52,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgFrame53,
      activeIcon: ImageConstant.imgFrame53,
      type: BottomBarEnum.Frame53,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.whiteA700,
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
          return BottomNavigationBarItem(
            icon: CustomImageView(
              imagePath: bottomMenuList[index].icon,
              height: 40.h,
              width: 42.h,
              color: appTheme.gray900,
              radius: BorderRadius.circular(20.h),
            ),
            activeIcon: CustomImageView(
              imagePath: bottomMenuList[index].activeIcon,
              height: 40.h,
              width: 42.h,
              color: theme.colorScheme.primary,
            ),
            label: '',
          );
        }),
        onTap: (index) {
          selectedIndex = index;
          widget.onChanged?.call(bottomMenuList[index].type);
          setState(() {});
        },
      ),
    );
  }
}

// ignore_for_file: must_be_immutable2
class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    required this.type,
  });

  String icon;
  String activeIcon;
  BottomBarEnum type;
}

class DefaultWidget extends StatelessWidget {
  const DefaultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffffffff),
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
