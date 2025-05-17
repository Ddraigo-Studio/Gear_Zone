import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../items/voucher_item.dart';
import '../app_bar/appbar_leading_image.dart';
import '../../controller/voucher_controller.dart';
import '../../model/voucher.dart';

class AddVoucherBottomsheet extends StatefulWidget {
  const AddVoucherBottomsheet({super.key});

  @override
  State<AddVoucherBottomsheet> createState() => _AddVoucherBottomsheetState();
}

class _AddVoucherBottomsheetState extends State<AddVoucherBottomsheet> {
  final VoucherController _voucherController = VoucherController();
  List<Voucher> _vouchers = [];
  bool _isLoading = true;
  String? _selectedVoucherId;

  final double _shippingFee = 30000;
  final double _taxRate = 0.02;

  @override
  void initState() {
    super.initState();
    _loadVouchers();
  }

  // Load danh sách voucher từ Firebase
  Future<void> _loadVouchers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Sử dụng Stream để lấy danh sách voucher có thể sử dụng
      _voucherController.getAvailableVouchers().listen((vouchers) {
        if (mounted) {
          setState(() {
            _vouchers = vouchers;
            _isLoading = false;
          });
        }
      }, onError: (error) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          print('Error loading vouchers: $error');
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print('Error initializing voucher stream: $e');
      }
    }
  }

  // Chọn voucher
  void _selectVoucher(String voucherId) {
    setState(() {
      _selectedVoucherId = voucherId;
    });
  }

  // Áp dụng voucher đã chọn
  void _applySelectedVoucher() {
    if (_selectedVoucherId != null) {
      // Tìm voucher được chọn từ danh sách
      final selectedVoucher =
          _vouchers.firstWhere((v) => v.id == _selectedVoucherId);

      // Trả về toàn bộ thông tin voucher cho màn hình gọi nó
      Navigator.pop(context, {
        'id': selectedVoucher.id,
        'code': selectedVoucher.code,
        'discountAmount': selectedVoucher.discountAmount,
        'shippingFee': _shippingFee,
        'taxRate': _taxRate,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height *
        0.7; // Giới hạn chiều cao tối đa là 70% màn hình

    return Container(
      width: double.maxFinite,
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.customBorderTL16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header với tiêu đề và nút đóng
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chọn mã giảm giá",
                  style: CustomTextStyles.titleMediumInterBluegray600,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: AppbarLeadingImage(
                    imagePath: ImageConstant.imgX,
                    height: 20.h,
                    width: 20.h,
                  ),
                ),
              ],
            ),
          ),

          // Body có thể cuộn
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _vouchers.isEmpty
                      ? Center(
                          child: Text(
                            "Không có voucher khả dụng",
                            style: CustomTextStyles.titleMediumInterBluegray600,
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.only(top: 8.h),
                          physics: BouncingScrollPhysics(),
                          itemCount: _vouchers.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            final voucher = _vouchers[index];
                            final isSelected = voucher.id == _selectedVoucherId;

                            return ListVoucherItem(
                              voucher: voucher,
                              isSelected: isSelected,
                              onTap: () => _selectVoucher(voucher.id),
                            );
                          },
                        ),
            ),
          ),

          // Button để áp dụng voucher
          if (_selectedVoucherId != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.h),
              child: ElevatedButton(
                onPressed: _applySelectedVoucher,
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.deepPurple500,
                  minimumSize: Size(double.infinity, 50.h),
                ),
                child: Text(
                  "Áp dụng voucher",
                  style: CustomTextStyles.labelLargeInterDeeppurple400.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
