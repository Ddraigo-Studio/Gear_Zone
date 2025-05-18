import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../controller/auth_controller.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import '../../core/utils/responsive.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController phoneInputController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Focus nodes để theo dõi trạng thái focus của các trường
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  // For image upload
  File? _selectedImage;
  bool isUploading = false;
  bool isLoadingData = false;
  String? userAvatarUrl;
  
  @override
  void initState() {
    super.initState();
    
    // Thêm listener để cập nhật UI khi trạng thái focus thay đổi
    _nameFocus.addListener(() {
      setState(() {});
    });
    _emailFocus.addListener(() {
      setState(() {});
    });
    _phoneFocus.addListener(() {
      setState(() {});
    });
      // Set loading state
    setState(() {
      isLoadingData = true;
    });
    
    // Load user data
    // Using addPostFrameCallback ensures that we load data after the first build cycle is complete
    // This avoids any potential issues with context not being fully available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = Provider.of<AuthController>(context, listen: false);
      print("AuthController state: isAuthenticated=${authController.isAuthenticated}, firebaseUser=${authController.firebaseUser?.uid}");
      
      if (authController.userModel != null) {
        print("Loading user data in initState: ${authController.userModel!.name}, ${authController.userModel!.email}");
        setState(() {
          nameInputController.text = authController.userModel!.name;
          emailInputController.text = authController.userModel!.email;
          phoneInputController.text = authController.userModel!.phoneNumber;
          userAvatarUrl = authController.userModel!.photoURL;
          isLoadingData = false;
        });
      } else {
        print("userModel is null in initState");
          // Try to force a refresh of user data if we have a firebase user but no userModel
        if (authController.firebaseUser != null) {
          authController.initAuth().then((_) {
            // Check if the widget is still mounted before updating state
            if (mounted) {
              if (authController.userModel != null) {
                print("User data loaded after initAuth: ${authController.userModel!.name}");
                setState(() {
                  nameInputController.text = authController.userModel!.name;
                  emailInputController.text = authController.userModel!.email;
                  phoneInputController.text = authController.userModel!.phoneNumber;
                  userAvatarUrl = authController.userModel!.photoURL;
                });
              }
              
              setState(() {
                isLoadingData = false;
              });
            }
          }).catchError((error) {
            print("Error loading user data: $error");
            if (mounted) {
              setState(() {
                isLoadingData = false;
              });
            }
          });
        } else {
          setState(() {
            isLoadingData = false;
          });
        }
      }
    });
  }


  @override
  void dispose() {
    // Giải phóng focus nodes khi widget bị hủy
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    nameInputController.dispose();
    emailInputController.dispose();
    phoneInputController.dispose();
    super.dispose();
  }
  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }
  // Function to capture image from camera
  Future<void> _captureImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80, // Chất lượng ảnh (1-100)
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      print('Error capturing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi khi chụp ảnh: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  // Function to show image source options dialog
  void _showImageSourceOptions() {
    final bool isDesktop = Responsive.isDesktop(context);
    
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isDesktop ? 24.h : 20.h),
        ),
      ),
      builder: (context) => Container(
        
        padding: EdgeInsets.all(24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Chọn nguồn ảnh",
              style: CustomTextStyles.bodyLargeBalooBhaijaanGray900.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: isDesktop ? 20.h : 18.h,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Camera option
                _buildImageSourceOption(
                  icon: Icons.camera_alt,
                  label: "Chụp ảnh",
                  onTap: () {
                    Navigator.pop(context);
                    _captureImage();
                  },
                ),
                
                // Gallery option
                _buildImageSourceOption(
                  icon: Icons.photo_library,
                  label: "Chọn từ thư viện",
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
  
  // Helper method to build image source option
  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final bool isDesktop = Responsive.isDesktop(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: isDesktop ? 70.h : 60.h,
            width: isDesktop ? 70.h : 60.h,
            decoration: BoxDecoration(
              color: appTheme.deepPurpleA200.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: appTheme.deepPurpleA200,
              size: isDesktop ? 32.h : 28.h,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            label,
            style: CustomTextStyles.bodyLargeBalooBhaijaanGray900,
          ),
        ],
      ),
    );
  }
    // Function to upload image to Firebase Storage
  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return userAvatarUrl;
    
    try {
      setState(() {
        isUploading = true;
      });
      
      final authController = Provider.of<AuthController>(context, listen: false);
      final userId = authController.firebaseUser?.uid;
      
      if (userId == null) {
        print('Cannot upload image: User ID is null');
        return null;
      }
      
      // Lấy tên file từ đường dẫn
      final fileName = path.basename(_selectedImage!.path);
      // Tạo đường dẫn đích trên Firebase Storage
      final destination = 'avatars/$userId/$fileName';
      
      // Tạo reference đến vị trí lưu trữ
      final ref = FirebaseStorage.instance.ref().child(destination);
      
      // Upload file
      print('Uploading image to Firebase Storage: $destination');
      await ref.putFile(_selectedImage!);
      
      // Lấy URL download
      final String downloadURL = await ref.getDownloadURL();
      print('Image uploaded successfully: $downloadURL');
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi khi tải ảnh lên: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }
  
  // Save profile data
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      isUploading = true;
    });
    
    try {
      final authController = Provider.of<AuthController>(context, listen: false);
      
      // Upload image if selected
      String? photoURL = userAvatarUrl;
      if (_selectedImage != null) {
        photoURL = await _uploadImage();
      }
      
      // Update profile
      final success = await authController.updateUserProfile(
        name: nameInputController.text.trim(),
        phoneNumber: phoneInputController.text.trim(),
        photoURL: photoURL,
      );
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thông tin đã được cập nhật thành công'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authController.error ?? 'Có lỗi xảy ra khi cập nhật thông tin'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    
    return Scaffold(
      resizeToAvoidBottomInset: true, 
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        bottom: false, 
        child: Form(
          key: _formKey,
          child: isLoadingData 
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: appTheme.deepPurpleA200,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Đang tải thông tin...",
                        style: CustomTextStyles.bodyLargeBalooBhaijaanGray900,
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: isDesktop 
                      ? Center(
                          child: Column(
                            children: [
                              _buildProfileHeader(context),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.h),
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 600.h),
                                  child: Column(
                                    children: [
                                      _buildNameInput(context),
                                      SizedBox(height: 26.h),
                                      _buildEmailInput(context),
                                      SizedBox(height: 26.h),
                                      _buildPhoneInput(context),
                                      SizedBox(height: 48.h),
                                      _buildSaveButton(context),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            _buildProfileHeader(context),
                            Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.all(16.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildNameInput(context),
                                  SizedBox(height: 26.h),
                                  _buildEmailInput(context),
                                  SizedBox(height: 26.h),
                                  _buildPhoneInput(context),
                                  SizedBox(height: 70.h),
                                  _buildSaveButton(context),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
        ),
      ),
    );
  }
  /// Profile Header Widget
  Widget _buildProfileHeader(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    
    return Container(
      width: double.maxFinite,
      height: isDesktop ? 400.h : 356.h,
      child: Stack(
        children: [
          // Background gradient image
          CustomImageView(
            imagePath: ImageConstant.imgBgEditProfile,
            width: double.maxFinite,
            height: isDesktop ? 400.h : 356.h,
            fit: BoxFit.contain,
          ),
            // AppBar được đặt ở đây, phía trên cùng
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.only(top: 16.h, left: 16.h, right: 16.h),
              child: Row(
                children: [
                  Container(
                    height: 48.h,
                    width: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: AppbarLeadingImage(
                        imagePath: ImageConstant.imgIconsaxBrokenArrowleft2,
                        height: 24.h,
                        width: 24.h,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.h, right: 48.h), // Để cân bằng với nút back
                        child: AppbarSubtitleTwo(
                          text: "Hồ sơ của tôi",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
            // Profile image
          Positioned(
            top: Responsive.isDesktop(context) ? 180.h : 150.h,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _showImageSourceOptions,
                child: Container(
                  height: Responsive.isDesktop(context) ? 140.h : 100.h,
                  width: Responsive.isDesktop(context) ? 140.h : 100.h,                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: Responsive.isDesktop(context) ? 4.h : 3.h,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Responsive.isDesktop(context) ? 80.h : 60.h),
                    child: _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            height: Responsive.isDesktop(context) ? 140.h : 100.h,
                            width: Responsive.isDesktop(context) ? 140.h : 100.h,
                            fit: BoxFit.cover,
                          )
                        : CustomImageView(
                            imagePath: userAvatarUrl ?? ImageConstant.imgProfile,
                            height: Responsive.isDesktop(context) ? 140.h : 100.h,
                            width: Responsive.isDesktop(context) ? 140.h : 100.h,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),
          ),            // Camera icon
          Positioned(
            top: Responsive.isDesktop(context) ? 280.h : 220.h,
            left: Responsive.isDesktop(context) 
                ? (MediaQuery.of(context).size.width / 2 + 40.h) 
                : (MediaQuery.of(context).size.width / 2 + 20.h),
            child: GestureDetector(
              onTap: () {
                _showImageSourceOptions();
              },
              child: Container(
                padding: Responsive.isDesktop(context) ? EdgeInsets.all(12.h) : EdgeInsets.all(8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: appTheme.deepPurpleA200,
                  size: Responsive.isDesktop(context) ? 24.h : 20.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  /// Section Widget
  Widget _buildNameInput(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isDesktop ? 16.h : 12.h),
        border: Border.all(
          color: _nameFocus.hasFocus ? theme.colorScheme.primary : appTheme.gray50001,
          width: isDesktop ? 1.5.h : 1.h,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: isDesktop ? 6 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: nameInputController,
        focusNode: _nameFocus,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập họ tên';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "Nhập họ tên",
          hintStyle: CustomTextStyles.bodyLargeBalooBhaijaanGray700,
          errorStyle: CustomTextStyles.bodyLargeBalooBhaijaanGray700.copyWith(color: Colors.red, fontSize: 12.h),
          prefixIcon: Padding(
            padding: EdgeInsets.all(14.h),
            child: Icon(
              Icons.person_outline,
              size: 24.h,
              color: _nameFocus.hasFocus ? theme.colorScheme.primary : appTheme.gray50001,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.h),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
        style: CustomTextStyles.bodyLargeBalooBhaijaanGray900,
      ),
    );
  }
  
  /// Section Widget
  Widget _buildEmailInput(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final primaryColor = theme.colorScheme.primary;
    final grayColor = appTheme.gray50001;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isDesktop ? 16.h : 12.h),
        border: Border.all(
          color: _emailFocus.hasFocus ? primaryColor : grayColor,
          width: isDesktop ? 1.5.h : 1.h,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: emailInputController,
        focusNode: _emailFocus,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập email';
          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Email không hợp lệ';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "Nhập email",
          hintStyle: CustomTextStyles.bodyLargeBalooBhaijaanGray700,
          errorStyle: CustomTextStyles.bodyLargeBalooBhaijaanGray700.copyWith(color: Colors.red, fontSize: 12.h),
          prefixIcon: Padding(
            padding: EdgeInsets.all(14.h),
            child: Icon(
              Icons.email_outlined,
              size: 24.h,
              color: _emailFocus.hasFocus ? theme.colorScheme.primary : appTheme.gray50001,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.h),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
        style: CustomTextStyles.bodyLargeBalooBhaijaanGray900,
      ),
    );
  }
  /// Section Widget
  Widget _buildPhoneInput(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isDesktop ? 16.h : 12.h),
        border: Border.all(
          color: _phoneFocus.hasFocus ? theme.colorScheme.primary : appTheme.gray50001,
          width: isDesktop ? 1.5.h : 1.h,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: phoneInputController,
        focusNode: _phoneFocus,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập số điện thoại';
          } else if (!RegExp(r'^\d{3}-\d{3}-\d{4}$').hasMatch(value) && 
                    !RegExp(r'^\d{10}$').hasMatch(value)) {
            return 'Số điện thoại không hợp lệ';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "Số điện thoại",
          hintStyle: CustomTextStyles.bodyLargeBalooBhaijaanGray700,
          errorStyle: CustomTextStyles.bodyLargeBalooBhaijaanGray700.copyWith(color: Colors.red, fontSize: 12.h),
          prefixIcon: Padding(
            padding: EdgeInsets.all(14.h),
            child: Icon(
              Icons.phone_outlined,
              size: 24.h,
              color: _phoneFocus.hasFocus ? theme.colorScheme.primary : appTheme.gray50001,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.h),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
        style: CustomTextStyles.bodyLargeBalooBhaijaanGray900,
      ),
    );
  }
  
  /// Section Widget
  Widget _buildSaveButton(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    
    return Container(
      height: isDesktop ? 54.h : 44.h,
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 8.h),
      width: isDesktop ? 180.h : double.infinity,
      child: ElevatedButton(        onPressed: isUploading ? null : () {
          _saveProfile();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isUploading ? Colors.grey.shade300 : appTheme.deepPurpleA200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isDesktop ? 28.h : 22.h),
          ),
        ),
        child: isUploading 
          ? SizedBox(
              width: 20.h,
              height: 20.h,
              child: CircularProgressIndicator(
                color: appTheme.whiteA700,
                strokeWidth: 2.h,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.save_alt,
                  color: appTheme.whiteA700,
                  size: 20.h,
                ),
                SizedBox(width: 12.h),
                Text(
                  "Lưu",
                  style: CustomTextStyles.bodyLargeBalooBhaijaanWhiteA700,
                ),
              ],
            ),
      ),
    );
  }
}
