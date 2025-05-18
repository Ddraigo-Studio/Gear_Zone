// filepath: d:\HOCTAP\CrossplatformMobileApp\DOANCK\Project\Gear_Zone\lib\pages\Profile\add_address_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/custom_text_form_field.dart';
import 'package:dvhcvn/dvhcvn.dart' as dvhcvn;
import '../../model/address.dart';
import '../../controller/auth_controller.dart';
import '../../controller/cart_controller.dart'; // Thêm import cart_controller

// ignore_for_file: must_be_immutable
class AddAddressScreen extends StatefulWidget {
  final bool fromRegistration;
  final Map<String, dynamic>? registrationData;

  const AddAddressScreen({
    super.key,
    this.fromRegistration = false,
    this.registrationData,
  });

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  TextEditingController nameInputController = TextEditingController();
  TextEditingController phoneInputController = TextEditingController();
  TextEditingController addressInputController = TextEditingController();

  late AddressData addressData;
  @override
  void initState() {
    super.initState();

    // Nếu đến từ màn hình đăng ký, lấy dữ liệu từ registrationData
    if (widget.fromRegistration && widget.registrationData != null) {
      // Điền dữ liệu số điện thoại nếu có (thường không có từ màn hình đăng ký)
      if (widget.registrationData!.containsKey('phoneNumber')) {
        phoneInputController.text =
            widget.registrationData!['phoneNumber'] ?? '';
      }

    }
    // Nếu không từ trang đăng ký, lấy dữ liệu từ AuthController nếu user đã đăng nhập
    else if (!widget.fromRegistration) {
      final authController = AuthController();
      if (authController.userModel != null) {
        nameInputController.text = authController.userModel!.name;
        phoneInputController.text = authController.userModel!.phoneNumber;
      }
    }

    // Thêm listener cho các TextEditingController
    nameInputController.addListener(_updateButtonState);
    phoneInputController.addListener(_updateButtonState);
    addressInputController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    // Trigger UI refresh when text changes
    addressData.refresh();
  }

  @override
  void dispose() {
    // Xóa listener khi widget bị hủy
    nameInputController.removeListener(_updateButtonState);
    phoneInputController.removeListener(_updateButtonState);
    addressInputController.removeListener(_updateButtonState);
    nameInputController.dispose();
    phoneInputController.dispose();
    addressInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context); // Added
    
    return ChangeNotifierProvider(
      create: (_) {
        addressData = AddressData();
        return addressData;
      },
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: SafeArea(
          top: false,
          child: Center( // Wrap with Center
            child: Container( // Add Container for width constraint
              width: isDesktop ? 1200.0 : double.maxFinite, // Set responsive width
              padding: isDesktop ? EdgeInsets.symmetric(horizontal: 20.h) : null, // Add responsive padding
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView( // Wrap with SingleScrollView to avoid overflow
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.only(
                          left: 16.h,
                          top: 32.h,
                          right: 16.h,
                          bottom: 20.h, // Add bottom padding
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: double.maxFinite,
                              child: Column(
                                children: [
                                  // Only show name and phone inputs if not coming from registration
                                  if (widget.fromRegistration) ...[
                                    Container(
                                      padding: EdgeInsets.all(12.h),
                                      decoration: BoxDecoration(
                                        color: appTheme.gray100,
                                        borderRadius: BorderRadius.circular(8.h),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.info_outline,
                                              color: appTheme.gray700),
                                          SizedBox(width: 10.h),
                                          Expanded(
                                            child: Text(
                                              "Địa chỉ sẽ được lưu với thông tin tài khoản của bạn",
                                              style: CustomTextStyles
                                                  .bodyMediumGray900,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                  ],
                                  if (!widget.fromRegistration) ...[
                                    _buildNameInput(context),
                                    SizedBox(height: 16.h),
                                    _buildPhoneInput(context),
                                    SizedBox(height: 16.h),
                                  ],
                                  _buildProvinceSelector(context),
                                  SizedBox(height: 16.h),
                                  _buildDistrictSelector(context),
                                  SizedBox(height: 16.h),
                                  _buildWardSelector(context),
                                  SizedBox(height: 16.h),
                                  _buildAddressInput(context),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildSaveButtonSection(context),
      ),
    );
  }

  /// Section Widget
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
        text: widget.fromRegistration ? "Thêm địa chỉ" : "Địa chỉ mới",
      ),
    );
  }

  /// Section Widget
  Widget _buildNameInput(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 200.h : 0),
      child: CustomTextFormField(
        controller: nameInputController,
        hintText: "Họ và tên",
        hintStyle: CustomTextStyles.bodyLargeGray700,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.h,
          vertical: 12.h,
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildPhoneInput(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 200.h : 0),
      child: CustomTextFormField(
        controller: phoneInputController,
        hintText: "Số điện thoại",
        textInputType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Vui lòng nhập số điện thoại";
          } else if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
            return "Số điện thoại không hợp lệ";
          }
          return null;
        },
        hintStyle: CustomTextStyles.bodyLargeGray700,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.h,
          vertical: 12.h,
        ),
      ),
    );
  }

  /// Section Widget: Province Selector
  Widget _buildProvinceSelector(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 200.h : 0),
      child: Consumer<AddressData>(
        builder: (context, data, _) => InkWell(
          onTap: () => _selectProvince(context, data),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.h),
              border: Border.all(color: appTheme.gray300, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.province?.name ?? "Chọn Tỉnh/Thành phố",
                  style: data.province != null
                      ? CustomTextStyles.bodyLargeGray700
                      : CustomTextStyles.bodyLargeGray900,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgIconsaxBrokenArrowdown2,
                  height: 24.h,
                  width: 24.h,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget: District Selector
  Widget _buildDistrictSelector(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 200.h : 0),
      child: Consumer<AddressData>(
        builder: (context, data, _) => InkWell(
          onTap:
              data.province != null ? () => _selectDistrict(context, data) : null,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 14.h),
            decoration: BoxDecoration(
              color: data.province != null ? Colors.white : appTheme.gray100,
              borderRadius: BorderRadius.circular(8.h),
              border: Border.all(color: appTheme.gray300, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.district?.name ??
                      (data.province != null
                          ? "Chọn Quận/Huyện"
                          : "Vui lòng chọn Tỉnh/Thành phố trước"),
                  style: data.district != null
                      ? CustomTextStyles.bodyLargeGray700
                      : CustomTextStyles.bodyLargeGray900,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgIconsaxBrokenArrowdown2,
                  height: 24.h,
                  width: 24.h,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget: Ward Selector
  Widget _buildWardSelector(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 200.h : 0),
      child: Consumer<AddressData>(
        builder: (context, data, _) => InkWell(
          onTap: data.district != null ? () => _selectWard(context, data) : null,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 14.h),
            decoration: BoxDecoration(
              color: data.district != null ? Colors.white : appTheme.gray100,
              borderRadius: BorderRadius.circular(8.h),
              border: Border.all(color: appTheme.gray300, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.ward?.name ??
                      (data.district != null
                          ? "Chọn Phường/Xã"
                          : "Vui lòng chọn Quận/Huyện trước"),
                  style: data.ward != null
                      ? CustomTextStyles.bodyLargeGray700
                      : CustomTextStyles.bodyLargeGray900,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgIconsaxBrokenArrowdown2,
                  height: 24.h,
                  width: 24.h,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAddressInput(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 200.h : 0),
      child: CustomTextFormField(
        controller: addressInputController,
        hintText: "Số nhà, tên đường ...",
        hintStyle: CustomTextStyles.bodyLargeGray700,
        textInputType: TextInputType.multiline,
        textInputAction: TextInputAction.done,
        maxLines: 5,
        contentPadding: EdgeInsets.fromLTRB(12.h, 10.h, 12.h, 12.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildSaveButton(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Consumer<AddressData>(
      builder: (context, data, _) {
        bool isValidAddress = data.province != null &&
            data.district != null &&
            data.ward != null &&
            addressInputController.text.isNotEmpty;

        bool isValidContact = nameInputController.text.isNotEmpty &&
            phoneInputController.text.isNotEmpty;

        // If coming from registration, we already have user data, so only check address
        bool isFormValid = widget.fromRegistration
            ? isValidAddress
            : (isValidAddress && isValidContact);

        return ElevatedButton(
          onPressed: isFormValid
              ? () {
                  if (widget.fromRegistration) {
                    // Nếu từ màn hình đăng ký, tiến hành đăng ký người dùng
                    _registerUser(context, data);
                  } else {
                    // Trường hợp thêm địa chỉ bình thường
                    _saveNewAddress(context, data);
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: Size(double.infinity, isDesktop ? 60.h : 50.h), // Tăng chiều cao cho màn hình desktop
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.h),
            ),
          ),
          child: Text(
            widget.fromRegistration ? "Đăng ký" : "Lưu",
            style: theme.textTheme.titleLarge!.copyWith(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildSaveButtonSection(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 300.h : 24.h, // Tăng margin để giảm độ rộng của nút
        vertical: isDesktop ? 20.h : 14.h, // Tăng padding dọc cho desktop
      ),
      decoration: AppDecoration.fillWhiteA,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildSaveButton(context)],
      ),
    );
  }

  // Methods to select address levels
  void _selectProvince(BuildContext context, AddressData data) async {
    final selected = await _showSelectionBottomSheet<dvhcvn.Level1>(
      context: context,
      title: "Chọn Tỉnh/Thành phố",
      items: dvhcvn.level1s,
    );

    if (selected != null) {
      data.province = selected;
    }
  }

  void _selectDistrict(BuildContext context, AddressData data) async {
    if (data.province == null) return;

    final selected = await _showSelectionBottomSheet<dvhcvn.Level2>(
      context: context,
      title: "Chọn Quận/Huyện",
      items: data.province!.children,
    );

    if (selected != null) {
      data.district = selected;
    }
  }

  void _selectWard(BuildContext context, AddressData data) async {
    if (data.district == null) return;

    final selected = await _showSelectionBottomSheet<dvhcvn.Level3>(
      context: context,
      title: "Chọn Phường/Xã",
      items: data.district!.children,
    );

    if (selected != null) {
      data.ward = selected;
    }
  }

  // Generic bottom sheet to select an entity
  Future<T?> _showSelectionBottomSheet<T extends dvhcvn.Entity>({
    required BuildContext context,
    required String title,
    required List<T> items,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          children: [
            Container(
              height: 5.h,
              width: 40.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: appTheme.gray300,
                borderRadius: BorderRadius.circular(2.5.h),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item.name),
                    onTap: () => Navigator.of(context).pop(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tạo mật khẩu ngẫu nhiên
  String _generateRandomPassword({int length = 8}) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(length, (index) {
      final rand = DateTime.now().millisecondsSinceEpoch + index;
      return chars[(rand % chars.length)];
    }).join();
  } // Đăng ký người dùng với thông tin đầy đủ

  Future<void> _registerUser(BuildContext context, AddressData data) async {
    // Lấy thông tin từ màn hình trước
    final email = widget.registrationData?['email'] ?? '';
    final name = widget.registrationData?['name'] ?? '';

    if (email.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thiếu thông tin đăng ký!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Kiểm tra địa chỉ đã được chọn đầy đủ chưa
    if (data.province == null ||
        data.district == null ||
        data.ward == null ||
        addressInputController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng nhập đầy đủ thông tin địa chỉ'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Hiển thị loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Tạo mật khẩu ngẫu nhiên
    final password = _generateRandomPassword();

    try {
      final authController =
          Provider.of<AuthController>(context, listen: false);
      final cartController =
          Provider.of<CartController>(context, listen: false);

      // Đăng ký người dùng
      final success = await authController.registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneInputController.text.trim(),
        cartController: cartController,
        context: context,
      );

      // Đóng dialog loading
      Navigator.pop(context);

      if (success) {
        try {
          // Lưu địa chỉ của người dùng
          await authController.saveUserAddress(
            province: data.province?.name ?? '',
            district: data.district?.name ?? '',
            ward: data.ward?.name ?? '',
            street: addressInputController.text.trim(),
          );

          // Hiển thị thông tin cho người dùng
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Đăng ký thành công'),
              content: Text(
                  'Tài khoản đã được tạo với:\n\nEmail: $email\nMật khẩu: $password\n\nVui lòng lưu lại thông tin đăng nhập này.\n\nĐịa chỉ của bạn đã được lưu thành công.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Đóng dialog
                    // Chuyển đến trang chủ
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.homeScreen,
                      (route) => false,
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } catch (addressError) {
          // Vẫn tiếp tục với quá trình đăng nhập ngay cả khi không lưu được địa chỉ
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Đăng ký thành công'),
              content: Text(
                  'Tài khoản đã được tạo với:\n\nEmail: $email\nMật khẩu: $password\n\nVui lòng lưu lại thông tin đăng nhập này.\n\nLưu ý: Lưu địa chỉ không thành công. Chi tiết lỗi: $addressError'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Đóng dialog
                    // Chuyển đến trang chủ
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.homeScreen,
                      (route) => false,
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authController.error ?? 'Đăng ký thất bại'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Đóng dialog loading
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Lưu địa chỉ mới
  Future<void> _saveNewAddress(BuildContext context, AddressData data) async {
    // Hiển thị loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final authController =
          Provider.of<AuthController>(context, listen: false);

      // Lưu địa chỉ của người dùng
      await authController.saveUserAddress(
        province: data.province?.name ?? '',
        district: data.district?.name ?? '',
        ward: data.ward?.name ?? '',
        street: addressInputController.text.trim(),
        name: nameInputController.text.trim(),
        phoneNumber: phoneInputController.text.trim(),
        title: "Địa chỉ", // Tiêu đề mặc định
        isDefault: true, // Đặt là địa chỉ mặc định nếu là địa chỉ đầu tiên
      );

      // Đóng dialog loading
      Navigator.pop(context);

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã lưu địa chỉ mới thành công!'),
          backgroundColor: Colors.green,
        ),
      );

      // Quay lại màn hình trước
      Navigator.pop(context, true);
    } catch (e) {
      // Đóng dialog loading
      Navigator.pop(context);

      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi lưu địa chỉ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
