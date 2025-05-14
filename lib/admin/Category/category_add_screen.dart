import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../controller/category_controller.dart';
import '../../../model/category.dart';
import '../../../widgets/custom_image_view.dart';
import 'package:provider/provider.dart';
import '../../../core/app_provider.dart';

class CategoryAddScreen extends StatefulWidget {
  const CategoryAddScreen({Key? key}) : super(key: key);

  @override
  State<CategoryAddScreen> createState() => _CategoryAddScreenState();
}

class _CategoryAddScreenState extends State<CategoryAddScreen> {
  final CategoryController _categoryController = CategoryController();
  final TextEditingController _nameController = TextEditingController();
  
  String _errorMessage = '';
  File? _imageFile;
  bool _isUploading = false;
  bool _isLoading = false;
  String _uploadProgress = '';

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
        final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
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
      final addedCategoryId = await _categoryController.addCategory(newCategory);
      
      if (addedCategoryId == null) {
        setState(() {
          _errorMessage = 'Không thể thêm danh mục';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _isLoading = false;
      });      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm danh mục thành công')),
      );
      
      // Trở về màn hình danh sách
      if (mounted) {
        Provider.of<AppProvider>(context, listen: false).setCurrentScreen(3);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm danh mục mới'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<AppProvider>(context, listen: false).setCurrentScreen(3);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveCategory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_errorMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Ảnh danh mục
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _imageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _imageFile!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 80,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.photo_camera),
                          label: const Text('Chọn ảnh'),
                        ),
                        if (_isUploading)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('Đang tải lên: $_uploadProgress'),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Tên danh mục
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Tên danh mục',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Nút lưu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveCategory,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Lưu danh mục',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
