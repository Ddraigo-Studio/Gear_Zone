import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/checkout_controller.dart';
import '../../controller/cart_controller.dart';
import '../../controller/auth_controller.dart';
import '../../core/app_export.dart';
import '../../model/cart_item.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/bottom_sheet/add_voucher_bottomsheet.dart';
import '../../widgets/custom_image_view.dart';

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
  bool _isVoucherApplied = true; // Để hiển thị ví dụ voucher đã được áp dụng
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
              _isVoucherApplied ? SizedBox(height: 0) : SizedBox(height: 16.h),
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
                    Navigator.pushNamed(context, AppRoutes.addAddressScreen).then((_) {
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
    }
    
    // Lấy địa chỉ mặc định nếu có
    final Map<String, dynamic>? defaultAddress = userModel.defaultAddressId != null
        ? userModel.addressList.firstWhere(
            (address) => address['id'] == userModel.defaultAddressId,
            orElse: () => userModel.addressList.first)
        : userModel.addressList.first;
    
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
    final String fullAddress = defaultAddress['fullAddress'] ?? '';
    
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
                  Navigator.pushNamed(context, AppRoutes.listAddressScreen).then((_) {
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
                        style: CustomTextStyles.titleMediumBaloo2Gray500SemiBold
                            .copyWith(
                          color: appTheme.gray70001,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Chưa chọn phương thức thanh toán",
                        style:
                            CustomTextStyles.titleMediumBaloo2Gray500SemiBold,
                        overflow: TextOverflow.ellipsis,
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
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherSection(BuildContext context) {
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
          PromoItem(),
        ],
      ),
    );
  }

  Widget _buildOrderSummarySection(BuildContext context) {
    return Consumer<CheckoutController>(
      builder: (context, controller, child) {
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
                price: "\$8.00",
              ),
              SizedBox(height: 8.h),
              _buildSummaryRow(
                title: "Tổng tiền phí vận chuyển",
                price: "\$8.00",
              ),
              SizedBox(height: 8.h),
              _buildSummaryRow(
                title: "Giảm giá phí vận chuyển",
                price: "\$8.00",
              ),
              SizedBox(height: 8.h),
              _buildSummaryRow(
                title: "Thuế",
                price: "\$0.00",
              ),
              SizedBox(height: 8.h),
              _buildSummaryRow(
                title: "Voucher",
                price: "- 8.000 đ",
                priceColor: appTheme.red400,
              ),
              Divider(height: 24.h),
              _buildSummaryRow(
                title: "Tổng thanh toán",
                price: "${controller.totalPrice.toInt()}đ",
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
                  color: appTheme.gray900,
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
            backgroundColor: appTheme.deepPurpleA200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.h),
            ),
            padding: EdgeInsets.symmetric(vertical: 16.h),
          ),
          onPressed: _isProcessing
              ? null
              : () async {
                  setState(() {
                    _isProcessing = true;
                  });

                  // Lấy CartController để xóa các sản phẩm đã được thanh toán
                  final cartController = CartController();

                  final success = await _checkoutController.completeCheckout();

                  if (success) {
                    // Xóa các mục đã chọn khỏi giỏ hàng
                    await cartController.removeSelectedItems();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đặt hàng thành công!'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.homeScreen,
                        (route) => false,
                      );
                    });
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
  @override
  Widget build(BuildContext context) {
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
                  "WELCOME10",
                  style: CustomTextStyles.titleMediumBalooBhai2Red500,
                ),
                SizedBox(height: 2.h),
                Text(
                  "Giảm 10% cho đơn hàng đầu tiên",
                  style: CustomTextStyles.labelLargeGray60001,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
            decoration: BoxDecoration(
              color: appTheme.deepPurpleA200.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.h),
            ),
            child: Text(
              "Đã áp dụng",
              style: TextStyle(
                color: appTheme.deepPurpleA200,
                fontSize: 12.h,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
