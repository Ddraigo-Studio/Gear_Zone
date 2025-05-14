import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../controller/category_controller.dart';
import '../../../model/category.dart';
import '../../../widgets/custom_image_view.dart';
import 'package:provider/provider.dart';
import '../../../core/app_provider.dart';

class CategoryDetail extends StatefulWidget {
  final String categoryId;
  final bool isViewOnly;

  const CategoryDetail({
    Key? key,
    required this.categoryId,
    this.isViewOnly = false,
  }) : super(key: key);

  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  final CategoryController _categoryController = CategoryController();
  final TextEditingController _nameController = TextEditingController();
  
  bool _isLoading = true;
  String _errorMessage = '';
  CategoryModel? _category;
  File? _imageFile;
  bool _isUploading = false;
  String _uploadProgress = '';

  @override
  void initState() {
    super.initState();
    _loadCategory();
  }

  Future<void> _loadCategory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final category = await _categoryController.getCategoryById(widget.categoryId);
      if (category == null) {
        setState(() {
          _errorMessage = 'Không tìm thấy danh mục';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _category = category;
        _nameController.text = category.categoryName;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tải dữ liệu: $e';
        _isLoading = false;
      });
    }
  }

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
      return _category?.imagePath; // Giữ nguyên ảnh cũ nếu không chọn ảnh mới
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = '0%';
    });
    
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('category_images')
          .child('${DateTime.now().millisecondsSinceEpoch}_${widget.categoryId}.jpg');
      
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

      // Cập nhật danh mục
      if (_category != null) {
        final updatedCategory = _category!.copyWith(
          categoryName: _nameController.text,
          imagePath: imageUrl ?? _category!.imagePath,
        );

        final success = await _categoryController.updateCategory(updatedCategory);
        
        if (!success) {
          setState(() {
            _errorMessage = 'Không thể cập nhật danh mục';
            _isLoading = false;
          });
          return;
        }        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật danh mục thành công')),
        );
        
        // Trở về màn hình danh sách
        if (mounted) {
          Provider.of<AppProvider>(context, listen: false).setCurrentScreen(3);
          Provider.of<AppProvider>(context, listen: false).setCurrentCategoryId('');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi lưu danh mục: $e';
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isViewOnly ? 'Chi tiết danh mục' : 'Chỉnh sửa danh mục'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<AppProvider>(context, listen: false).setCurrentScreen(3);
            Provider.of<AppProvider>(context, listen: false).setCurrentCategoryId('');
          },
        ),
        actions: [
          if (!widget.isViewOnly)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveCategory,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _buildCategoryForm(),
    );
  }

  Widget _buildCategoryForm() {
    if (_category == null) {
      return const Center(child: Text('Không có dữ liệu danh mục'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ID danh mục (chỉ đọc)
          Text(
            'ID: ${_category!.id}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          
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
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomImageView(
                            imagePath: _category!.imagePath.isNotEmpty
                                ? _category!.imagePath
                                : 'assets/images/img_logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(height: 8),
                if (!widget.isViewOnly)
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
            readOnly: widget.isViewOnly,
            decoration: InputDecoration(
              labelText: 'Tên danh mục',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Ngày tạo (chỉ đọc)
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Ngày tạo',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: _category!.ceatedAt,
            ),
          ),
        ],
      ),
    );
  }
}
