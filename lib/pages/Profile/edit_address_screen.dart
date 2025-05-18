import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/custom_text_form_field.dart';
import 'package:dvhcvn/dvhcvn.dart' as dvhcvn;
import '../../model/address.dart';
import '../../controller/auth_controller.dart';
import '../../core/utils/responsive.dart'; // Added import
import '../../widgets/custom_elevated_button.dart'; // Added import

class EditAddressScreen extends StatefulWidget {
  final Map<String, dynamic> address;

  const EditAddressScreen({
    super.key,
    required this.address,
  });

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController nameInputController = TextEditingController();
  TextEditingController phoneInputController = TextEditingController();
  TextEditingController addressInputController = TextEditingController();

  late AddressData addressData;
  bool isDefault = false;

  @override
  void initState() {
    super.initState();

    // Lấy dữ liệu địa chỉ
    titleController.text = widget.address['title'] ?? 'Địa chỉ';
    nameInputController.text = widget.address['name'] ?? '';
    phoneInputController.text = widget.address['phoneNumber'] ?? '';
    addressInputController.text = widget.address['street'] ?? '';
    isDefault = widget.address['id'] ==
        Provider.of<AuthController>(context, listen: false)
            .userModel
            ?.defaultAddressId;

    // Thêm listener cho các TextEditingController
    titleController.addListener(_updateButtonState);
    nameInputController.addListener(_updateButtonState);
    phoneInputController.addListener(_updateButtonState);
    addressInputController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    // Trigger UI refresh when text changes
    if (mounted) {
      addressData.refresh();
    }
  }

  @override
  void dispose() {
    // Xóa listener khi widget bị hủy
    titleController.removeListener(_updateButtonState);
    nameInputController.removeListener(_updateButtonState);
    phoneInputController.removeListener(_updateButtonState);
    addressInputController.removeListener(_updateButtonState);
    titleController.dispose();
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
        _initializeAddressData();
        return addressData;
      },
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        resizeToAvoidBottomInset: true,
        appBar: _buildAppBar(context),
        body: SafeArea(
          top: false,
          child: Center( // Wrapped with Center
            child: Container( // Wrapped with Container
              width: isDesktop ? 1200.0 : double.maxFinite, // Applied responsive width
              padding: isDesktop ? EdgeInsets.symmetric(horizontal: 20.h) : EdgeInsets.zero, // Applied responsive padding
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: SingleChildScrollView( // Wrapped content with SingleChildScrollView
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.only(
                          left: 16.h,
                          top: 32.h,
                          right: 16.h,
                          bottom: 20.h, // Added bottom padding for scroll
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Changed to min to fit content
                          children: [
                            _buildTitleInput(context),
                            SizedBox(height: 16.h),
                            _buildNameInput(context),
                            SizedBox(height: 16.h),
                            _buildPhoneInput(context),
                            SizedBox(height: 16.h),
                            _buildProvinceSelector(context),
                            SizedBox(height: 16.h),
                            _buildDistrictSelector(context),
                            SizedBox(height: 16.h),
                            _buildWardSelector(context),
                            SizedBox(height: 16.h),
                            _buildAddressInput(context),
                            SizedBox(height: 16.h),
                            _buildDefaultAddressCheckbox(context),
                            // SizedBox(height: 16.h), // Original, ensure enough space or rely on SingleChildScrollView
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

  void _initializeAddressData() async {
    final provinceName = widget.address['province'] ?? '';
    final districtName = widget.address['district'] ?? '';
    final wardName = widget.address['ward'] ?? '';

    try {
      // Tìm province
      if (provinceName.isNotEmpty) {
        final province = dvhcvn.level1s.firstWhere(
          (p) => p.name.toLowerCase() == provinceName.toLowerCase(),
          orElse: () =>
              throw Exception('Không tìm thấy tỉnh/thành phố: $provinceName'),
        );
        addressData.province = province;

        // Tìm district
        if (districtName.isNotEmpty && addressData.province != null) {
          final district = addressData.province!.children.firstWhere(
            (d) => d.name.toLowerCase() == districtName.toLowerCase(),
            orElse: () =>
                throw Exception('Không tìm thấy quận/huyện: $districtName'),
          );
          addressData.district = district;

          // Tìm ward
          if (wardName.isNotEmpty && addressData.district != null) {
            final ward = addressData.district!.children.firstWhere(
              (w) => w.name.toLowerCase() == wardName.toLowerCase(),
              orElse: () =>
                  throw Exception('Không tìm thấy phường/xã: $wardName'),
            );
            addressData.ward = ward;
          }
        }
      }
    } catch (e) {
      // Sử dụng logger thay vì print
      debugPrint('Lỗi khi khởi tạo dữ liệu địa chỉ: $e');
      // Tiếp tục mà không khởi tạo địa chỉ
    }
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 80.h,
      backgroundColor: Colors.white,
      centerTitle: true,
      shadowColor: Colors.black.withAlpha(102),  // Thay withOpacity bằng withAlpha
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
        text: "Chỉnh sửa địa chỉ",
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Colors.red,
            size: 25.h,
          ),
          onPressed: () => _showDeleteConfirmation(context),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildTitleInput(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 200.h : 0),
      child: CustomTextFormField(
        controller: titleController,
        hintText: "Tiêu đề (Ví dụ: Nhà, Công ty, ...)",
        hintStyle: CustomTextStyles.bodyLargeGray700,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.h,
          vertical: 12.h,
        ),
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

  /// Phương thức để chọn tỉnh/thành phố
  Future<void> _selectProvince(BuildContext context, AddressData data) async {
    // Hiển thị bottomsheet để chọn tỉnh/thành phố
    final selectedProvince = await showModalBottomSheet<dvhcvn.Level1?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.only(
          top: 16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Text(
                "Chọn Tỉnh/Thành phố",
                style: TextStyle(
                  fontSize: 18.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: dvhcvn.level1s.length,
                itemBuilder: (context, index) {
                  final province = dvhcvn.level1s[index];
                  return ListTile(
                    title: Text(province.name),
                    onTap: () {
                      Navigator.pop(context, province);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (selectedProvince != null) {
      data.province = selectedProvince;
      data.district = null;
      data.ward = null;
      data.refresh();
    }
  }

  /// Phương thức để chọn quận/huyện
  Future<void> _selectDistrict(BuildContext context, AddressData data) async {
    if (data.province == null) return;

    // Hiển thị bottomsheet để chọn quận/huyện
    final selectedDistrict = await showModalBottomSheet<dvhcvn.Level2?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.only(
          top: 16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Text(
                "Chọn Quận/Huyện",
                style: TextStyle(
                  fontSize: 18.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: data.province!.children.length,
                itemBuilder: (context, index) {
                  final district = data.province!.children[index];
                  return ListTile(
                    title: Text(district.name),
                    onTap: () {
                      Navigator.pop(context, district);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (selectedDistrict != null) {
      data.district = selectedDistrict;
      data.ward = null;
      data.refresh();
    }
  }

  /// Phương thức để chọn phường/xã
  Future<void> _selectWard(BuildContext context, AddressData data) async {
    if (data.district == null) return;

    // Hiển thị bottomsheet để chọn phường/xã
    final selectedWard = await showModalBottomSheet<dvhcvn.Level3?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.only(
          top: 16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Text(
                "Chọn Phường/Xã",
                style: TextStyle(
                  fontSize: 18.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: data.district!.children.length,
                itemBuilder: (context, index) {
                  final ward = data.district!.children[index];
                  return ListTile(
                    title: Text(ward.name),
                    onTap: () {
                      Navigator.pop(context, ward);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (selectedWard != null) {
      data.ward = selectedWard;
      data.refresh();
    }
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
        maxLines: 3,
        contentPadding: EdgeInsets.fromLTRB(12.h, 10.h, 12.h, 12.h),
      ),
    );
  }

  /// Checkbox để chọn địa chỉ mặc định
  Widget _buildDefaultAddressCheckbox(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 200.h : 0),
      child: Row(
        children: [
          Checkbox(
            value: isDefault,
            activeColor: appTheme.deepPurpleA200,
            onChanged: (value) {
              setState(() {
                isDefault = value ?? false;
              });
            },
          ),
          Text(
            "Đặt làm địa chỉ mặc định",
            style: CustomTextStyles.bodyLargeGray900,
          ),
        ],
      ),
    );
  }
  /// Section Widget
  Widget _buildSaveButtonSection(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Consumer<AddressData>(
      builder: (context, data, _) {
        bool isButtonEnabled = _isFormValid(data);
        return Container(
          margin: EdgeInsets.only(
            left: isDesktop ? 300.h : 24.h, // Tăng margin để giảm độ rộng của nút
            right: isDesktop ? 300.h : 24.h, // Tăng margin để giảm độ rộng của nút
            bottom: isDesktop ? 40.h : 32.h, // Tăng bottom margin
            top: 20.h // Tăng top margin
          ),
          child: CustomElevatedButton(
            height: isDesktop ? 55.h : 50.h, // Tăng chiều cao của nút
            buttonTextStyle: CustomTextStyles.bodyLargeWhiteA700,
            text: "Cập nhật",
            isDisabled: !isButtonEnabled,
            onPressed: () {
              if (isButtonEnabled) {
                _updateAddress(context, data);
              }
            },
          ),
        );
      },
    );
  }

  // Phương thức kiểm tra tính hợp lệ của form
  bool _isFormValid(AddressData data) {
    return titleController.text.isNotEmpty &&
        nameInputController.text.isNotEmpty &&
        phoneInputController.text.isNotEmpty &&
        addressInputController.text.isNotEmpty &&
        data.province != null &&
        data.district != null &&
        data.ward != null;
  }
  // Phương thức cập nhật địa chỉ
  void _updateAddress(BuildContext context, AddressData data) {
    // Implement your save address logic here
    final authController = Provider.of<AuthController>(context, listen: false);
    
    final String addressId = widget.address['id'];
    
    // Gọi phương thức updateUserAddress thay vì updateAddress
    authController.updateUserAddress(
      addressId: addressId,
      title: titleController.text,
      name: nameInputController.text,
      phoneNumber: phoneInputController.text,
      province: data.province?.name ?? '',
      district: data.district?.name ?? '',
      ward: data.ward?.name ?? '',
      street: addressInputController.text,
      setAsDefault: isDefault,
    );
    
    // Hiển thị thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã cập nhật địa chỉ thành công'),
        backgroundColor: Colors.green,
      ),
    );
    
    Navigator.pop(context); // Quay lại màn hình trước
  }
    void _showDeleteConfirmation(BuildContext context) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa địa chỉ này không?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // Will return false
              },
            ),
            TextButton(
              child: Text('Xóa', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Will return true
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      final authController = Provider.of<AuthController>(context, listen: false);
      // Sử dụng phương thức đúng deleteUserAddress thay vì deleteAddress
      await authController.deleteUserAddress(addressId: widget.address['id']);
      
      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xóa địa chỉ thành công'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context); // Quay lại màn hình trước
    }
  }
}