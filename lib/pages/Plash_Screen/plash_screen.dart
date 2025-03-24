import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class PlashScreenScreen extends StatelessWidget {
  const PlashScreenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.deepPurple500,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgEllipse2157,
                height: 1.h,
                width: 12.h,
                radius: BorderRadius.circular(0.5.h),
                onTap: () {
                  onTapImgProfileImage(context);
                },
              ),
              Spacer(
                flex: 48,
              ),
              CustomImageView(
                imagePath: ImageConstant.imgDragons1,
                height: 200.h,
                width: 202.h,
              ),
              Spacer(
                flex: 51,
              ),
            ],
          ),
        ),
      ),
    );
  }
  /// Navigates to the plasshcreenTwoScreen when the action is triggered.
  onTapImgProfileImage(BuildContext context){
      Navigator.pushNamed(context, AppRoutes.login);
    }

}

