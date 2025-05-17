import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/custom_text_form_field.dart';
import 'package:dvhcvn/dvhcvn.dart' as dvhcvn;
import '../../model/address.dart';
import '../../controller/auth_controller.dart';

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
    if (mounted && addressData != null) {
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
    return ChangeNotifierProvider(
      create: (_) {
        addressData = AddressData();

        // Khởi tạo địa chỉ từ dữ liệu có sẵn
        _initializeAddressData();

        return addressData;
      },
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: SafeArea(
          top: false,
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(
                      left: 16.h,
                      top: 32.h,
                      right: 16.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: double.maxFinite,
                          child: Column(
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
      print('Lỗi khi khởi tạo dữ liệu địa chỉ: $e');
      // Tiếp tục mà không khởi tạo địa chỉ
    }
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
    return CustomTextFormField(
      controller: titleController,
      hintText: "Tiêu đề (Ví dụ: Nhà, Công ty, ...)",
      hintStyle: CustomTextStyles.bodyLargeGray700,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 12.h,
      ),
    );
  }

  /// Section Widget
  Widget _buildNameInput(BuildContext context) {
    return CustomTextFormField(
      controller: nameInputController,
      hintText: "Họ và tên",
      hintStyle: CustomTextStyles.bodyLargeGray700,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 12.h,
      ),
    );
  }

  /// Section Widget
  Widget _buildPhoneInput(BuildContext context) {
    return CustomTextFormField(
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
    );
  }

  /// Section Widget: Province Selector
  Widget _buildProvinceSelector(BuildContext context) {
    return Consumer<AddressData>(
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
    );
  }

  /// Section Widget: District Selector
  Widget _buildDistrictSelector(BuildContext context) {
    return Consumer<AddressData>(
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
    );
  }

  /// Section Widget: Ward Selector
  Widget _buildWardSelector(BuildContext context) {
    return Consumer<AddressData>(
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
    );
  }

  /// Section Widget
  Widget _buildAddressInput(BuildContext context) {
    return CustomTextFormField(
      controller: addressInputController,
      hintText: "Số nhà, tên đường ...",
      hintStyle: CustomTextStyles.bodyLargeGray700,
      textInputType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      maxLines: 3,
      contentPadding: EdgeInsets.fromLTRB(12.h, 10.h, 12.h, 12.h),
    );
  }

  /// Checkbox để chọn địa chỉ mặc định
  Widget _buildDefaultAddressCheckbox(BuildContext context) {
    return Row(
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
    );
  }

  /// Section Widget
  Widget _buildSaveButton(BuildContext context) {
    return Consumer<AddressData>(
      builder: (context, data, _) {
        bool isValidAddress = data.province != null &&
            data.district != null &&
            data.ward != null &&
            addressInputController.text.isNotEmpty;

        bool isValidContact = nameInputController.text.isNotEmpty &&
            phoneInputController.text.isNotEmpty;

        bool isFormValid = isValidAddress && isValidContact;

        return ElevatedButton(
          onPressed: isFormValid ? () => _updateAddress(context, data) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: appTheme.deepPurpleA200,
            minimumSize: Size(double.infinity, 60.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.h),
            ),
          ),
          child: Text(
            "Cập nhật",
            style: theme.textTheme.titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildSaveButtonSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 24.h,
        vertical: 14.h,
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
      data.district = null;
      data.ward = null;
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
      data.ward = null;
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

  // Phương thức cập nhật địa chỉ
  Future<void> _updateAddress(BuildContext context, AddressData data) async {
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

    try {
      final authController =
          Provider.of<AuthController>(context, listen: false);

      // Cập nhật địa chỉ
      final success = await authController.updateUserAddress(
        addressId: widget.address['id'],
        province: data.province!.name,
        district: data.district!.name,
        ward: data.ward!.name,
        street: addressInputController.text.trim(),
        title: titleController.text.trim(),
        name: nameInputController.text.trim(),
        phoneNumber: phoneInputController.text.trim(),
        setAsDefault: isDefault,
      );

      // Đóng dialog loading
      Navigator.pop(context);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cập nhật địa chỉ thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(
            context, true); // Trả về true để biết đã cập nhật thành công
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authController.error ?? 'Cập nhật địa chỉ thất bại'),
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

  // Hiển thị xác nhận xóa địa chỉ
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Xác nhận xóa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: appTheme.deepPurpleA200,
          ),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa địa chỉ này không?',
          style: TextStyle(fontSize: 16.h),
        ),
        actions: [
          TextButton(
            child: Text(
              'Hủy',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: Text(
              'Xóa',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteAddress(context);
            },
          ),
        ],
      ),
    );
  }

  // Phương thức xóa địa chỉ
  Future<void> _deleteAddress(BuildContext context) async {
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

      // Xóa địa chỉ
      final success = await authController.deleteUserAddress(
        addressId: widget.address['id'],
      );

      // Đóng dialog loading
      Navigator.pop(context);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xóa địa chỉ thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Trả về true để biết đã xóa thành công
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authController.error ?? 'Xóa địa chỉ thất bại'),
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
}
