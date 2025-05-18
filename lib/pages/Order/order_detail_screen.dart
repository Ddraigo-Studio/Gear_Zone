import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/bottom_sheet/add_voucher_bottomsheet.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../controller/order_controller.dart';
import '../../model/order.dart';

class OrdersDetailScreen extends StatefulWidget {
  final String? orderId;

  const OrdersDetailScreen({super.key, this.orderId});

  @override
  State<OrdersDetailScreen> createState() => _OrdersDetailScreenState();
}

class _OrdersDetailScreenState extends State<OrdersDetailScreen> {
  OrderModel? orderData;
  bool isLoading = true;
  final OrderController _orderController = OrderController();

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
      final order = await _orderController.getOrderById(widget.orderId!);
      setState(() {
        orderData = order;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching order details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray100,
      appBar: _buildAppBar(context),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              top: false,
              child: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(
                      left: 16.h,
                      top: 24.h,
                      right: 16.h,
                    ),
                    child: Column(
                      children: [
                        _buildOrderInformation(context),
                        SizedBox(height: 48.h),
                        _buildOrderList(context),
                        SizedBox(height: 48.h),
                        _buildPromoCode(context),
                        SizedBox(height: 16.h),
                        _buildPaymentInfo(context),
                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      bottomNavigationBar: _buildReviewAndReturn(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 80.h,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: IconButton(
        icon: AppbarLeadingImage(
          imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
          height: 25.h,
          width: 25.h,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: AppbarSubtitleTwo(
        text: "Thông tin đơn hàng",
      ),
    );
  }

  /// Section Widget
  Widget _buildOrderInformation(BuildContext context) {
    if (orderData == null) {
      return Container(
        padding: EdgeInsets.all(16.h),
        decoration: AppDecoration.fillWhiteA.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder5,
        ),
        child: Center(
          child: Text(
            "Không tìm thấy thông tin đơn hàng",
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    // Define status timeline based on current order status
    List<Map<String, String>> statusTimeline = [];

    // Always include order date
    statusTimeline.add({
      'status': 'Thời gian đặt hàng',
      'date': DateFormat('dd-MM-yyyy').format(orderData!.orderDate),
      'time': DateFormat('HH:mm').format(orderData!.orderDate),
    });

    // Add more status points based on current order status
    if (orderData!.status == 'Đang xử lý' ||
        orderData!.status == 'Đang vận chuyển' ||
        orderData!.status == 'Đã giao hàng') {
      statusTimeline.add({
        'status': 'Đang xử lý',
        'date': DateFormat('dd-MM-yyyy')
            .format(orderData!.orderDate.add(Duration(days: 1))),
        'time': DateFormat('HH:mm')
            .format(orderData!.orderDate.add(Duration(hours: 2))),
      });
    }

    if (orderData!.status == 'Đang vận chuyển' ||
        orderData!.status == 'Đã giao hàng') {
      statusTimeline.add({
        'status': 'Đang vận chuyển',
        'date': DateFormat('dd-MM-yyyy')
            .format(orderData!.orderDate.add(Duration(days: 2))),
        'time': DateFormat('HH:mm')
            .format(orderData!.orderDate.add(Duration(hours: 4))),
      });
    }

    if (orderData!.status == 'Đã giao hàng') {
      statusTimeline.add({
        'status': 'Đã giao hàng',
        'date': DateFormat('dd-MM-yyyy')
            .format(orderData!.orderDate.add(Duration(days: 3))),
        'time': DateFormat('HH:mm')
            .format(orderData!.orderDate.add(Duration(hours: 8))),
      });
    }

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 8.h,
      ),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Mã đơn hàng",
                  style: theme.textTheme.bodyMedium,
                ),
                Spacer(),
                Text(
                  orderData!.id.substring(
                      0, 8 < orderData!.id.length ? 8 : orderData!.id.length),
                  style: theme.textTheme.bodyMedium,
                ),
                Container(
                  margin: EdgeInsets.only(left: 8.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.h,
                    vertical: 2.h,
                  ),
                  decoration: AppDecoration.outlineGray50001.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder8,
                  ),
                  child: Text(
                    "COPY",
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.labelLargeBaloo2Gray900,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 158.h,
                  child: Text(
                    "Phương thức thanh toán",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Text(
                  orderData!.paymentMethod == 'COD'
                      ? 'Tiền mặt'
                      : orderData!.paymentMethod,
                  style: CustomTextStyles.bodyMedium13,
                )
              ],
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.maxFinite,
            child: Divider(
              color: appTheme.gray500.withValues(
                alpha: 0.9,
              ),
            ),
          ),
          SizedBox(height: 14.h),
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 12.h,
              );
            },
            itemCount: statusTimeline.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconButton(
                    height: 24.h,
                    width: 24.h,
                    padding: EdgeInsets.all(6.h),
                    decoration: IconButtonStyleHelper.fillPrimary,
                    child: CustomImageView(
                      imagePath: ImageConstant.imgCheckLine,
                    ),
                  ),
                  SizedBox(width: 12.h),
                  Expanded(
                    child: Text(
                      statusTimeline[index]['status'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.titleMediumBalooBhai2Gray700
                          .copyWith(fontSize: 14.h),
                    ),
                  ),
                  Text(
                    statusTimeline[index]['date'] ?? '',
                    style: CustomTextStyles.bodyMedium13,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6.h),
                    child: Text(
                      statusTimeline[index]['time'] ?? '',
                      style: CustomTextStyles.bodyMedium13,
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildOrderList(BuildContext context) {
    if (orderData == null || orderData!.items.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16.h),
        decoration: AppDecoration.fillWhiteA.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder5,
        ),
        child: Center(
          child: Text(
            "Không có sản phẩm nào trong đơn hàng",
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 16.h,
        );
      },
      itemCount: orderData!.items.length,
      itemBuilder: (context, index) {
        final item = orderData!.items[index];
        return Container(
          padding: EdgeInsets.all(10.h),
          decoration: AppDecoration.fillWhiteA.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder8,
          ),
          child: Row(
            children: [
              CustomImageView(
                imagePath: item.productImage ?? ImageConstant.imgImage33,
                height: 42.h,
                width: 64.h,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 222.h,
                      child: Text(
                        item.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            CustomTextStyles.bodySmallBalooBhaiGray900.copyWith(
                          height: 1.60,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Màu sắc: ${item.color ?? 'N/A'}",
                            style: CustomTextStyles.labelMediumGray60001,
                          ),
                          Text(
                            "Số lượng: ${item.quantity}",
                            style: CustomTextStyles.labelMediumGray60001,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6.h),
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 4.h),
                            child: Text(
                              _formatPrice(item.price),
                              style: theme.textTheme.labelLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildPromoCode(BuildContext context) {
    bool hasVoucher = orderData?.voucherId != null && orderData!.discount > 0;

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 8.h,
      ),
      decoration: AppDecoration.outlineBlack9004.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgIconsaxBrokenDiscountshape,
                  height: 24.h,
                  width: 26.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Text(
                    "Mã giảm giá",
                    style: CustomTextStyles.titleMediumBalooBhai2Red500,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.h),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return AddVoucherBottomsheet();
                      },
                    );
                  },
                  icon: CustomImageView(
                    imagePath: ImageConstant.imgArrowRight,
                  ),
                ),
              ],
            ),
          ),
          if (hasVoucher)
            Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Divider(
                    color: appTheme.gray500.withValues(
                      alpha: 0.9,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h, right: 10.h),
                      child: CustomIconButton(
                        height: 34.h,
                        width: 34.h,
                        padding: EdgeInsets.all(6.h),
                        decoration: IconButtonStyleHelper.fillDeepPurpleTL16,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgDiscount,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Giảm ${(orderData!.discount / orderData!.subtotal * 100).toStringAsFixed(0)}%",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyles.titleMediumBalooBhai2Gray700
                                .copyWith(
                              height: 1.60,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Mã khuyến mãi:",
                                style: CustomTextStyles.titleSmallInterGray700,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4.h),
                                child: Text(
                                  orderData!.voucherId ?? '',
                                  style: CustomTextStyles.titleSmallInterRed500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPaymentInfo(BuildContext context) {
    if (orderData == null) {
      return Container();
    }

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 8.h,
        vertical: 6.h,
      ),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgReviewCheckmark,
                  height: 24.h,
                  width: 24.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.h),
                  child: Text(
                    "Chi tiết thanh toán",
                    style: CustomTextStyles.titleMediumBalooBhai2Gray700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Divider(
              color: appTheme.gray500.withValues(
                alpha: 0.9,
              ),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tổng tiền hàng",
                  style: CustomTextStyles.bodyLargeGray50001,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Text(
                    "(${orderData!.items.length} món)",
                    style: CustomTextStyles.bodyLargeGray50001,
                  ),
                ),
                Spacer(),
                Text(
                  _formatPrice(orderData!.subtotal),
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: _buildInfoRow(
              context,
              uiphvnchuyOne: "Phí vận chuyển",
              priceThree: _formatPrice(orderData!.shippingFee),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: _buildInfoRow(
              context,
              uiphvnchuyOne: "Thuế (2%)",
              priceThree: _formatPrice(orderData!.subtotal * 0.02),
            ),
          ),
          if (orderData!.discount > 0)
            SizedBox(
              width: double.maxFinite,
              child: _buildInfoRow(
                context,
                uiphvnchuyOne: "Voucher",
                priceThree: "- ${_formatPrice(orderData!.discount)}",
              ),
            ),
          SizedBox(
            width: double.maxFinite,
            child: Divider(
              color: appTheme.gray500.withValues(
                alpha: 0.9,
              ),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: _buildInfoRow(
              context,
              uiphvnchuyOne: "Thành tiền:",
              priceThree: _formatPrice(orderData!.total),
            ),
          ),
        ],
      ),
    );
  }
  /// Section Widget
  Widget _buildReviewAndReturn(BuildContext context) {
    bool showReturnButton =
        orderData != null && orderData!.status == 'Đã giao hàng';

    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 20.h,
      ),
      decoration: AppDecoration.fillWhiteA,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [          CustomOutlinedButton(
            height: 38.h,
            width: 110.h,
            text: "Xem đánh giá",
            onPressed: () {
              try {
                // In ra lỗi Firebase để user có thể click vào đường link tạo index
                print("Firebase error: [cloud_firestore/failed-precondition] The query requires an index. You can create it here: https://console.firebase.google.com/v1/r/project/your-project-id/firestore/indexes?create_composite=Ck9wcm9qZWN0cy95b3VyLXByb2plY3QtaWQvZGF0YWJhc2VzLyhkZWZhdWx0KS9jb2xsZWN0aW9uR3JvdXBzL3Jldmlld3MvaW5kZXhlcy9fEAEaCAoEZGF0ZRABGgwKCHByb2R1Y3RzEAEaDAoIX19uYW1lX18QARI=");
                // Hiển thị SnackBar với hướng dẫn
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Có lỗi xảy ra. Xem chi tiết ở Debug Console'),
                    duration: Duration(seconds: 5),
                  ),
                );
              } catch (e) {
                print("Firebase error: $e");
              }
            },
            buttonStyle: CustomButtonStyles.outlinePrimary,
            buttonTextStyle: CustomTextStyles.bodyMediumDeeppurple400,
          ),
          CustomOutlinedButton(
            height: 38.h,
            width: 110.h,
            text: "Về trang chủ",            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.homeScreen,
                (route) => false,
              );
            },
            buttonStyle: CustomButtonStyles.outlineGray,
            buttonTextStyle: CustomTextStyles.bodyMediumGray900,
          ),
          if (showReturnButton)
            CustomOutlinedButton(
              height: 38.h,
              width: 120.h,
              text: "Yêu cầu trả hàng",
              buttonStyle: CustomButtonStyles.outlineGrayTL10,
              buttonTextStyle: theme.textTheme.bodyMedium!,
            ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildInfoRow(
    BuildContext context, {
    required String uiphvnchuyOne,
    required String priceThree,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          uiphvnchuyOne,
          style: CustomTextStyles.bodyLargeGray900.copyWith(
            color: appTheme.gray900.withValues(
              alpha: 0.5,
            ),
          ),
        ),
        Text(
          priceThree,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: appTheme.gray900,
          ),
        ),
      ],
    );
  }
}
