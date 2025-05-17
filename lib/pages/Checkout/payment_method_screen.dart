import 'package:flutter/material.dart';
import '../../controller/checkout_controller.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int _selectedMethodIndex = -1; // Mặc định không chọn phương thức nào
  late CheckoutController _checkoutController;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'title': 'Thẻ nội địa Napas',
      'subtitle': '**** 4187',
      'icon': ImageConstant.imgNapas,
    },
    {
      'title': 'Thanh toán ví Momo',
      'subtitle': '',
      'icon': ImageConstant.imgArcticonsMomo,
    },
    {
      'title': 'Thanh toán khi nhận hàng',
      'subtitle': '',
      'icon': ImageConstant.imgTdesignMoney,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Get the singleton instance of CheckoutController
    _checkoutController = CheckoutController();
    // Set the initially selected payment method from the controller
    _selectedMethodIndex = _checkoutController.paymentMethodIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(
                    left: 16.h,
                    top: 40.h,
                    right: 16.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [_buildPaymentMethodsList(context)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildConfirmationButton(context),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 88.h,
      leadingWidth: 64.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
        margin: EdgeInsets.only(
          left: 24.h,
          top: 24.h,
          bottom: 23.h,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Phương thức thanh toán",
        margin: EdgeInsets.only(left: 16.h, right: 16.h),
      ),
      styleType: Style.bgShadowBlack900_1,
    );
  }

  /// Section Widget
  Widget _buildPaymentMethodsList(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: List.generate(_paymentMethods.length, (index) {
          final method = _paymentMethods[index];
          final bool isSelected = _selectedMethodIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedMethodIndex = index;
              });
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? appTheme.deepPurpleA200.withOpacity(0.1)
                    : appTheme.gray100,
                borderRadius: BorderRadius.circular(8.h),
                border: isSelected
                    ? Border.all(color: appTheme.deepPurpleA200, width: 1.5)
                    : null,
              ),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: method['icon'],
                          height: 24.h,
                          width: 24.h,
                        ),
                        SizedBox(width: 10.h),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method['title'],
                                style: CustomTextStyles.bodyMediumGray900_1,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                              if (method['subtitle'].isNotEmpty)
                                Text(
                                  method['subtitle'],
                                  style: theme.textTheme.bodyLarge,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: appTheme.deepPurpleA200,
                          size: 24.h,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          color: appTheme.gray500,
                          size: 24.h,
                        ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Section Widget
  Widget _buildConfirmationButton(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 24.h,
        vertical: 18.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 52.h,
            margin: EdgeInsets.symmetric(horizontal: 8.h),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedMethodIndex != -1
                    ? appTheme.deepPurpleA200
                    : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.h),
                ),
              ),
              onPressed: _selectedMethodIndex != -1
                  ? () {
                      // Lưu phương thức thanh toán được chọn
                      final selectedMethod =
                          _paymentMethods[_selectedMethodIndex];
                      _checkoutController.setPaymentMethod(
                          selectedMethod['title'],
                          selectedMethod['icon'],
                          _selectedMethodIndex);

                      // Quay lại màn hình thanh toán
                      Navigator.pop(context);
                    }
                  : null,
              child: Center(
                child: Text(
                  "Đồng ý",
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
