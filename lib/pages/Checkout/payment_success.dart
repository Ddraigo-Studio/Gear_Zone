import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../model/order.dart';
import '../../controller/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String? orderId;

  const PaymentSuccessScreen({super.key, this.orderId});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  OrderModel? orderData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.orderId != null) {
      _fetchOrderDetails();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchOrderDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .get();

      if (doc.exists) {
        setState(() {
          orderData = OrderModel.fromFirestore(doc);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching order details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

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
              SizedBox(height: 40.h),
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
          if (isLoading)
            CircularProgressIndicator()
          else if (orderData != null)
            Column(
              children: [
                Text(
                  "Mã đơn hàng: ${orderData!.id.substring(0, 8)}",
                  style: CustomTextStyles.bodyLargeGray900.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Tổng tiền: ${_formatPrice(orderData!.total)}",
                  style: CustomTextStyles.bodyLargeGray900.copyWith(
                    fontWeight: FontWeight.bold,
                    color: appTheme.red400,
                  ),
                ),
              ],
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
            alignment: Alignment.center,
            onPressed: () {
              if (orderData != null) {
                Navigator.pushNamed(context, AppRoutes.ordersDetailScreen,
                    arguments: {'orderId': orderData!.id});
              } else {
                Navigator.pushNamed(context, AppRoutes.ordersHistoryScreen);
              }
            },
          ),
          SizedBox(height: 20.h),
          CustomElevatedButton(
            height: 60.h,
            text: "Tiếp tục mua sắm",
            buttonStyle: CustomButtonStyles.fillDeepPurple,
            buttonTextStyle: CustomTextStyles.bodyLargeWhiteA70018,
            alignment: Alignment.center,
            onPressed: () {
              // Refresh user data to update loyalty points in case they weren't updated
              final authController =
                  Provider.of<AuthController>(context, listen: false);
              if (authController.firebaseUser != null) {
                authController.refreshUserData();
              }

              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.homeScreen,
                (route) => false,
              );
            },
          ),
          SizedBox(height: 20.h)
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }
}
