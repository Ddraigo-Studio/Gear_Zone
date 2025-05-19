import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../controller/checkout_controller.dart';
import '../../controller/cart_controller.dart';
import '../../controller/auth_controller.dart';
import '../../core/app_export.dart';
import '../../model/cart_item.dart';
import '../../model/product.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/bottom_sheet/add_voucher_bottomsheet.dart';
import '../../services/email_service.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem>? selectedItems;

  const CheckoutScreen({
    super.key,
    this.selectedItems,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late CheckoutController _checkoutController;
  bool _isProcessing = false;
  final _formKey = GlobalKey<FormState>(); // For guest form validation

  @override
  void initState() {
    super.initState();
    _checkoutController = CheckoutController();

    // Lấy danh sách sản phẩm đã chọn
    List<CartItem> itemsToCheckout;
    if (widget.selectedItems != null && widget.selectedItems!.isNotEmpty) {
      itemsToCheckout = widget.selectedItems!;
    } else {
      final cartController = CartController();
      itemsToCheckout = cartController.getSelectedItems();
    }

    _checkoutController.setItems(itemsToCheckout);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _checkoutController,
      child: Scaffold(
        backgroundColor: appTheme.gray10001,
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAddressSection(context),
              SizedBox(height: 16.h),
              _buildItemsSection(context),
              SizedBox(height: 16.h),
              _buildPaymentMethodSection(context),
              SizedBox(height: 16.h),
              _buildVoucherSection(context),
              SizedBox(height: 16.h),
              _buildLoyaltyPointsSection(context),
              SizedBox(height: 16.h),
              _buildOrderSummarySection(context),
            ],
          ),
        ),
        bottomNavigationBar: _buildPlaceOrderButton(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 80.h,
      backgroundColor: Colors.white,
      centerTitle: true,
      shadowColor: Colors.black.withOpacity(0.4),
      elevation: 1,
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
        text: "Thanh toán",
      ),
    );
  }

  Widget _buildAddressSection(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
  final userModel = authController.userModel;

  if (userModel == null) {
    return Container(
      margin: EdgeInsets.all(16.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: appTheme.red400,
                  size: 24.h,
                ),
                SizedBox(width: 12.h),
                Text(
                  "Thông tin giao hàng",
                  style: CustomTextStyles.titleMediumBaloo2Gray500SemiBold,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Họ và tên",
                border: OutlineInputBorder(),
                errorStyle: TextStyle(color: appTheme.red400),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập họ và tên";
                }
                if (value.length < 2) {
                  return "Họ và tên phải có ít nhất 2 ký tự";
                }
                return null;
              },
              onChanged: (value) {
                _checkoutController.setGuestInfo(name: value.trim());
              },
            ),
            SizedBox(height: 12.h),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Số điện thoại",
                border: OutlineInputBorder(),
                errorStyle: TextStyle(color: appTheme.red400),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập số điện thoại";
                }
                if (!RegExp(r'^0[0-9]{9}$').hasMatch(value)) {
                  return "Số điện thoại phải bắt đầu bằng 0 và có 10 chữ số";
                }
                return null;
              },
              onChanged: (value) {
                _checkoutController.setGuestInfo(phone: value.trim());
              },
            ),
            SizedBox(height: 12.h),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                errorStyle: TextStyle(color: appTheme.red400),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập email";
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return "Email không hợp lệ";
                }
                return null;
              },
              onChanged: (value) {
                _checkoutController.setGuestInfo(email: value.trim());
              },
            ),
            SizedBox(height: 12.h),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Địa chỉ",
                border: OutlineInputBorder(),
                errorStyle: TextStyle(color: appTheme.red400),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập địa chỉ";
                }
                if (value.length < 5) {
                  return "Địa chỉ phải có ít nhất 5 ký tự";
                }
                return null;
              },
              onChanged: (value) {
                _checkoutController.setGuestInfo(address: value.trim());
              },
            ),
          ],
        ),
      ),
    );
  }

    // Trường hợp đã đăng nhập: hiển thị địa chỉ như cũ
    if (userModel.addressList.isEmpty) {
      return Container(
        margin: EdgeInsets.all(16.h),
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: appTheme.red400,
                  size: 24.h,
                ),
                SizedBox(width: 12.h),
                Expanded(
                  child: Text(
                    "Bạn chưa có địa chỉ nào",
                    style: CustomTextStyles.titleMediumBaloo2Gray500SemiBold,
                  ),
                ),
                SizedBox(width: 8.h),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: appTheme.deepPurpleA200,
                    size: 24.h,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.addAddressScreen)
                        .then((_) {
                      setState(() {});
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    final Map<String, dynamic>? defaultAddress = userModel.getDefaultAddress();

    if (defaultAddress == null) {
      return Container(
        margin: EdgeInsets.all(16.h),
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Text("Không tìm thấy địa chỉ"),
      );
    }

    final String name = defaultAddress['name'] ?? '';
    final String phoneNumber = defaultAddress['phoneNumber'] ?? '';
    final String fullAddress =
        defaultAddress['fullAddress'] ?? userModel.getDefaultAddressText();

    return Container(
      margin: EdgeInsets.all(16.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                color: appTheme.red400,
                size: 24.h,
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: CustomTextStyles
                              .titleMediumBaloo2Gray500SemiBold
                              .copyWith(
                            color: appTheme.gray70001,
                          ),
                        ),
                        Text(
                          phoneNumber,
                          style:
                              CustomTextStyles.titleMediumBaloo2Gray500SemiBold,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      fullAddress,
                      style: CustomTextStyles.titleMediumBaloo2Gray500SemiBold
                          .copyWith(
                        color: appTheme.gray70001,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.h),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: appTheme.gray700,
                  size: 20.h,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.listAddressScreen)
                      .then((_) {
                    setState(() {});
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(BuildContext context) {
    return Consumer<CheckoutController>(
      builder: (context, controller, child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.h),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Đơn hàng của bạn",
                style: CustomTextStyles.titleMediumBaloo2Gray500SemiBold,
              ),
              SizedBox(height: 16.h),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.items.length,
                separatorBuilder: (context, index) => Divider(height: 24.h),
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.h),
                        child: CustomImageView(
                          imagePath: item.imagePath,
                          width: 80.h,
                          height: 80.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName,
                              style: CustomTextStyles.bodyMediumGray900,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Màu sắc: ${item.color}",
                              style: CustomTextStyles.labelLargeGray60001,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Số lượng: ${item.quantity}",
                              style: CustomTextStyles.labelLargeGray60001,
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${item.discountedPrice.toInt()}đ",
                                  style:
                                      CustomTextStyles.titleSmallGabaritoRed500,
                                ),
                                SizedBox(width: 8.h),
                                Text(
                                  "${item.originalPrice.toInt()}đ",
                                  style:
                                      CustomTextStyles.labelMedium11.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodSection(BuildContext context) {
    return Consumer<CheckoutController>(
      builder: (context, controller, child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.h),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.payment_rounded,
                      color: appTheme.deepPurpleA200,
                      size: 24.h,
                    ),
                    SizedBox(width: 12.h),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phương thức thanh toán",
                            style: CustomTextStyles
                                .titleMediumBaloo2Gray500SemiBold
                                .copyWith(
                              color: appTheme.gray70001,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              if (controller.paymentIcon.isNotEmpty)
                                CustomImageView(
                                  imagePath: controller.paymentIcon,
                                  height: 20.h,
                                  width: 20.h,
                                  margin: EdgeInsets.only(right: 8.h),
                                ),
                              Text(
                                controller.paymentMethod.isNotEmpty
                                    ? controller.paymentMethod
                                    : "Chưa chọn phương thức thanh toán",
                                style: CustomTextStyles
                                    .titleMediumBaloo2Gray500SemiBold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: appTheme.gray700,
                  size: 20.h,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.methodCheckoutScreen)
                      .then((_) {
                    setState(() {});
                  }
                  );
              },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVoucherSection(BuildContext context) {
    return Consumer<CheckoutController>(
      builder: (context, controller, child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          padding: EdgeInsets.all(16.h),
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
                      onPressed: () async {
                        final result = await showModalBottomSheet(
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

                        if (result != null && result is Map<String, dynamic>) {
                          controller.applyVoucher(
                            voucherId: result['id'],
                            code: result['code'],
                            discount: result['discountAmount'],
                          );
                        }
                      },
                      icon: CustomImageView(
                        imagePath: ImageConstant.imgArrowRight,
                      ),
                    ),
                  ],
                ),
              ),
              PromoItem(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoyaltyPointsSection(BuildContext context) {
    return Consumer<CheckoutController>(
      builder: (context, controller, child) {
        final authController = Provider.of<AuthController>(context);
        final userModel = authController.userModel;

        // Chỉ hiển thị điểm tích lũy cho người dùng đã đăng nhập
        if (userModel == null) {
          return SizedBox();
        }

        final loyaltyPoints = userModel.loyaltyPoints;
        if (controller.userPoints != loyaltyPoints) {
          Future.microtask(() => controller.setUserPoints(loyaltyPoints));
        }

        final pointsValue = loyaltyPoints * 1000.0;
        final formattedPointsValue = ProductModel.formatPrice(pointsValue);
        final pointsToEarn = controller.pointsToEarn;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          padding: EdgeInsets.all(16.h),
          decoration: AppDecoration.outlineBlack9004.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.stars_rounded,
                    color: appTheme.deepPurpleA200,
                    size: 24.h,
                  ),
                  SizedBox(width: 12.h),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Điểm tích lũy",
                          style:
                              CustomTextStyles.titleMediumBaloo2Gray500SemiBold,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Bạn đang có $loyaltyPoints điểm (${formattedPointsValue})",
                          style: CustomTextStyles.labelLargeGray60001,
                        ),
                        if (pointsToEarn > 0)
                          Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: Text(
                              "Bạn sẽ tích được $pointsToEarn điểm từ đơn hàng này",
                              style: TextStyle(
                                color: appTheme.deepPurpleA200,
                                fontSize: 12.h,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Switch(
                    value: controller.usePoints,
                    activeColor: appTheme.deepPurpleA200,
                    onChanged: loyaltyPoints > 0
                        ? (value) => controller.toggleUsePoints(value)
                        : null,
                  ),
                ],
              ),
              if (controller.usePoints && controller.pointsDiscount > 0) ...[
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.all(8.h),
                  decoration: BoxDecoration(
                    color: appTheme.deepPurpleA200.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: appTheme.deepPurpleA200,
                        size: 16.h,
                      ),
                      SizedBox(width: 8.h),
                      Expanded(
                        child: Text(
                          "Bạn sẽ dùng hết ${controller.userPoints} điểm và được giảm ${ProductModel.formatPrice(controller.pointsDiscount)}",
                          style: TextStyle(
                            color: appTheme.deepPurpleA200,
                            fontSize: 12.h,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderSummarySection(BuildContext context) {
    return Consumer<CheckoutController>(
      builder: (context, controller, child) {
        final subtotalFormatted =
            ProductModel.formatPrice(controller.subtotalPrice);
        final shippingFeeFormatted =
            ProductModel.formatPrice(controller.shippingFee);
        final taxFeeFormatted = ProductModel.formatPrice(controller.taxFee);
        final voucherDiscountFormatted =
            ProductModel.formatPrice(controller.voucherDiscount);
        final pointsDiscountFormatted =
            ProductModel.formatPrice(controller.pointsDiscount);
        final totalFormatted = ProductModel.formatPrice(controller.totalPrice);

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            color: appTheme.deepPurple1003f,
            borderRadius: BorderRadius.circular(12.h),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chi tiết thanh toán",
                style: CustomTextStyles.titleMediumBaloo2Gray500SemiBold,
              ),
              SizedBox(height: 16.h),
              _buildSummaryRow(
                title: "Tổng tiền hàng",
                price: subtotalFormatted,
              ),
              SizedBox(height: 8.h),
              _buildSummaryRow(
                title: "Phí vận chuyển",
                price: shippingFeeFormatted,
              ),
              SizedBox(height: 8.h),
              _buildSummaryRow(
                title: "Thuế (2%)",
                price: taxFeeFormatted,
              ),
              if (controller.voucherDiscount > 0) ...[
                SizedBox(height: 8.h),
                _buildSummaryRow(
                  title: "Voucher (${controller.voucherCode})",
                  price: "- ${voucherDiscountFormatted}",
                  priceColor: appTheme.red400,
                ),
              ],
              if (controller.usePoints && controller.pointsDiscount > 0) ...[
                SizedBox(height: 8.h),
                _buildSummaryRow(
                  title: "Điểm tích lũy (${controller.userPoints} điểm)",
                  price: "- ${pointsDiscountFormatted}",
                  priceColor: appTheme.red400,
                ),
              ],
              Divider(height: 24.h),
              _buildSummaryRow(
                title: "Tổng thanh toán",
                price: totalFormatted,
                isTotal: true,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow({
    required String title,
    required String price,
    bool isTotal = false,
    Color? priceColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isTotal
              ? CustomTextStyles.titleMediumBaloo2Gray500SemiBold.copyWith(
                  color: appTheme.red400,
                )
              : CustomTextStyles.titleMediumBaloo2Gray500SemiBold.copyWith(
                  color: appTheme.gray70001,
                ),
        ),
        Text(
          price,
          style: isTotal
              ? CustomTextStyles.titleMediumBaloo2Gray500SemiBold
                  .copyWith(color: appTheme.red400)
              : CustomTextStyles.titleMediumBaloo2Gray500SemiBold.copyWith(
                  color: priceColor ?? appTheme.gray900,
                ),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Container(
        height: 48.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _checkoutController.paymentMethod.isEmpty
                ? Colors.grey
                : appTheme.deepPurpleA200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.h),
            ),
            padding: EdgeInsets.symmetric(vertical: 16.h),
          ),
          onPressed: (_isProcessing || _checkoutController.paymentMethod.isEmpty)
              ? null
              : () async {
                  final authController =
                      Provider.of<AuthController>(context, listen: false);

                  // Kiểm tra thông tin khách nếu không đăng nhập
                  if (authController.userModel == null) {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Vui lòng điền đầy đủ thông tin giao hàng.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    // Kiểm tra xem thông tin khách đã được lưu đầy đủ chưa
                    if (_checkoutController.guestName.isEmpty ||
                        _checkoutController.guestAddress.isEmpty ||
                        _checkoutController.guestPhone.isEmpty ||
                        _checkoutController.guestEmail.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Thông tin giao hàng không hợp lệ.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                  }

                  setState(() {
                    _isProcessing = true;
                  });

                  // Thực hiện quá trình thanh toán
                  final orderId = await _checkoutController.completeCheckout();

                  // Lấy thông tin người dùng và địa chỉ
                  final userEmail = authController.firebaseUser?.email ??
                      _checkoutController.guestEmail;
                  final shippingAddress = authController.userModel != null
                      ? authController.userModel!.getDefaultAddress() ?? {}
                      : {
                          'name': _checkoutController.guestName,
                          'phoneNumber': _checkoutController.guestPhone,
                          'fullAddress': _checkoutController.guestAddress,
                        };

                  if (orderId != null) {
                    // Xóa các mục đã chọn khỏi giỏ hàng
                    await CartController().removeSelectedItems();

                    // Cập nhật dữ liệu người dùng (chỉ cho người dùng đã đăng nhập)
                    if (authController.firebaseUser != null) {
                      await authController.refreshUserData();
                    }

                    // Gửi email xác nhận
                    final emailService = EmailService();
                    try {
                      await emailService.sendOrderConfirmation(
                        orderId,
                        userEmail,
                        _checkoutController.items,
                        _checkoutController.totalPrice,
                        shippingAddress,
                      );
                    } catch (e) {
                      print('Lỗi khi gửi email xác nhận: $e');
                    }

                    // Chuyển đến màn hình thành công
                    Navigator.pushNamed(
                      context,
                      AppRoutes.orderPlacedScreen,
                      arguments: {'orderId': orderId},
                    );
                  } else {
                    setState(() {
                      _isProcessing = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Có lỗi xảy ra khi đặt hàng.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
          child: Text(
            _isProcessing ? "Đang xử lý..." : "Đặt hàng",
            style: CustomTextStyles.titleMediumBaloo2Gray500SemiBold.copyWith(
              fontSize: 18.h,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class PromoItem extends StatelessWidget {
  const PromoItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutController>(
      builder: (context, controller, child) {
        if (controller.voucherId == null || controller.voucherCode.isEmpty) {
          return SizedBox();
        }
        final formattedDiscount =
            ProductModel.formatPrice(controller.voucherDiscount);

        return Container(
          margin: EdgeInsets.only(top: 10.h),
          padding: EdgeInsets.all(12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.h),
            border: Border.all(color: appTheme.deepPurpleA200.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgIconsaxBrokenDiscountshapeGreen400,
                height: 24.h,
                width: 24.h,
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.voucherCode,
                      style: CustomTextStyles.titleMediumBalooBhai2Red500,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Giảm ${formattedDiscount} cho đơn hàng",
                      style: CustomTextStyles.labelLargeGray60001,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.removeVoucher();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: appTheme.deepPurpleA200.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.h),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Đã áp dụng",
                        style: TextStyle(
                          color: appTheme.deepPurpleA200,
                          fontSize: 12.h,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4.h),
                      Icon(
                        Icons.close,
                        size: 12.h,
                        color: appTheme.deepPurpleA200,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}