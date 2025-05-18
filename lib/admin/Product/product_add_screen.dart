import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:gear_zone/controller/product_controller.dart';
import 'package:gear_zone/controller/image_handling_controller.dart';
import 'package:gear_zone/controller/price_calculator.dart';
import 'package:gear_zone/controller/category_controller.dart';
import 'package:gear_zone/model/category.dart';
import 'package:gear_zone/model/product.dart';

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
  // Flags to prevent feedback loops during auto-calculation
  bool _isCalculatingPrice = false;
  bool _isCalculatingDiscount = false;

  String? _selectedCategory;
  List<CategoryModel> _categories = [];
  CategoryModel? _currentSelectedCategory;
  String? _selectedStatus;
  
  // Image handling controller
  final ImageHandlingController _imageController = ImageHandlingController();
  final ProductController _productController = ProductController();
  final CategoryController _categoryController = CategoryController();

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

  String? _validateSellingPrice(String? value) {
    final baseValidation = _validatePrice(value);
    if (baseValidation != null) {
      return baseValidation;
    }
    final originalPriceText = _originalPriceController.text;
    final sellingPriceText = _priceController.text;

    if (originalPriceText.isNotEmpty && sellingPriceText.isNotEmpty) {
      final originalPrice = double.tryParse(originalPriceText);
      final sellingPrice = double.tryParse(sellingPriceText);
      if (originalPrice != null && sellingPrice != null) {
        if (sellingPrice > originalPrice) {
          return 'Giá bán không được lớn hơn giá gốc';
        }
      }
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

  // Phương thức để chọn ảnh chính
  Future<void> _pickMainImage() async {
    await _imageController.pickMainImage();
    setState(() {}); // Trigger UI update
  }

  // Phương thức để chọn ảnh phụ
  Future<void> _pickAdditionalImage(int index) async {
    await _imageController.pickAdditionalImage(index);
    setState(() {}); // Trigger UI update
  }
  
  // Phương thức để xóa ảnh chính
  void _removeMainImage() {
    _imageController.removeMainImage();
    setState(() {}); // Trigger UI update
  }
  
  // Phương thức để xóa ảnh phụ
  void _removeAdditionalImage(int index) {
    _imageController.removeAdditionalImage(index);
    setState(() {}); // Trigger UI update
  }
  
  // Phương thức để thêm vị trí cho ảnh phụ

  void _addAdditionalImageSlot() {
    _imageController.addAdditionalImageSlot();
    setState(() {}); // Trigger UI update
  }
  
  // Phương thức để thêm controller cho URL ảnh phụ
  void _addAdditionalUrlController() {
    _imageController.addAdditionalUrlController();
    setState(() {}); // Trigger UI update
  }
  
  // Phương thức để xóa controller URL ảnh phụ
  void _removeAdditionalUrlController(int index) {
    _imageController.removeAdditionalUrlController(index);
    setState(() {}); // Trigger UI update
  }
  // Phương thức để upload tất cả ảnh và lấy URLs
  Future<Map<String, dynamic>> _uploadAllImages(String productId) async {
    return await _imageController.uploadAllImages(productId, context);
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
      );      // Tạo đối tượng ProductModel từ dữ liệu form
      ProductModel product = ProductModel(
        id: _idController.text,
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        originalPrice: double.tryParse(_originalPriceController.text) ?? 0,
        imageUrl: _mainImageUrl,
        additionalImages: _imageController.getNonEmptyAdditionalImageUrls(),
        category: _selectedCategory ?? 'laptop',
        brand: _brandController.text,
        seriNumber: _codeController.text,
        quantity: _quantityController.text,
        status: _selectedStatus ?? 'out_of_stock',
        inStock: _selectedStatus == 'available',
        discount: int.tryParse(_discountController.text) ?? 0,
      );// Lưu sản phẩm vào Firestore (chưa có ảnh)
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
    _loadCategories();
    _originalPriceController.addListener(() {
      _handleOriginalPriceOrDiscountChange();
      _handleOriginalPriceOrSellingPriceChange();
      // Trigger validation for selling price if original price changes
      if (_formKey.currentState != null && _priceController.text.isNotEmpty) {
        _formKey.currentState!.validate();
      }
    });
    _discountController.addListener(_handleOriginalPriceOrDiscountChange);
    _priceController.addListener(_handleOriginalPriceOrSellingPriceChange);
  }

  @override
  void dispose() {
    _originalPriceController.removeListener(_handleOriginalPriceOrDiscountChange);
    _originalPriceController.removeListener(_handleOriginalPriceOrSellingPriceChange);
    _discountController.removeListener(_handleOriginalPriceOrDiscountChange);
    _priceController.removeListener(_handleOriginalPriceOrSellingPriceChange);
    _imageController.dispose();
    super.dispose();
  }
  
  // Helper getters to access image controller properties
  File? get _mainImage => _imageController.mainImage;
  List<File> get _additionalImages => _imageController.additionalImages;
  String get _mainImageUrl => _imageController.mainImageUrl;
  List<String> get _additionalImageUrls => _imageController.additionalImageUrls;
  TextEditingController get _mainImageUrlController => _imageController.mainImageUrlController;
  List<TextEditingController> get _additionalImageUrlControllers => _imageController.additionalImageUrlControllers;
  bool get _isUrlInput => _imageController.isUrlInput;
  bool get _isUploadingImages => _imageController.isUploadingImages;
  
  // Helper setter to toggle URL input mode
  void _setUrlInputMode(bool value) {
    _imageController.toggleInputMode(value);
    setState(() {}); // Refresh UI
  }

  void _handleOriginalPriceOrDiscountChange() {
    if (_isCalculatingPrice) return;

    final originalPriceText = _originalPriceController.text;
    final discountText = _discountController.text;

    if (originalPriceText.isNotEmpty && discountText.isNotEmpty) {
      final originalPrice = double.tryParse(originalPriceText);
      final discount = int.tryParse(discountText);

      if (originalPrice != null && discount != null && discount >= 0 && discount <= 100) {
        _isCalculatingPrice = true;
        final sellingPrice = PriceCalculator.calculateSellingPrice(originalPrice, discount);
        _priceController.text = sellingPrice.toStringAsFixed(0); // Assuming price doesn't need decimals
        _isCalculatingPrice = false;
      }
    }
  }

  void _handleOriginalPriceOrSellingPriceChange() {
    if (_isCalculatingDiscount) return;

    final originalPriceText = _originalPriceController.text;
    final sellingPriceText = _priceController.text;

    if (originalPriceText.isNotEmpty && sellingPriceText.isNotEmpty) {
      final originalPrice = double.tryParse(originalPriceText);
      final sellingPrice = double.tryParse(sellingPriceText);

      if (originalPrice != null && sellingPrice != null && originalPrice > 0) {
         if (sellingPrice > originalPrice) {
          // Handled by validator, but ensure discount isn't calculated negatively
          _discountController.clear();
          return;
        }
        _isCalculatingDiscount = true;
        final discount = PriceCalculator.calculateDiscountPercent(originalPrice, sellingPrice);
        _discountController.text = discount.toString();
        _isCalculatingDiscount = false;
      }
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categoriesData = await _categoryController.getCategoriesPaginated();
      if (mounted) {
        setState(() {
          _categories = categoriesData['categories'] as List<CategoryModel>;
          if (_categories.isNotEmpty) {
            // Optionally set a default selected category or leave it null
            // _currentSelectedCategory = _categories.first;
            // _selectedCategory = _currentSelectedCategory?.name;
          }
        });
      }
    } catch (e) {
      // Handle error loading categories
      print('Error loading categories: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải danh mục: $e')),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Material(
      color: Color(0xffF6F6F6), // Matching the background color
      child: Form(
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
                    DropdownButtonFormField<CategoryModel>(
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
                      value: _currentSelectedCategory,
                      items: _categories.map((CategoryModel category) {
                        return DropdownMenuItem<CategoryModel>(
                          value: category,
                          child: Text(category.categoryName ?? 'N/A',
                              style: TextStyle(fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (CategoryModel? newValue) {
                        setState(() {
                          _currentSelectedCategory = newValue;
                          _selectedCategory = newValue?.categoryName;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
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
                      value: _selectedStatus,
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
                        setState(() {
                          _selectedStatus = value;
                        });
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
                      validator: _validateSellingPrice,
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
                      label:
                          Text('Tải ảnh lên', style: TextStyle(fontSize: 12)),
                      icon: Icon(Icons.upload_file, size: 16),
                    ),
                    ButtonSegment<bool>(
                      value: true,
                      label: Text('Từ URL', style: TextStyle(fontSize: 12)),
                      icon: Icon(Icons.link, size: 16),
                    ),
                  ],                  selected: {_isUrlInput},
                  onSelectionChanged: (Set<bool> newSelection) {
                    _setUrlInputMode(newSelection.first);
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
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    if (_mainImageUrl.isNotEmpty)
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
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(Icons.image_not_supported,
                                size: 40, color: Colors.grey),
                          ),
                        ),
                      ),
                  ],
                )
              : _isUploadingImages
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
          const SizedBox(height: 12),          // Additional images row
          _buildAdditionalImagesSection(),
        ],
      ),
    );
  }

  Widget _buildImageUploadBox(BuildContext context, String label,
      {Function()? onTap, File? imageFile}) {
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

  // Build additional image URL inputs
  Widget _buildAdditionalImageUrlInputs() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _additionalImageUrlControllers.length + 1,
      itemBuilder: (context, index) {
        if (index == _additionalImageUrlControllers.length) {
          // Button to add more URL inputs
          return TextButton.icon(
            onPressed: _addAdditionalUrlController,
            icon: const Icon(Icons.add_link, size: 18),
            label: const Text(
              'Thêm URL ảnh phụ',
              style: TextStyle(fontSize: 13),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
        
        // Text field for each additional image URL
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _additionalImageUrlControllers[index],
                    decoration: InputDecoration(
                      hintText: 'Nhập URL hình ảnh ${index + 2}',
                      hintStyle: TextStyle(
                          fontSize: 13, color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 13),
                    onChanged: (value) => setState(() {}), // Will auto-update via controller
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  onPressed: () => _removeAdditionalUrlController(index),
                  tooltip: 'Xóa URL ảnh này',
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (index < _additionalImageUrls.length && _additionalImageUrls[index].isNotEmpty)
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
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(
                    child: Icon(Icons.image_not_supported,
                        size: 30, color: Colors.grey),
                  ),
                ),
              ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  // Build additional images section based on current mode (URL input or file upload)
  Widget _buildAdditionalImagesSection() {
    if (_isUrlInput) {
      // URL input mode
      return _buildAdditionalImageUrlInputs();
    } else {
      // File upload mode
      return Row(
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
                imageFile: _additionalImages.length > index
                    ? _additionalImages[index]
                    : null,
              ),
            ),
          );
        }),
      );
    }
  }
}