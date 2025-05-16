import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/responsive.dart';
import '../../controller/auth_controller.dart';
import 'package:provider/provider.dart';

class ChangePasswordBottomSheet extends StatelessWidget {
  const ChangePasswordBottomSheet({
    Key? key,
  }) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.h),
          topRight: Radius.circular(24.h),
        ),
      ),
      builder: (context) => ChangePasswordBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _ChangePasswordBottomSheetContent();
  }
}

class _ChangePasswordBottomSheetContent extends StatefulWidget {
  @override
  State<_ChangePasswordBottomSheetContent> createState() => _ChangePasswordBottomSheetContentState();
}

class _ChangePasswordBottomSheetContentState extends State<_ChangePasswordBottomSheetContent> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  
  // Brand color
  final Color brandColor = Color(0xFF894FC8);
  
  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  // Hàm xử lý đổi mật khẩu
  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final authController = Provider.of<AuthController>(context, listen: false);
    
    Navigator.pop(context); // Đóng bottom sheet trước
    
    final success = await authController.changePassword(
      // Nếu người dùng mới (mật khẩu tự động), không cần mật khẩu hiện tại
      authController.isUsingGeneratedPassword() ? "" : _currentPasswordController.text,
      _newPasswordController.text,
    );
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authController.successMessage!),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authController.error ?? "Đã xảy ra lỗi"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  
  // Xây dựng text field cho mật khẩu
  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscureText,
    required Function() onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.h,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF333333),
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: Colors.white,
            filled: true,
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Colors.grey.shade400,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: obscureText ? Colors.grey.shade400 : brandColor,
              ),
              onPressed: onToggleVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: brandColor,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.h),
          ),
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final authController = Provider.of<AuthController>(context);
    
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24.h,
        right: 24.h,
        top: 24.h,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            width: isDesktop ? 600.h : double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [                // Tiêu đề - Hiển thị tiêu đề phù hợp dựa trên trạng thái người dùng
                Center(
                  child: Text(
                    authController.isUsingGeneratedPassword() 
                      ? "Tạo mật khẩu mới" 
                      : "Đổi mật khẩu",
                    style: TextStyle(
                      fontSize: 24.h,
                      fontWeight: FontWeight.bold,
                      color: brandColor,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                  // Mật khẩu hiện tại - Chỉ hiển thị nếu không phải người dùng mới
                if (!authController.isUsingGeneratedPassword())
                  _buildPasswordField(
                    label: "Mật khẩu hiện tại",
                    hint: "Nhập mật khẩu hiện tại",
                    controller: _currentPasswordController,
                    obscureText: _obscureCurrentPassword,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu hiện tại';
                      }
                      return null;
                    },
                  ),
                if (!authController.isUsingGeneratedPassword())
                  SizedBox(height: 16.h),
                
                // Mật khẩu mới
                _buildPasswordField(
                  label: "Mật khẩu mới",
                  hint: "Nhập mật khẩu mới",
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu mới';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                
                // Xác nhận mật khẩu mới
                _buildPasswordField(
                  label: "Xác nhận mật khẩu mới",
                  hint: "Nhập lại mật khẩu mới",
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng xác nhận mật khẩu mới';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Mật khẩu xác nhận không khớp';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32.h),
                
                // Nút đổi mật khẩu
                Container(
                  width: double.infinity,
                  height: 55.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.h),
                    boxShadow: [
                      BoxShadow(
                        color: brandColor.withOpacity(0.35),
                        blurRadius: 12.h,
                        offset: Offset(0, 6.h),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: authController.isLoading 
                      ? null 
                      : _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.h),
                      ),
                    ),
                    child: authController.isLoading
                      ? CircularProgressIndicator(color: Colors.white)                      : Text(
                          authController.isUsingGeneratedPassword()
                            ? "Tạo mật khẩu mới"
                            : "Đổi mật khẩu",
                          style: TextStyle(
                            fontSize: 18.h,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                  ),
                ),
                
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
