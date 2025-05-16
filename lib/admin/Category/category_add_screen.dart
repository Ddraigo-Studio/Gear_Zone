import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../controller/category_controller.dart';
import '../../../model/category.dart';
import '../../../widgets/custom_image_view.dart';
import 'package:provider/provider.dart';
import '../../../core/app_provider.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../widgets/admin_widgets/breadcrumb.dart';

class CategoryAddScreen extends StatefulWidget {
  const CategoryAddScreen({super.key});

  @override
  State<CategoryAddScreen> createState() => _CategoryAddScreenState();
}

class _CategoryAddScreenState extends State<CategoryAddScreen> {
  final CategoryController _categoryController = CategoryController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _errorMessage = '';
  File? _imageFile;
  bool _isUploading = false;
  bool _isLoading = false;
  String _uploadProgress = '';

  // Toggle between file upload and URL


  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) {
      // Nếu không có ảnh được chọn
      return '';
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = '0%';
    });

    try {
      // Tạo một ID ngẫu nhiên cho file ảnh
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('category_images')
          .child('${fileName}.jpg');

      final uploadTask = storageRef.putFile(_imageFile!);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        setState(() {
          _uploadProgress = '${progress.toStringAsFixed(0)}%';
        });
      });

      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        _isUploading = false;
      });

      return downloadUrl;
    } catch (e) {
      setState(() {
        _isUploading = false;
        _errorMessage = 'Lỗi khi tải ảnh lên: $e';
      });
      return null;
    }
  }

  Future<void> _saveCategory() async {
    // Kiểm tra tên danh mục
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên danh mục')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Upload ảnh (nếu có)
      final imageUrl = await _uploadImage();

      if (_errorMessage.isNotEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Tạo một ID mới cho danh mục
      final String categoryId = '';

      // Tạo danh mục mới
      final CategoryModel newCategory = CategoryModel(
        id: categoryId,
        categoryName: _nameController.text.trim(),
        imagePath: imageUrl ?? '',
        ceatedAt: DateTime.now().toIso8601String(),
      );

      // Lưu danh mục mới
      final addedCategoryId =
          await _categoryController.addCategory(newCategory);

      if (addedCategoryId == null) {
        setState(() {
          _errorMessage = 'Không thể thêm danh mục';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm danh mục thành công')),
      );      // Trở về màn hình danh sách
      if (mounted) {
        Provider.of<AppProvider>(context, listen: false).setCurrentScreen(AppScreen.categoryList);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi thêm danh mục: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Breadcrumb navigation
                    Breadcrumb(
                      items: [
                        BreadcrumbBuilder.dashboard(context),
                        BreadcrumbBuilder.categories(context),
                        BreadcrumbItem(
                          title: 'Thêm danh mục mới',
                          isActive: true,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    // Title for mobile view
                    if (isMobile)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Thêm danh mục mới',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    
                    // Content layout - Row for desktop/tablet, Column for mobile
                    isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCategoryInfoCard(context),
                              const SizedBox(height: 20),
                              _buildImageUploadCard(context),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 1, child: _buildCategoryInfoCard(context)),
                              const SizedBox(width: 20),
                              Expanded(flex: 1, child: _buildImageUploadCard(context)),
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  // Category information card
  Widget _buildCategoryInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin danh mục',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // Mã danh mục
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mã danh mục',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    hintText: 'Nhập mã danh mục',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: Colors.grey.shade300),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tên danh mục
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tên danh mục',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Nhập tên sản phẩm',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: Colors.grey.shade300),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Image upload card
  Widget _buildImageUploadCard(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hình ảnh danh mục',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Chú ý:',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Định dạng ảnh SVG, PNG, or JPG (kích cỡ tối đa 4mb)',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Image upload area
            InkWell(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: isMobile ? 200 : 300,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue.shade200,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageView(
                          imagePath: _imageFile!.path,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: isMobile ? 36 : 48,
                            color: Colors.deepPurple.shade200,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Ảnh',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            if (_isUploading)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: LinearProgressIndicator(
                  value: double.parse(_uploadProgress.replaceAll('%', '')) / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
              ),

            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<AppProvider>(context, listen: false)
                          .setCurrentScreen(AppScreen.categoryList);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text('Hủy'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveCategory,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text('Lưu thay đổi'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
