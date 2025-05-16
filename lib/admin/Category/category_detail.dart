import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gear_zone/core/app_export.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../controller/category_controller.dart';
import '../../../model/category.dart';
import '../../../widgets/custom_image_view.dart';
import 'package:provider/provider.dart';
import '../../../core/app_provider.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import '../../../widgets/admin_widgets/breadcrumb.dart';

class CategoryDetail extends StatefulWidget {
  final String categoryId;
  final bool isViewOnly;

  const CategoryDetail({
    super.key,
    required this.categoryId,
    this.isViewOnly = false,
  });

  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  final _formKey = GlobalKey<FormState>();
  final CategoryController _categoryController = CategoryController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  bool _isLoading = true;
  String _errorMessage = '';
  CategoryModel? _category;
  File? _imageFile;
  bool _isUploading = false;
  String _uploadProgress = '';

  // Toggle between file upload and URL
  bool _isUrlInput = false;

  @override
  void initState() {
    super.initState();
    _loadCategory();
  }

  // Input decoration for form fields
  InputDecoration _getInputDecoration({
    required String hintText,
    bool isDense = true,
    EdgeInsetsGeometry? contentPadding,
    bool hasValue = false,
    bool enabled = true,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(
          color: hasValue ? Colors.grey.shade600 : Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(
          color: hasValue ? Colors.grey.shade600 : Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.5,
        ),
      ),
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      isDense: isDense,
      enabled: enabled,
    );
  }

  Future<void> _loadCategory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final category =
          await _categoryController.getCategoryById(widget.categoryId);
      if (category == null) {
        setState(() {
          _errorMessage = 'Không tìm thấy danh mục';
          _isLoading = false;
        });
        return;
      }
      setState(() {
        _category = category;
        _idController.text = category.id;
        _nameController.text = category.categoryName;
        _imageUrlController.text = category.imagePath;
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
    if (widget.isViewOnly) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _imageUrlController.text = ''; // Xóa URL ảnh cũ nếu chọn ảnh mới
      });
    }
  }

  // Phương thức để xóa ảnh
  void _removeImage() {
    if (widget.isViewOnly) return;

    setState(() {
      _imageFile = null;
      _imageUrlController.text = '';
    });
  }

  Future<String?> _uploadImage() async {
    if (_isUrlInput && _imageUrlController.text.isNotEmpty) {
      return _imageUrlController.text;
    }

    if (_imageFile == null && _imageUrlController.text.isEmpty) {
      // Giữ nguyên đường dẫn cũ nếu có
      return _category?.imagePath ?? '';
    }

    if (_imageFile == null) {
      return _imageUrlController.text;
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
    if (widget.isViewOnly) return;

    // Validate the form
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Hiển thị dialog loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Đang lưu dữ liệu..."),
                ],
              ),
            ),
          );
        },
      );

      // Upload ảnh (nếu có)
      final imageUrl = await _uploadImage();

      if (_errorMessage.isNotEmpty) {
        setState(() {
          _isLoading = false;
        });

        // Đóng dialog loading
        Navigator.pop(context);
        return;
      } // Cập nhật danh mục
      final updatedCategory = CategoryModel(
        id: _category!.id,
        categoryName: _nameController.text.trim(),
        imagePath: imageUrl ?? _category!.imagePath,
        ceatedAt: _category!.ceatedAt,
      );

      // Lưu danh mục
      final success = await _categoryController.updateCategory(updatedCategory);

      // Đóng dialog loading
      Navigator.pop(context);

      if (!success) {
        setState(() {
          _errorMessage = 'Không thể cập nhật danh mục';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _category = updatedCategory;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật danh mục thành công'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Đóng dialog loading nếu có lỗi
      Navigator.pop(context);

      setState(() {
        _errorMessage = 'Lỗi khi cập nhật danh mục: $e';
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteCategory() async {
    if (widget.isViewOnly) return;

    // Hiển thị dialog xác nhận xóa
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa danh mục này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Hiển thị dialog loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Đang xóa danh mục..."),
                ],
              ),
            ),
          );
        },
      );

      // Xóa danh mục
      final success = await _categoryController.deleteCategory(_category!.id);

      // Đóng dialog loading
      Navigator.pop(context);

      if (!success) {
        setState(() {
          _errorMessage = 'Không thể xóa danh mục';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Xóa danh mục thành công'),
          backgroundColor: Colors.green,
        ),
      );      // Trở về màn hình danh sách
      if (mounted) {
        final appProvider = Provider.of<AppProvider>(context, listen: false);
        appProvider.setCurrentCategoryId('');
        // Đặt cờ tải lại danh sách thành true trước khi chuyển màn hình
        appProvider.setReloadCategoryList(true);
        appProvider.setCurrentScreen(AppScreen.categoryList);
      }
    } catch (e) {
      // Đóng dialog loading nếu có lỗi
      Navigator.pop(context);

      setState(() {
        _errorMessage = 'Lỗi khi xóa danh mục: $e';
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty && _category == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 60, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<AppProvider>(context, listen: false)
                              .setCurrentCategoryId('');
                          Provider.of<AppProvider>(context, listen: false)
                              .setCurrentScreen(AppScreen.categoryList);
                        },
                        child: const Text('Quay lại danh sách'),
                      ),
                    ],
                  ),
                )
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and breadcrumb
                        Text(
                          widget.isViewOnly
                              ? 'Chi tiết danh mục: ${_category?.categoryName}'
                              : 'Chỉnh sửa danh mục: ${_category?.categoryName}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),                        
                        Breadcrumb(
                          items: [
                            BreadcrumbBuilder.dashboard(context),
                            BreadcrumbBuilder.categories(context),
                            BreadcrumbBuilder.categoryDetail(context, _category?.categoryName ?? 'Chi tiết'),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Error message
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
                                const Icon(Icons.error_outline,
                                    color: Colors.red),
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

                        // Main content - responsive layout
                        isMobile
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildCategoryInfoCard(),
                                  const SizedBox(height: 20),
                                  _buildCategoryImageCard(),
                                  const SizedBox(height: 20),
                                  _buildActionButtons(),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Main form - Left panel
                                  Expanded(
                                    flex: 1,
                                    child: _buildCategoryInfoCard(),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        _buildCategoryImageCard(),
                                        const SizedBox(height: 20),
                                        _buildActionButtons(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
    );
  }

  // Category information card
  Widget _buildCategoryInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
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
                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(
                    hintText: 'Nhập mã danh mục',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  enabled: false, // ID không thể thay đổi
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
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Nhập tên sản phẩm',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên danh mục';
                    }
                    return null;
                  },
                  enabled: !widget.isViewOnly,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Category image card
  Widget _buildCategoryImageCard() {
    final isMobile = Responsive.isMobile(context);
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hình ảnh danh mục',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (!widget.isViewOnly)
                  // Toggle between URL and file upload
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: 
                          SegmentedButton<bool>(
                            segments: const [
                              ButtonSegment<bool>(
                                value: false,
                                label: Text('Tải lên'),
                              ),
                              ButtonSegment<bool>(
                                value: true,
                                label: Text('URL'),
                              ),
                            ],
                            selected: {_isUrlInput},
                            onSelectionChanged: (newSelection) {
                              setState(() {
                                _isUrlInput = newSelection.first;
                              });
                            },
                          ),
                        
                      ),
                    ],
                  ),
              ],
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
            
            const SizedBox(height: 20),            // URL input or file upload based on toggle and view mode
            if (_isUrlInput && !widget.isViewOnly)
              // Text field for URL input
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  hintText: 'Nhập URL hình ảnh',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  fillColor: Colors.white,
                  filled: true,
                ),
                enabled: !widget.isViewOnly,
              )
            else
              // Container for image display/upload
              Container(
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
                child: widget.isViewOnly
                    // View-only mode
                    ? (_category?.imagePath.isNotEmpty == true
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomImageView(
                              key: ValueKey('category_image_${DateTime.now().millisecondsSinceEpoch}'),
                              imagePath: _category!.imagePath,
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
                                'Không có hình ảnh',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ))
                    // Edit mode
                    : InkWell(
                        onTap: _pickImage,
                        child: _imageFile != null
                            // Show existing category image or placeholder                                  : _category?.imagePath.isNotEmpty == true
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CustomImageView(
                                          key: ValueKey('category_image_${DateTime.now().millisecondsSinceEpoch}'),
                                          imagePath: _category!.imagePath,
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.black.withOpacity(0.6),
                                          child: IconButton(
                                            icon: const Icon(
                                                Icons.close,
                                                size: 16,
                                                color: Colors.white),
                                            onPressed: _removeImage,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: isMobile ? 36 : 48,
                                  color: Colors.deepPurple.shade200,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Ảnh danh mục',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                if (!widget.isViewOnly)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Nhấn để tải lên',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  // Action buttons
  Widget _buildActionButtons() {
    return Visibility(
      visible: !widget.isViewOnly,
      child: Row(
        spacing: 24.h,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 40.h, // Đặt chiều cao cố định cho nút
            child: OutlinedButton.icon(
              onPressed: _deleteCategory,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: const Text(
                'Xóa danh mục',
                style: TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                minimumSize: const Size(120, 48), // Đặt kích thước tối thiểu
              ),
            ),
          ),
          SizedBox(
            height: 40.h, // Đặt chiều cao cố định cho nút
            child: ElevatedButton.icon(
              onPressed: _saveCategory,
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text('Lưu thay đổi'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                minimumSize: const Size(120, 48), // Đặt kích thước tối thiểu
              ),
            ),
          ),
        ],
      ),
    );
  }
}
