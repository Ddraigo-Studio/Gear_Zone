import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gear_zone/core/app_provider.dart';
import 'package:gear_zone/controller/voucher_controller.dart';
import 'package:gear_zone/model/voucher.dart';
import 'package:intl/intl.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VoucherDetailScreen extends StatefulWidget {
  final bool isViewOnly;
  
  const VoucherDetailScreen({
    Key? key,
    this.isViewOnly = true,
  }) : super(key: key);

  @override
  _VoucherDetailScreenState createState() => _VoucherDetailScreenState();
}

class _VoucherDetailScreenState extends State<VoucherDetailScreen> {
  final VoucherController _voucherController = VoucherController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isNew = false;

  // Form controllers
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _discountPercentageController = TextEditingController();
  final TextEditingController _minimumOrderAmountController = TextEditingController();
  final TextEditingController _maximumDiscountAmountController = TextEditingController();
  DateTime _validFromDate = DateTime.now();
  DateTime _validToDate = DateTime.now().add(const Duration(days: 30));
  List<String> _applicableProducts = [];
  List<String> _paymentMethods = ['COD', 'Banking', 'Momo', 'ZaloPay', 'VNPay'];
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _loadVoucherData();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _discountPercentageController.dispose();
    _minimumOrderAmountController.dispose();
    _maximumDiscountAmountController.dispose();
    super.dispose();
  }

  Future<void> _loadVoucherData() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    if (appProvider.currentVoucherId.isEmpty) {
      // Đây là trường hợp thêm mới
      setState(() {
        _isNew = true;
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
    });

    try {
      final voucher = await _voucherController.getVoucherById(appProvider.currentVoucherId);
      if (voucher != null) {
        setState(() {
          _codeController.text = voucher.code;
          _discountPercentageController.text = voucher.discountPercentage.toString();
          _minimumOrderAmountController.text = voucher.minimumOrderAmount.toString();
          _maximumDiscountAmountController.text = voucher.maximumDiscountAmount.toString();
          _validFromDate = voucher.validFromDate;
          _validToDate = voucher.validToDate;
          _applicableProducts = voucher.applicableProducts;
          _paymentMethods = voucher.paymentMethods;
          _isActive = voucher.isActive;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Lỗi khi tải dữ liệu: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveVoucher() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      
      final voucher = Voucher(
        id: _isNew ? '' : appProvider.currentVoucherId,
        code: _codeController.text.trim(),
        discountPercentage: int.parse(_discountPercentageController.text),
        minimumOrderAmount: double.parse(_minimumOrderAmountController.text),
        maximumDiscountAmount: double.parse(_maximumDiscountAmountController.text),
        expirationDate: _validToDate,
        validFromDate: _validFromDate,
        validToDate: _validToDate,
        applicableProducts: _applicableProducts,
        paymentMethods: _paymentMethods,
        isActive: _isActive,
      );

      if (_isNew) {
        // Kiểm tra xem mã voucher đã tồn tại chưa
        bool codeExists = await _voucherController.isCodeExist(_codeController.text.trim());
        if (codeExists) {
          _showErrorSnackBar('Mã voucher đã tồn tại. Vui lòng chọn mã khác.');
          setState(() {
            _isLoading = false;
          });
          return;
        }

        final id = await _voucherController.createVoucher(voucher);
        appProvider.setCurrentVoucherId(id);
        appProvider.setReloadVoucherList(true);
        _showSuccessSnackBar('Đã tạo phiếu giảm giá mới.');
      } else {
        await _voucherController.updateVoucher(voucher);
        appProvider.setReloadVoucherList(true);
        _showSuccessSnackBar('Đã cập nhật phiếu giảm giá.');
      }

      // Trở về chế độ xem sau khi lưu
      if (!widget.isViewOnly) {
        appProvider.setCurrentScreen(AppScreen.voucherDetail, isViewOnly: true);
      }
    } catch (e) {
      _showErrorSnackBar('Lỗi khi lưu: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header and breadcrumb
                  _buildHeader(context),
                  const SizedBox(height: 24),

                  // Form content
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(isMobile ? 16 : 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thông tin phiếu giảm giá',
                              style: TextStyle(
                                fontSize: isMobile ? 16 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Form fields
                            isMobile
                                ? _buildMobileForm()
                                : _buildDesktopForm(),

                            const SizedBox(height: 32),

                            // Action buttons
                            if (!widget.isViewOnly) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      if (_isNew) {
                                        appProvider.setCurrentScreen(AppScreen.voucherList);
                                      } else {
                                        appProvider.setCurrentScreen(
                                          AppScreen.voucherDetail,
                                          isViewOnly: true,
                                        );
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                    ),
                                    child: Text('Hủy'),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: _saveVoucher,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                    ),
                                    child: Text(_isNew ? 'Tạo phiếu giảm giá' : 'Lưu thay đổi'),
                                  ),
                                ],
                              ),
                            ] else ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      appProvider.setCurrentScreen(AppScreen.voucherList);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                    ),
                                    child: const Text('Quay lại'),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      appProvider.setCurrentScreen(AppScreen.voucherDetail, isViewOnly: false);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                    ),
                                    child: const Text('Chỉnh sửa'),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                appProvider.setCurrentScreen(AppScreen.voucherList);
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            Text(
              _isNew
                  ? 'Thêm phiếu giảm giá'
                  : widget.isViewOnly
                      ? 'Chi tiết phiếu giảm giá'
                      : 'Chỉnh sửa phiếu giảm giá',
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (!_isNew && !isMobile) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  appProvider.setCurrentScreen(AppScreen.voucherList);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Danh sách phiếu giảm giá',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: Colors.grey[700],
              ),
              const SizedBox(width: 8),
              Text(
                _codeController.text.isEmpty ? 'Phiếu mới' : _codeController.text,
                style: TextStyle(
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildMobileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mã voucher
        TextFormField(
          controller: _codeController,
          decoration: const InputDecoration(
            labelText: 'Mã voucher *',
            hintText: 'Nhập mã voucher (VD: SUMMER2025)',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập mã voucher';
            }
            if (value.contains(' ')) {
              return 'Mã voucher không được chứa khoảng trắng';
            }
            return null;
          },
          enabled: !widget.isViewOnly,
          readOnly: _isNew ? false : !_isNew && widget.isViewOnly,
        ),
        const SizedBox(height: 16),

        // Phần trăm giảm giá
        TextFormField(
          controller: _discountPercentageController,
          decoration: const InputDecoration(
            labelText: 'Phần trăm giảm giá (%) *',
            hintText: 'Nhập phần trăm giảm giá (VD: 10)',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập phần trăm giảm giá';
            }
            int? percentage = int.tryParse(value);
            if (percentage == null) {
              return 'Vui lòng nhập số nguyên';
            }
            if (percentage <= 0 || percentage > 100) {
              return 'Phần trăm giảm giá phải từ 1% đến 100%';
            }
            return null;
          },
          keyboardType: TextInputType.number,
          enabled: !widget.isViewOnly,
        ),
        const SizedBox(height: 16),

        // Giá trị đơn hàng tối thiểu
        TextFormField(
          controller: _minimumOrderAmountController,
          decoration: const InputDecoration(
            labelText: 'Giá trị đơn hàng tối thiểu (đ) *',
            hintText: 'Nhập giá trị đơn hàng tối thiểu (VD: 100000)',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập giá trị đơn hàng tối thiểu';
            }
            double? amount = double.tryParse(value);
            if (amount == null) {
              return 'Vui lòng nhập số';
            }
            if (amount < 0) {
              return 'Giá trị không được nhỏ hơn 0';
            }
            return null;
          },
          keyboardType: TextInputType.number,
          enabled: !widget.isViewOnly,
        ),
        const SizedBox(height: 16),

        // Số tiền giảm tối đa
        TextFormField(
          controller: _maximumDiscountAmountController,
          decoration: const InputDecoration(
            labelText: 'Số tiền giảm tối đa (đ) *',
            hintText: 'Nhập số tiền giảm tối đa (VD: 50000)',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập số tiền giảm tối đa';
            }
            double? amount = double.tryParse(value);
            if (amount == null) {
              return 'Vui lòng nhập số';
            }
            if (amount <= 0) {
              return 'Giá trị phải lớn hơn 0';
            }
            return null;
          },
          keyboardType: TextInputType.number,
          enabled: !widget.isViewOnly,
        ),
        const SizedBox(height: 16),

        // Thời gian hiệu lực
        Text(
          'Thời gian hiệu lực *',
          style: TextStyle(
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: widget.isViewOnly
                    ? null
                    : () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _validFromDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null && picked != _validFromDate) {
                          setState(() {
                            _validFromDate = picked;
                            if (_validFromDate.isAfter(_validToDate)) {
                              _validToDate = _validFromDate.add(const Duration(days: 1));
                            }
                          });
                        }
                      },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Text(DateFormat('dd/MM/yyyy').format(_validFromDate)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Text('đến'),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: widget.isViewOnly
                    ? null
                    : () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _validToDate,
                          firstDate: _validFromDate,
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null && picked != _validToDate) {
                          setState(() {
                            _validToDate = picked;
                          });
                        }
                      },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Text(DateFormat('dd/MM/yyyy').format(_validToDate)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Trạng thái
        Row(
          children: [
            Switch(
              value: _isActive,
              onChanged: widget.isViewOnly ? null : (value) {
                setState(() {
                  _isActive = value;
                });
              },
              activeColor: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              'Kích hoạt phiếu giảm giá',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Phương thức thanh toán áp dụng
        Text(
          'Phương thức thanh toán áp dụng',
          style: TextStyle(
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPaymentMethodChip('COD', 'Tiền mặt'),
            _buildPaymentMethodChip('Banking', 'Chuyển khoản'),
            _buildPaymentMethodChip('Momo', 'Momo'),
            _buildPaymentMethodChip('ZaloPay', 'ZaloPay'),
            _buildPaymentMethodChip('VNPay', 'VNPay'),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Mã voucher và Phần trăm giảm giá
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Mã voucher *',
                  hintText: 'Nhập mã voucher (VD: SUMMER2025)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã voucher';
                  }
                  if (value.contains(' ')) {
                    return 'Mã voucher không được chứa khoảng trắng';
                  }
                  return null;
                },
                enabled: !widget.isViewOnly,
                readOnly: _isNew ? false : !_isNew && widget.isViewOnly,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _discountPercentageController,
                decoration: const InputDecoration(
                  labelText: 'Phần trăm giảm giá (%) *',
                  hintText: 'Nhập phần trăm giảm giá (VD: 10)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập phần trăm giảm giá';
                  }
                  int? percentage = int.tryParse(value);
                  if (percentage == null) {
                    return 'Vui lòng nhập số nguyên';
                  }
                  if (percentage <= 0 || percentage > 100) {
                    return 'Phần trăm giảm giá phải từ 1% đến 100%';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                enabled: !widget.isViewOnly,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Row 2: Giá trị đơn hàng tối thiểu và Số tiền giảm tối đa
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _minimumOrderAmountController,
                decoration: const InputDecoration(
                  labelText: 'Giá trị đơn hàng tối thiểu (đ) *',
                  hintText: 'Nhập giá trị đơn hàng tối thiểu (VD: 100000)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giá trị đơn hàng tối thiểu';
                  }
                  double? amount = double.tryParse(value);
                  if (amount == null) {
                    return 'Vui lòng nhập số';
                  }
                  if (amount < 0) {
                    return 'Giá trị không được nhỏ hơn 0';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                enabled: !widget.isViewOnly,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _maximumDiscountAmountController,
                decoration: const InputDecoration(
                  labelText: 'Số tiền giảm tối đa (đ) *',
                  hintText: 'Nhập số tiền giảm tối đa (VD: 50000)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tiền giảm tối đa';
                  }
                  double? amount = double.tryParse(value);
                  if (amount == null) {
                    return 'Vui lòng nhập số';
                  }
                  if (amount <= 0) {
                    return 'Giá trị phải lớn hơn 0';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                enabled: !widget.isViewOnly,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Row 3: Thời gian hiệu lực
        Text(
          'Thời gian hiệu lực *',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: widget.isViewOnly
                    ? null
                    : () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _validFromDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null && picked != _validFromDate) {
                          setState(() {
                            _validFromDate = picked;
                            if (_validFromDate.isAfter(_validToDate)) {
                              _validToDate = _validFromDate.add(const Duration(days: 1));
                            }
                          });
                        }
                      },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Text(DateFormat('dd/MM/yyyy').format(_validFromDate)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Text('đến'),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: widget.isViewOnly
                    ? null
                    : () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _validToDate,
                          firstDate: _validFromDate,
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null && picked != _validToDate) {
                          setState(() {
                            _validToDate = picked;
                          });
                        }
                      },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Text(DateFormat('dd/MM/yyyy').format(_validToDate)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Row 4: Trạng thái
        Row(
          children: [
            Switch(
              value: _isActive,
              onChanged: widget.isViewOnly ? null : (value) {
                setState(() {
                  _isActive = value;
                });
              },
              activeColor: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              'Kích hoạt phiếu giảm giá',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Row 5: Phương thức thanh toán áp dụng
        Text(
          'Phương thức thanh toán áp dụng',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPaymentMethodChip('COD', 'Tiền mặt'),
            _buildPaymentMethodChip('Banking', 'Chuyển khoản'),
            _buildPaymentMethodChip('Momo', 'Momo'),
            _buildPaymentMethodChip('ZaloPay', 'ZaloPay'),
            _buildPaymentMethodChip('VNPay', 'VNPay'),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethodChip(String value, String label) {
    final bool isSelected = _paymentMethods.contains(value);

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: widget.isViewOnly
          ? null
          : (selected) {
              setState(() {
                if (selected) {
                  _paymentMethods.add(value);
                } else {
                  _paymentMethods.remove(value);
                }
              });
            },
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.1),
      checkmarkColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).primaryColor : Colors.black,
      ),
    );
  }
}
