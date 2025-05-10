import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:gear_zone/controller/product_controller.dart';
import 'package:gear_zone/model/product.dart';
import 'package:image_picker/image_picker.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  ProductAddState createState() => ProductAddState();
}

class ProductAddState extends State<ProductAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _originalPriceController =
      TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  String? _selectedCategory;
  String? _selectedStatus;
  // Variables for image handling
  File? _mainImage;
  List<File> _additionalImages = [];
  bool _isUploadingImages = false;
  
  // Variables for image URLs
  String _mainImageUrl = '';
  List<String> _additionalImageUrls = List.filled(3, '');
  
  // Toggle between file upload and URL
  bool _isUrlInput = false;
  
  final TextEditingController _mainImageUrlController = TextEditingController();
  List<TextEditingController> _additionalImageUrlControllers = List.generate(3, (_) => TextEditingController());
  
  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập giá';
    }
    if (double.tryParse(value) == null) {
      return 'Giá phải là số';
    }
    if (double.parse(value) < 0) {
      return 'Giá không thể là số âm';
    }
    return null;
  }

  String? _validateDiscount(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Discount có thể trống
    }
    if (int.tryParse(value) == null) {
      return 'Chiết khấu phải là số nguyên';
    }
    int discount = int.parse(value);
    if (discount < 0 || discount > 100) {
      return 'Chiết khấu phải từ 0 đến 100%';
    }
    return null;
  }
  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số lượng';
    }
    if (int.tryParse(value) == null) {
      return 'Số lượng phải là số nguyên';
    }
    if (int.parse(value) < 0) {
      return 'Số lượng không thể là số âm';
    }
    return null;
  }

  // Khởi tạo controller
  final ProductController _productController = ProductController();
  
  // Phương thức để chọn ảnh từ thư viện
  Future<File?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      return File(image.path);
    }
    return null;
  }
  
  // Phương thức để chọn ảnh chính
  Future<void> _pickMainImage() async {
    final File? pickedImage = await _pickImage();
    if (pickedImage != null) {
      setState(() {
        _mainImage = pickedImage;
      });
    }
  }
  
  // Phương thức để chọn ảnh phụ
  Future<void> _pickAdditionalImage(int index) async {
    final File? pickedImage = await _pickImage();
    if (pickedImage != null) {
      setState(() {
        while (_additionalImages.length <= index) {
          _additionalImages.add(File(''));
        }
        _additionalImages[index] = pickedImage;
      });
    }
  }
  
  // Phương thức để upload tất cả ảnh và lấy URLs
  Future<Map<String, dynamic>> _uploadAllImages(String productId) async {
    String mainImageUrl = '';
    List<String> additionalImageUrls = [];
    
    setState(() {
      _isUploadingImages = true;
    });
    
    try {
      // Nếu người dùng chọn ảnh từ thiết bị
      if (!_isUrlInput) {
        // Upload ảnh chính
        if (_mainImage != null) {
          mainImageUrl = await _productController.uploadProductImage(
            _mainImage!, 
            productId, 
            isMainImage: true
          ) ?? '';
        }
        
        // Upload ảnh phụ
        for (int i = 0; i < _additionalImages.length; i++) {
          if (_additionalImages[i].path.isNotEmpty) {
            String? url = await _productController.uploadProductImage(
              _additionalImages[i], 
              productId, 
              isMainImage: false
            );
            if (url != null && url.isNotEmpty) {
              additionalImageUrls.add(url);
            }
          }
        }
      } else {
        // Nếu người dùng nhập URL
        mainImageUrl = _mainImageUrlController.text;
        
        for (var controller in _additionalImageUrlControllers) {
          if (controller.text.isNotEmpty) {
            additionalImageUrls.add(controller.text);
          }
        }
      }
    } finally {
      setState(() {
        _isUploadingImages = false;
      });
    }
    
    return {
      'mainImageUrl': mainImageUrl,
      'additionalImageUrls': additionalImageUrls
    };
  }

  // Phương thức xử lý khi nhấn nút lưu
  void _saveForm(BuildContext context) async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin bắt buộc'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Hiển thị loading indicator
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

      // Tạo đối tượng ProductModel từ dữ liệu form
      ProductModel product = ProductModel(
        id: _idController.text,
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        originalPrice: double.tryParse(_originalPriceController.text) ?? 0,
        imageUrl: '', // TODO: Cần thêm xử lý upload hình ảnh
        additionalImages: [], // TODO: Cần thêm xử lý upload nhiều hình ảnh
        category: _selectedCategory ?? 'laptop',
        brand: _brandController.text,
        seriNumber: _codeController.text,
        quantity: _quantityController.text,
        status: _selectedStatus ?? 'out_of_stock',
        inStock: _selectedStatus == 'available',
        discount: int.tryParse(_discountController.text) ?? 0,
      );      // Lưu sản phẩm vào Firestore (chưa có ảnh)
      String? productId;
      if (_idController.text.isEmpty) {
        productId = await _productController.addProduct(product);
      } else {
        productId = product.id;
      }
      
      // Upload hình ảnh và cập nhật URLs
      if (productId != null) {
        // Hiển thị trạng thái đang upload ảnh
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đang tải lên hình ảnh...'),
            duration: Duration(seconds: 1),
          ),
        );
        
        // Upload ảnh và lấy URL
        Map<String, dynamic> imageUrls = await _uploadAllImages(productId);
        
        // Cập nhật product model với URLs
        product.imageUrl = imageUrls['mainImageUrl'];
        product.additionalImages = imageUrls['additionalImageUrls'];
        
        // Cập nhật lại product vào Firestore
        await _productController.updateProduct(product);
      }

      // Đóng dialog loading
      Navigator.pop(context);

      if (productId != null) {
        // Nếu thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lưu sản phẩm thành công!'),
            backgroundColor: Colors.green,
          ),
        );

        // Cập nhật ID vào controller nếu đó là sản phẩm mới
        if (_idController.text.isEmpty) {
          _idController.text = productId;
        }
      } else {
        // Nếu thất bại
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lưu sản phẩm thất bại, vui lòng thử lại!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Đóng dialog loading nếu có lỗi
      Navigator.pop(context);

      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    // Add listeners to URL controllers to update the UI when they change
    _mainImageUrlController.addListener(_updateMainImageUrlPreview);
  }

  @override
  void dispose() {
    _mainImageUrlController.removeListener(_updateMainImageUrlPreview);
    _mainImageUrlController.dispose();
    for (var controller in _additionalImageUrlControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Update the main image URL preview when the text changes
  void _updateMainImageUrlPreview() {
    setState(() {
      _mainImageUrl = _mainImageUrlController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page title
            const Text(
              'Thêm ản phẩm mới',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Breadcrumb
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Bảng điều khiển',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Sản phẩm',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Laptop',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Product info and image sections
            isMobile
                ? Column(
                    children: [
                      _buildProductInfoSection(context),
                      const SizedBox(height: 16),
                      _buildProductImageSection(context),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildProductInfoSection(context),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: _buildProductImageSection(context),
                      ),
                    ],
                  ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Bỏ thay đổi',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => _saveForm(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7E3FF2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Lưu thay đổi',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfoSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin sản phẩm',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Thêm thông tin cơ bản về sản phẩm',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),

          // // ID sản phẩm
          // const Text(
          //   'ID sản phẩm',
          //   style: TextStyle(
          //     fontSize: 13,
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
          // const SizedBox(height: 6),
          // TextFormField(
          //   controller: _idController,
          //   decoration: InputDecoration(
          //     hintText: 'ID sản phẩm được tạo tự động',
          //     hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(4),
          //       borderSide: BorderSide(color: Colors.grey.shade300),
          //     ),
          //     contentPadding:
          //         const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          //     isDense: true,
          //     enabled: false,
          //   ),
          //   style: const TextStyle(fontSize: 13),
          // ),
          // const SizedBox(height: 12),

          // Mã sản phẩm (Seri)
          const Text(
            'Mã sản phẩm (Seri)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _codeController,
            decoration: InputDecoration(
              hintText: 'Nhập mã sản phẩm/seri (vd: LP001)',
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 13),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mã sản phẩm';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          // Tên sản phẩm
          const Text(
            'Tên sản phẩm',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Nhập tên sản phẩm',
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 13),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập tên sản phẩm';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          // Thương hiệu
          const Text(
            'Thương hiệu',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _brandController,
            decoration: InputDecoration(
              hintText: 'Nhập thương hiệu (vd: Dell, Asus...)',
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 13),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập thương hiệu';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          // Mô tả sản phẩm
          const Text(
            'Mô tả sản phẩm',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Nhập mô tả chi tiết về sản phẩm',
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            style: const TextStyle(fontSize: 13),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mô tả sản phẩm';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          // Category and Price in row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Danh mục sản phẩm',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      hint: Text('Chọn mục sản phẩm',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade400)),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, size: 20),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        isDense: true,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'laptop',
                          child: Text('Laptop', style: TextStyle(fontSize: 12)),
                        ),
                        DropdownMenuItem(
                          value: 'desktop',
                          child: Text('Máy tính bàn',
                              style: TextStyle(fontSize: 12)),
                        ),
                        DropdownMenuItem(
                          value: 'components',
                          child:
                              Text('Linh kiện', style: TextStyle(fontSize: 12)),
                        ),
                        DropdownMenuItem(
                          value: 'accessories',
                          child:
                              Text('Phụ kiện', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                      onChanged: (value) {
                        _selectedCategory = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng chọn danh mục sản phẩm';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trạng thái sản phẩm',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      hint: Text('Chọn trạng thái',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade400)),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, size: 20),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        isDense: true,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'available',
                          child: Text('Có sẵn', style: TextStyle(fontSize: 12)),
                        ),
                        DropdownMenuItem(
                          value: 'out_of_stock',
                          child:
                              Text('Hết hàng', style: TextStyle(fontSize: 12)),
                        ),
                        DropdownMenuItem(
                          value: 'discontinued',
                          child: Text('Ngừng kinh doanh',
                              style: TextStyle(fontSize: 12)),
                        ),
                      ],
                      onChanged: (value) {
                        _selectedStatus = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng chọn trạng thái sản phẩm';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              // Price
            ],
          ),
          const SizedBox(height: 12),

          // Original Price and Discount in row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Original Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Giá gốc',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _originalPriceController,
                      decoration: InputDecoration(
                        hintText: 'Nhập giá gốc (VNĐ)',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 13),
                      validator: _validatePrice,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Giá bán',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        hintText: 'Nhập giá bán (VNĐ)',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 13),
                      validator: _validatePrice,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Quantity and Status in row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Discount percentage
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chiết khấu (%)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _discountController,
                      decoration: InputDecoration(
                        hintText: 'Nhập % giảm giá',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 13),
                      validator: _validateDiscount,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Quantity
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Số lượng',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        hintText: 'Nhập số lượng',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 13),
                      validator: _validateQuantity,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Thông số kỹ thuật cơ bản section header
          const Text(
            'Thông số kỹ thuật',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Nhập thông số kỹ thuật chi tiết của sản phẩm',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),

          // CPU and RAM in row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CPU
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bộ vi xử lý (CPU)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vd: Intel Core i5-12500H',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // RAM
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bộ nhớ RAM',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vd: 16GB DDR4 3200MHz',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Storage and GPU in row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Storage
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lưu trữ',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vd: 512GB SSD NVMe',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // GPU
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Card đồ họa',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vd: NVIDIA RTX 4050 6GB',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Display and OS in row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Màn hình',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vd: 15.6" FHD IPS 144Hz',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // OS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hệ điều hành',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vd: Windows 11 Home',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Keyboard and Audio in row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Keyboard
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bàn phím',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vd: RGB Backlit keyboard',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Audio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Âm thanh',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vd: Stereo speakers, DTS',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // WiFi and Bluetooth in row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // WiFi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WiFi',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vd: Wi-Fi 6 (802.11ax)',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Bluetooth
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bluetooth',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vd: Bluetooth 5.2',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Battery and Weight in row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Battery
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pin',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vd: 4-cell, 54WHr',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Weight
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trọng lượng',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vd: 1.8 kg',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Color and Dimensions in row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Color
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Màu sắc',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vd: Đen, Bạc...',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Dimensions
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kích thước',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vd: 360 x 252 x 19.9 mm',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Webcam and Security in row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Webcam
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Webcam',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vd: HD 720p',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Security
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bảo mật',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vd: Vân tay, khuôn mặt',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Ports
          const Text(
            'Cổng kết nối',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Vd: 2x USB-C, 2x USB-A, 1x HDMI, 1x Audio Jack',
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 12),

          // Warranty
          const Text(
            'Bảo hành',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Vd: 24 tháng',
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 12),

          // Promotions
          const Text(
            'Khuyến mãi',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Vd: Balo, chuột không dây, PMH 200.000đ',
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
  Widget _buildProductImageSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hình ảnh sản phẩm',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              children: [
                const TextSpan(
                  text: 'Chú ý: ',
                  style: TextStyle(
                    color: Color(0xFF7E3FF2),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: 'Định dạng ảnh ',
                ),
                TextSpan(
                  text: 'PNG, or JPG (kích cỡ tối đa 4mb)',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          // Toggle button for image source
          Row(
            children: [
              Expanded(
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment<bool>(
                      value: false,
                      label: Text('Tải ảnh lên', style: TextStyle(fontSize: 12)),
                      icon: Icon(Icons.upload_file, size: 16),
                    ),
                    ButtonSegment<bool>(
                      value: true,
                      label: Text('Từ URL', style: TextStyle(fontSize: 12)),
                      icon: Icon(Icons.link, size: 16),
                    ),
                  ],
                  selected: {_isUrlInput},
                  onSelectionChanged: (Set<bool> newSelection) {
                    setState(() {
                      _isUrlInput = newSelection.first;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main product image
          _isUrlInput 
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'URL hình ảnh chính',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _mainImageUrlController,
                      decoration: InputDecoration(
                        hintText: 'Nhập URL hình ảnh chính',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 12),                    if (_mainImageUrl.isNotEmpty)
                      Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Image.network(
                          _mainImageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Icon(Icons.image_not_supported,
                                size: 40, color: Colors.grey),
                          ),
                        ),
                      ),
                  ],
                )              : _isUploadingImages
                ? Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text(
                            'Đang tải lên...',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : InkWell(
                    onTap: _pickMainImage,
                    child: Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: _mainImage != null 
                          ? Image.file(
                              _mainImage!,
                              fit: BoxFit.contain,
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 40,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Chọn ảnh chính',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
          const SizedBox(height: 12),

          // Additional images row
          _isUrlInput              ? Column(
                  children: List.generate(3, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'URL hình ảnh ${index + 2}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _additionalImageUrlControllers[index],
                          decoration: InputDecoration(
                            hintText: 'Nhập URL hình ảnh ${index + 2}',
                            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            isDense: true,
                          ),
                          style: const TextStyle(fontSize: 13),
                          onChanged: (value) {
                            setState(() {
                              _additionalImageUrls[index] = value;
                            });
                          },
                        ),
                        const SizedBox(height: 6),
                        if (_additionalImageUrls[index].isNotEmpty)
                          Container(
                            width: double.infinity,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Image.network(
                              _additionalImageUrls[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Center(
                                child: Icon(Icons.image_not_supported,
                                    size: 30, color: Colors.grey),
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }),
                )
              : Row(
                  children: List.generate(3, (index) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: index > 0 ? 12 : 0,
                        ),
                        child: _buildImageUploadBox(
                          context, 
                          'Ảnh ${index + 2}',
                          onTap: () => _pickAdditionalImage(index),
                          imageFile: _additionalImages.length > index ? _additionalImages[index] : null,
                        ),
                      ),
                    );
                  }),
                ),
        ],
      ),
    );
  }
  Widget _buildImageUploadBox(
    BuildContext context, 
    String label, 
    {Function()? onTap, File? imageFile}
  ) {
    return InkWell(
      onTap: onTap,
      child: DottedBorder(
        color: Colors.blue.shade200,
        strokeWidth: 1.5,
        dashPattern: [6, 3], // 6px line, 3px gap
        borderType: BorderType.RRect, // bo tròn
        radius: const Radius.circular(4),
        child: Container(
          height: 80,
          width: double.infinity,
          child: imageFile != null && imageFile.path.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 24,
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
