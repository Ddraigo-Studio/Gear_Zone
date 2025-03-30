import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Spacer(),
              CustomImageView(
                imagePath: ImageConstant.imgImage3,
                height: 252.h,
                width: double.maxFinite,
                margin: EdgeInsets.symmetric(horizontal: 36.h),
              ),
              SizedBox(height: 72.h),
              _buildPaymentConfirmationSection(context)
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildPaymentConfirmationSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 24.h,
        vertical: 36.h,
      ),
      decoration: AppDecoration.outlineBlack9002.copyWith(
        borderRadius: BorderRadiusStyle.customBorderTL16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Thanh toán \nthành công",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineLarge,
          ),
          SizedBox(height: 18.h),
          Text(
            "Bạn sẽ nhận được mail xác nhận\nVui lòng kiểm tra lại hộp thư nhé.",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: CustomTextStyles.bodyLargeGray900,
          ),
          SizedBox(height: 46.h),
          CustomElevatedButton(
            height: 60.h,
            text: "Xem chi tiết đơn hàng",
            buttonStyle: CustomButtonStyles.outlineBlackTL321,
            buttonTextStyle: CustomTextStyles.bodyLargeWhiteA70018,
          ),
          SizedBox(height: 32.h)
        ],
      ),
    );
  }

}
