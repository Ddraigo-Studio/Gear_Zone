import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../controller/checkout_controller.dart';
import '../../controller/cart_controller.dart';
import '../../controller/auth_controller.dart';
import '../../core/app_export.dart';
import '../../model/cart_item.dart';
import '../../model/product.dart'; // Thêm import cho ProductModel
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/bottom_sheet/add_voucher_bottomsheet.dart';
import '../../services/email_service.dart'; // Add this import

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
    // Lấy thông tin người dùng từ AuthController
    final authController = Provider.of<AuthController>(context);
    final userModel = authController.userModel;

    // Kiểm tra nếu người dùng chưa đăng nhập hoặc không có địa chỉ
    if (userModel == null || userModel.addressList.isEmpty) {
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
                      // Refresh khi quay lại từ trang thêm địa chỉ
                      setState(() {});
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } // Lấy địa chỉ mặc định sử dụng phương thức mới từ UserModel
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

    // Lấy thông tin từ địa chỉ mặc định
    final String name = defaultAddress['name'] ?? '';
    final String phoneNumber = defaultAddress['phoneNumber'] ?? '';
    // Ưu tiên sử dụng trường fullAddress nếu có
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
                  // Điều hướng đến trang chọn địa chỉ
                  Navigator.pushNamed(context, AppRoutes.listAddressScreen)
                      .then((_) {
                    // Refresh khi quay lại từ trang chọn địa chỉ
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
                  // Điều hướng đến trang chọn phương thức thanh toán
                  Navigator.pushNamed(context, AppRoutes.methodCheckoutScreen)
                      .then((_) {
                    // Cập nhật giao diện khi quay lại từ trang chọn phương thức
                    setState(() {});
                  });
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

                        // Xử lý kết quả từ bottomsheet
                        if (result != null && result is Map<String, dynamic>) {
                          // Áp dụng voucher vào controller
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
        // Lấy thông tin người dùng từ AuthController
        final authController = Provider.of<AuthController>(context);
        final userModel = authController.userModel;

        if (userModel == null) {
          return SizedBox(); // Không hiển thị nếu không có người dùng
        }

        // Lấy số điểm hiện có
        final loyaltyPoints = userModel.loyaltyPoints;
        // Cập nhật điểm vào controller nếu chưa cập nhật
        if (controller.userPoints != loyaltyPoints) {
          // Chỉ cập nhật ở lần đầu tiên
          Future.microtask(() => controller.setUserPoints(loyaltyPoints));
        }

        // Tính toán số tiền được giảm
        final pointsValue = loyaltyPoints * 1000.0;
        final formattedPointsValue = ProductModel.formatPrice(pointsValue);

        // Tính số điểm sẽ tích được từ đơn hàng này
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

  // Thay thế phần code trong _buildOrderSummarySection

  Widget _buildOrderSummarySection(BuildContext context) {
    return Consumer<CheckoutController>(
      builder: (context, controller, child) {
        // Sử dụng phương thức formatPrice từ ProductModel để định dạng nhất quán với cart screen
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
            color: appTheme.deepPurple1003f, // Màu tím nhạt
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
                setState(() {
                  _isProcessing = true;
                });

                // Thực hiện quá trình thanh toán
                final orderId = await _checkoutController.completeCheckout();

                // Lấy thông tin người dùng và địa chỉ
                final authController = Provider.of<AuthController>(context, listen: false);
                final userEmail = authController.firebaseUser?.email ?? '';
                final shippingAddress = authController.userModel?.getDefaultAddress() ?? {};

                if (orderId != null) {
                  // Xóa các mục đã chọn khỏi giỏ hàng
                  await CartController().removeSelectedItems();

                  // Cập nhật dữ liệu người dùng (điểm tích lũy, v.v.)
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
                    // Không dừng quá trình nếu email thất bại
                  }

                  // Chuyển đến màn hình thành công
                  Navigator.pushNamed(context, AppRoutes.orderPlacedScreen, arguments: {'orderId': orderId});
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

// Custom widget for displaying a promo item
class PromoItem extends StatelessWidget {
  const PromoItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutController>(
      builder: (context, controller, child) {
        // Nếu không có voucher, không hiển thị gì cả
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
                  // Xóa voucher khi người dùng nhấn
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
