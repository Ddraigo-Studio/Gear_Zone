import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gear_zone/core/utils/responsive.dart';
import 'package:gear_zone/controller/product_controller.dart';
import 'package:gear_zone/controller/image_handling_controller.dart';
import 'package:gear_zone/controller/category_controller.dart';
import 'package:gear_zone/core/utils/size_utils.dart';
import 'package:gear_zone/model/category.dart';
import 'package:gear_zone/model/product.dart';
import 'package:gear_zone/core/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:gear_zone/admin/Product/_image_upload_widget.dart';
import '../../../widgets/admin_widgets/breadcrumb.dart';
import '../../../widgets/custom_image_view.dart';

class ProductDetail extends StatefulWidget {
  final bool isViewOnly;

  const ProductDetail({
    super.key,
    this.isViewOnly = false,
  });

  @override
  ProductDetailState createState() => ProductDetailState();
}

class ProductDetailState extends State<ProductDetail> {
  final _formKey = GlobalKey<FormState>();  final TextEditingController _idController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _originalPriceController =
      TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  
  // Technical specification controllers
  final TextEditingController _processorController = TextEditingController();
  final TextEditingController _ramController = TextEditingController();
  final TextEditingController _storageController = TextEditingController();
  final TextEditingController _graphicsCardController = TextEditingController();
  final TextEditingController _displayController = TextEditingController();
  final TextEditingController _osController = TextEditingController();
  final TextEditingController _keyboardController = TextEditingController();
  final TextEditingController _audioController = TextEditingController();
  final TextEditingController _wifiController = TextEditingController();
  final TextEditingController _bluetoothController = TextEditingController();
  final TextEditingController _batteryController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _dimensionsController = TextEditingController();  final TextEditingController _securityController = TextEditingController();
  final TextEditingController _webcamController = TextEditingController();
  final TextEditingController _warrantyController = TextEditingController();
  final TextEditingController _portsController = TextEditingController();
  final TextEditingController _promotionsController = TextEditingController();

  String? _selectedCategory;
  List<CategoryModel> _categories = [];
  CategoryModel? _currentSelectedCategory;
  String? _selectedStatus;
  
  // Image handling controller
  final ImageHandlingController _imageController = ImageHandlingController();
  final CategoryController _categoryController = CategoryController();

  // Helper method to create decoration for form fields with different styling for fields that have content
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
  // These methods now use the ImageHandlingController
  Future<void> _pickMainImage() async {
    if (widget.isViewOnly) return;
    await _imageController.pickMainImage();
    setState(() {}); // Trigger UI update
  }

  Future<void> _pickAdditionalImage(int index) async {
    if (widget.isViewOnly) return;
    await _imageController.pickAdditionalImage(index);
    setState(() {}); // Trigger UI update
  }

  void _removeMainImage() {
    if (widget.isViewOnly) return;
    _imageController.removeMainImage();
    setState(() {}); // Trigger UI update
  }

  void _removeAdditionalImage(int index) {
    if (widget.isViewOnly) return;
    _imageController.removeAdditionalImage(index);
    setState(() {}); // Trigger UI update
  }
  
  void _addAdditionalImageSlot() {
    if (widget.isViewOnly) return;
    _imageController.addAdditionalImageSlot();
    setState(() {}); // Trigger UI update
  }
  
  void _addAdditionalUrlController() {
    if (widget.isViewOnly) return;
    _imageController.addAdditionalUrlController();
    setState(() {}); // Trigger UI update
  }
  
  void _removeAdditionalUrlController(int index) {
    if (widget.isViewOnly) return;
    _imageController.removeAdditionalUrlController(index);
    setState(() {}); // Trigger UI update
  }  // Delegate to the image controller for uploading
  Future<Map<String, dynamic>> _uploadAllImages(String productId) async {
    return await _imageController.uploadAllImages(productId, context);
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
    if (double.tryParse(value) == null) {
      return 'Chiết khấu phải là số';
    }
    double discount = double.parse(value);
    if (discount < 0 || discount > 50) {
      return 'Chiết khấu phải từ 0 đến 50%';
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

  Future<void> _loadCategories() async {
    try {
      final categoriesData = await _categoryController.getCategoriesPaginated();
      if (mounted) {
        setState(() {
          _categories = categoriesData['categories'] as List<CategoryModel>;
          _syncCurrentSelectedCategory(); // Attempt to sync after categories load
        });
      }
    } catch (e) {
      print('Error loading categories in ProductDetailScreen: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải danh mục: $e')),
        );
      }
    }
  }

  void _syncCurrentSelectedCategory() {
    if (_selectedCategory != null && _categories.isNotEmpty) {
      final foundCategory = _categories.firstWhere(
        (cat) => cat.categoryName == _selectedCategory,
        orElse: () => _categories.first, // Fallback to the first category if not found
      );
      if (_currentSelectedCategory?.id != foundCategory.id) {
         setState(() {
            _currentSelectedCategory = foundCategory;
         });
      }
    } else if (_categories.isNotEmpty && _currentSelectedCategory == null) {
      // If no specific category is selected yet, but categories are loaded,
      // and if not in viewOnly mode, you might want to default to the first one.
      // Or, ensure _selectedCategory is set if _currentSelectedCategory is set.
    }
  }

  // Phương thức xử lý khi nhấn nút lưu
  void _saveForm(BuildContext context) async {
    // If in view-only mode, don't allow saving
    if (widget.isViewOnly) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn đang ở chế độ xem. Không thể lưu thay đổi.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

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
        },      ); 
        // Tạo đối tượng ProductModel từ dữ liệu form
      ProductModel product = ProductModel(
        id: _idController.text,
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        originalPrice: double.tryParse(_originalPriceController.text) ?? 0,
        imageUrl: _mainImageUrl, // Sử dụng URL hiện có nếu có
        additionalImages: _imageController.getNonEmptyAdditionalImageUrls(),
        category: _selectedCategory ?? 'Laptop',
        brand: _brandController.text,
        seriNumber: _codeController.text,
        quantity: _quantityController.text,
        status: _selectedStatus ?? 'out_of_stock',
        inStock: _selectedStatus == 'available',
        discount: int.tryParse(_discountController.text) ?? 0,
        // Thông số kỹ thuật cơ bản
        processor: _processorController.text,
        ram: _ramController.text,
        storage: _storageController.text,
        graphicsCard: _graphicsCardController.text,
        display: _displayController.text,
        operatingSystem: _osController.text,
        keyboard: _keyboardController.text,
        audio: _audioController.text,
        wifi: _wifiController.text,
        bluetooth: _bluetoothController.text,
        battery: _batteryController.text,
        weight: _weightController.text,
        color: _colorController.text,
        dimensions: _dimensionsController.text,        security: _securityController.text,
        webcam: _webcamController.text,
        warranty: _warrantyController.text,
        ports: _portsController.text.isNotEmpty ? [_portsController.text] : [],
        promotions: _promotionsController.text.isNotEmpty ? [_promotionsController.text] : [],
      );// Lưu sản phẩm vào Firestore
      String? productId;
      if (_idController.text.isEmpty) {
        productId = await _productController.addProduct(product);
      } else {
        bool success = await _productController.updateProduct(product);
        if (success) {
          productId = product.id;
        }
      }
      // Upload ảnh mới nếu có
      if (productId != null) {
        bool hasNewImages = _mainImage != null ||
            _additionalImages.any((file) => file.path.isNotEmpty);        bool hasRemovedImages =
            _mainImageUrl.isEmpty && product.imageUrl.isNotEmpty ||
                _imageController.additionalImageUrls.length < product.additionalImages.length;

        if (hasNewImages || hasRemovedImages) {
          // Hiển thị trạng thái đang xử lý ảnh
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đang xử lý hình ảnh sản phẩm...'),
              duration: Duration(seconds: 2),
            ),
          );

          // Upload ảnh mới và lấy URLs
          if (hasNewImages) {
            Map<String, dynamic> imageUrls = await _uploadAllImages(productId);

            // Cập nhật product model với URLs mới
            if (imageUrls['mainImageUrl'].isNotEmpty) {
              product.imageUrl = imageUrls['mainImageUrl'];
            }

            // Kết hợp ảnh mới và ảnh cũ (giữ lại các URL không thay đổi)
            List<String> updatedAdditionalImages =
                imageUrls['additionalImageUrls'];
            if (updatedAdditionalImages.isNotEmpty) {
              product.additionalImages = updatedAdditionalImages;            } else if (_imageController.additionalImageUrls.isNotEmpty) {
              // Nếu không có ảnh mới upload, sử dụng danh sách hiện tại
              product.additionalImages = _imageController.getNonEmptyAdditionalImageUrls();
            }          } else {
            // Không có ảnh mới, nhưng có thể đã xóa ảnh cũ
            product.imageUrl = _mainImageUrl;
            product.additionalImages = _imageController.getNonEmptyAdditionalImageUrls();
          }

          // Cập nhật lại product vào Firestore
          await _productController.updateProduct(product);
        }
      }

      // Đóng dialog loading
      Navigator.pop(context);      if (productId != null) {
        // Nếu thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lưu sản phẩm thành công!'),
            backgroundColor: Colors.green,
          ),
        );

        // Đặt cờ để tải lại danh sách sản phẩm khi trở về ProductScreen
        final appProvider = Provider.of<AppProvider>(context, listen: false);
        appProvider.setReloadProductList(true);

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
  }  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProductData();
      _loadCategories();
    });
  }
    @override
  void dispose() {
    // Giải phóng các controllers thông tin cơ bản
    _idController.dispose();
    _codeController.dispose();
    _nameController.dispose();
    _brandController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _discountController.dispose();
    _quantityController.dispose();
    
    // Giải phóng các controllers thông số kỹ thuật
    _processorController.dispose();
    _ramController.dispose();
    _storageController.dispose();
    _graphicsCardController.dispose();
    _displayController.dispose();
    _osController.dispose();
    _keyboardController.dispose();
    _audioController.dispose();
    _wifiController.dispose();
    _bluetoothController.dispose();
    _batteryController.dispose();
    _weightController.dispose();
    _colorController.dispose();
    _dimensionsController.dispose();
    _securityController.dispose();
    _webcamController.dispose();
    _warrantyController.dispose();
    _portsController.dispose();
    _promotionsController.dispose();
    
    _imageController.dispose();
    super.dispose();
  }

  // Method to load product data from Firebase
  Future<void> _loadProductData() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final productId = appProvider.currentProductId;

    if (productId.isEmpty) {
      // No product ID provided, this is likely a new product
      return;
    }

    try {
      final product = await _productController.getProductById(productId);
      if (product != null) {
        // Set form field values
        setState(() {          _idController.text = product.id;
          _nameController.text = product.name;
          _codeController.text = product.seriNumber;
          _brandController.text = product.brand;
          _descriptionController.text = product.description;
          _priceController.text = product.price.toString();
          _originalPriceController.text = product.originalPrice.toString();
          _discountController.text = product.discount.toString();
          _quantityController.text = product.quantity;
          _selectedCategory = product.category;
          _selectedStatus = product.inStock ? 'available' : 'out_of_stock';
          
          // Initialize the image controller with product data
          _imageController.initWithProductData(product.imageUrl, List.from(product.additionalImages));
          
          // Populate technical specification fields
          _processorController.text = product.processor;
          _ramController.text = product.ram;
          _storageController.text = product.storage;
          _graphicsCardController.text = product.graphicsCard;
          _displayController.text = product.display;
          _osController.text = product.operatingSystem;
          _keyboardController.text = product.keyboard;
          _audioController.text = product.audio;
          _wifiController.text = product.wifi;
          _bluetoothController.text = product.bluetooth;
          _batteryController.text = product.battery;
          _weightController.text = product.weight;
          _colorController.text = product.color;
          _dimensionsController.text = product.dimensions;          _securityController.text = product.security;
          _webcamController.text = product.webcam;
          _warrantyController.text = product.warranty;
          
          // Nạp dữ liệu cho cổng kết nối và khuyến mãi
          _portsController.text = product.ports.isNotEmpty ? product.ports.first : '';
          _promotionsController.text = product.promotions.isNotEmpty ? product.promotions.first : '';

          // Add a small delay to ensure state updates before updating styling
          Future.delayed(const Duration(milliseconds: 100), () {
            if(mounted) {
              setState(() {
              });
            }
          });
        });
      } else {
        // Product not found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không tìm thấy thông tin sản phẩm'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      // Error loading product
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tải dữ liệu sản phẩm: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Add toggle between URL and file upload modes
  Widget _buildImageToggleSelector() {
    if (widget.isViewOnly) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chọn cách tải ảnh:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(
                    value: false,
                    label: Text('Tải từ thiết bị'),
                    icon: Icon(Icons.upload_file),
                  ),
                  ButtonSegment<bool>(
                    value: true,
                    label: Text('Nhập URL'),
                    icon: Icon(Icons.link),
                  ),
                ],
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                ),                selected: {_isUrlInput},
                onSelectionChanged: (newSelection) {
                  _setUrlInputMode(newSelection.first);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Build the note about image formats based on selected mode
  Widget _buildImageFormatNote() {
    return RichText(
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
          TextSpan(
            text: _isUrlInput 
              ? 'Nhập URL hình ảnh trực tiếp từ Internet ' 
              : 'Định dạng ảnh ',
          ),
          TextSpan(
            text: _isUrlInput 
              ? '(https://...)' 
              : 'PNG, or JPG (kích cỡ tối đa 4mb)',
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
  
  // Build main image URL input field
  Widget _buildMainImageUrlInput() {
    if (!_isUrlInput || widget.isViewOnly) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'URL ảnh chính',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _mainImageUrlController,
          decoration: _getInputDecoration(
            hintText: 'Nhập URL hình ảnh chính',
            hasValue: _mainImageUrlController.text.isNotEmpty,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          ),
          onChanged: (value) => setState(() {}),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
  
  // Build additional image URL inputs
  Widget _buildAdditionalImageUrlInputs() {
    if (!_isUrlInput || widget.isViewOnly) return const SizedBox.shrink();
    
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
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _additionalImageUrlControllers[index],
                  decoration: _getInputDecoration(
                    hintText: 'Nhập URL hình ảnh phụ ${index + 2}',
                    hasValue: _additionalImageUrlControllers[index].text.isNotEmpty,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
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
        );
      },
    );
  }
  
  // Build file-based additional images grid
  Widget _buildAdditionalImagesGrid() {
    if (_isUrlInput && !widget.isViewOnly) return const SizedBox.shrink();
    
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        // Show existing additional images
        for (int i = 0; i < _additionalImages.length || i < _additionalImageUrls.length; i++)
          SizedBox(
            width: (MediaQuery.of(context).size.width - 72) / 3, // 3 images per row
            child: ImageUploadBox(
              label: 'Ảnh ${i + 2}',
              index: i,
              imageFiles: _additionalImages,
              imageUrls: _additionalImageUrls,
              isViewOnly: widget.isViewOnly,
              onPickImage: _pickAdditionalImage,
              onRemoveImage: _removeAdditionalImage,
            ),
          ),
          
        // Add more images button (only in file upload mode and not in view mode)
        if (!widget.isViewOnly && !_isUrlInput)
          InkWell(
            onTap: _addAdditionalImageSlot,
            child: Container(
              width: (MediaQuery.of(context).size.width - 72) / 3,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Thêm ảnh',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
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
            // Page title with view mode indicator
            Row(
              children: [
                const Text(
                  'Sản phẩm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.isViewOnly)
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEE5FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Chế độ xem',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7E3FF2),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),            // Breadcrumb
            Breadcrumb(
              items: [
                BreadcrumbBuilder.dashboard(context),
                BreadcrumbBuilder.products(context),
                // If there's a selected category, show it as part of the breadcrumb
                if (_selectedCategory != null && _selectedCategory!.isNotEmpty)
                  BreadcrumbItem(
                    title: _selectedCategory!,
                    screen: AppScreen.productList, // Navigate to product screen with this category filter
                    onTap: () {
                      final appProvider = Provider.of<AppProvider>(context, listen: false);
                      appProvider.setSelectedCategory(_selectedCategory!);
                      appProvider.setCurrentScreen(AppScreen.productList);
                    }
                  ),
                BreadcrumbBuilder.productDetail(context, _nameController.text.isNotEmpty ? _nameController.text : 'Chi tiết sản phẩm'),
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

            // Action buttons - hidden in view-only mode
            if (!widget.isViewOnly)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Hủy',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _saveForm(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7E3FF2),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
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

          // ID sản phẩm
          const Text(
            'ID sản phẩm',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _idController,
            decoration: _getInputDecoration(
              hintText: 'ID sản phẩm được tạo tự động',
              hasValue: _idController.text.isNotEmpty,
              enabled: false,
            ),
            style: TextStyle(
              fontSize: 13,
              fontWeight: _idController.text.isNotEmpty
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 12),

          // Mã sản phẩm (Seri)
          const Text(
            'Số Seri',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _codeController,
            decoration: _getInputDecoration(
              hintText: 'Nhập số seri (vd: LP001)',
              hasValue: _codeController.text.isNotEmpty,
              enabled: !widget.isViewOnly,
            ),
            style: TextStyle(
              fontSize: 13,
              fontWeight: _codeController.text.isNotEmpty
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mã sản phẩm';
              }
              return null;
            },
            enabled: !widget.isViewOnly,
            onChanged: (value) {
              // Force a rebuild to update the style when text changes
              setState(() {});
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
            decoration: _getInputDecoration(
              hintText: 'Nhập tên sản phẩm',
              hasValue: _nameController.text.isNotEmpty,
              enabled: !widget.isViewOnly,
            ),
            style: TextStyle(
              fontSize: 13,
              fontWeight: _nameController.text.isNotEmpty
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
            readOnly: widget.isViewOnly,
            enabled: !widget.isViewOnly,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập tên sản phẩm';
              }
              return null;
            },
            onChanged: (value) {
              // Force a rebuild to update the style when text changes
              setState(() {});
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
            decoration: _getInputDecoration(
              hintText: 'Nhập thương hiệu (vd: Dell, Asus...)',
              hasValue: _brandController.text.isNotEmpty,
              enabled: !widget.isViewOnly,
            ),
            style: TextStyle(
              fontSize: 13,
              fontWeight: _brandController.text.isNotEmpty
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập thương hiệu';
              }
              return null;
            },
            enabled: !widget.isViewOnly,
            onChanged: (value) {
              // Force a rebuild to update the style when text changes
              setState(() {});
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
            decoration: _getInputDecoration(
              hintText: 'Nhập mô tả chi tiết về sản phẩm',
              hasValue: _descriptionController.text.isNotEmpty,
              contentPadding: const EdgeInsets.all(12),
              enabled: !widget.isViewOnly,
            ),
            style: TextStyle(
              fontSize: 13,
              fontWeight: _descriptionController.text.isNotEmpty
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mô tả sản phẩm';
              }
              return null;
            },
            enabled: !widget.isViewOnly,
            onChanged: (value) {
              // Force a rebuild to update the style when text changes
              setState(() {});
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
                      decoration: _getInputDecoration(
                        hintText: 'Chọn danh mục',
                        hasValue: _currentSelectedCategory != null,
                        enabled: !widget.isViewOnly,
                      ),
                      value: _currentSelectedCategory,
                      items: _categories.map((CategoryModel category) {
                        return DropdownMenuItem<CategoryModel>(
                          value: category,
                          child: Text(category.categoryName, style: TextStyle(fontSize: 13)),
                        );
                      }).toList(),
                      onChanged: widget.isViewOnly
                          ? null
                          : (CategoryModel? newValue) {
                              setState(() {
                                _currentSelectedCategory = newValue;
                                _selectedCategory = newValue?.categoryName;
                              });
                            },
                      validator: (value) {
                        if (value == null && !widget.isViewOnly) {
                          return 'Vui lòng chọn danh mục sản phẩm';
                        }
                        return null;
                      },
                      isExpanded: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Product status
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
                      decoration: _getInputDecoration(hintText: 'Chọn trạng thái', hasValue: _selectedStatus != null, enabled: !widget.isViewOnly),
                      value: _selectedStatus,
                      items: const [
                        DropdownMenuItem(
                          value: 'available',
                          child: Text('Có sẵn', style: TextStyle(fontSize: 13)),
                        ),
                        DropdownMenuItem(
                          value: 'out_of_stock',
                          child: Text('Hết hàng', style: TextStyle(fontSize: 13)),
                        ),
                        DropdownMenuItem(
                          value: 'discontinued',
                          child: Text('Ngừng kinh doanh', style: TextStyle(fontSize: 13)),
                        ),
                      ],
                      onChanged: widget.isViewOnly ? null : (String? newValue) {
                        setState(() {
                          _selectedStatus = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null && !widget.isViewOnly) {
                          return 'Vui lòng chọn trạng thái sản phẩm';
                        }
                        return null;
                      },
                      isExpanded: true,
                    ),
                  ],
                ),
              ),
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
                      decoration: _getInputDecoration(
                        hintText: 'Nhập giá gốc (VNĐ)',
                        hasValue: _originalPriceController.text.isNotEmpty,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                      ),
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _originalPriceController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      validator: _validatePrice,
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
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
                      'Giá bán',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _priceController,
                      decoration: _getInputDecoration(
                        hintText: 'Nhập giá bán (VNĐ)',
                        hasValue: _priceController.text.isNotEmpty,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                      ),
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _priceController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      validator: _validatePrice,
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Discount percentage
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      decoration: _getInputDecoration(
                        hintText: 'Nhập % giảm giá',
                        hasValue: _discountController.text.isNotEmpty,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                      ),
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _discountController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      validator: _validateDiscount,
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
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
                      decoration: _getInputDecoration(
                        hintText: 'Nhập số lượng',
                        hasValue: _quantityController.text.isNotEmpty,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                      ),
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _quantityController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      validator: _validateQuantity,
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
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
                    const SizedBox(height: 6),                    TextFormField(
                      controller: _processorController,
                      decoration: _getInputDecoration(
                        hintText: 'Vd: Intel Core i5-12500H',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                        hasValue: _processorController.text.isNotEmpty,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _processorController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
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
                    const SizedBox(height: 6),                    TextFormField(
                      controller: _ramController,
                      decoration: _getInputDecoration(
                        hintText: 'Vd: 16GB DDR4 3200MHz',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                        hasValue: _ramController.text.isNotEmpty,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _ramController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
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
                    const SizedBox(height: 6),                    TextFormField(
                      controller: _storageController,
                      decoration: _getInputDecoration(
                        hintText: 'Vd: 512GB SSD NVMe',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                        hasValue: _storageController.text.isNotEmpty,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _storageController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
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
                    const SizedBox(height: 6),                    TextFormField(
                      controller: _graphicsCardController,
                      decoration: _getInputDecoration(
                        hintText: 'Vd: NVIDIA RTX 4050 6GB',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                        hasValue: _graphicsCardController.text.isNotEmpty,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _graphicsCardController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
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
                    const SizedBox(height: 6),                    TextFormField(
                      controller: _displayController,
                      decoration: _getInputDecoration(
                        hintText: 'Vd: 15.6" FHD IPS 144Hz',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                        hasValue: _displayController.text.isNotEmpty,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _displayController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
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
                    const SizedBox(height: 6),                    TextFormField(
                      controller: _osController,
                      decoration: _getInputDecoration(
                        hintText: 'Vd: Windows 11 Home',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                        hasValue: _osController.text.isNotEmpty,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _osController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
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
                    const SizedBox(height: 6),                    TextFormField(
                      controller: _keyboardController,
                      decoration: _getInputDecoration(
                        hintText: 'Vd: RGB Backlit keyboard',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                        hasValue: _keyboardController.text.isNotEmpty,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _keyboardController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
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
                    const SizedBox(height: 6),                    TextFormField(
                      controller: _audioController,
                      decoration: _getInputDecoration(
                        hintText: 'Vd: Stereo speakers, DTS',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                        hasValue: _audioController.text.isNotEmpty,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
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
                    const SizedBox(height: 6),                    TextFormField(
                      controller: _wifiController,
                      decoration: _getInputDecoration(
                        hintText: 'Vd: Wi-Fi 6 (802.11ax)',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                        hasValue: _wifiController.text.isNotEmpty,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _wifiController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
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
                    const SizedBox(height: 6),                    TextFormField(
                      controller: _bluetoothController,
                      decoration: _getInputDecoration(
                        hintText: 'Vd: Bluetooth 5.2',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                        hasValue: _bluetoothController.text.isNotEmpty,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _bluetoothController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
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
                    const SizedBox(height: 6),                    TextFormField(
                      controller: _batteryController,
                      decoration: _getInputDecoration(
                        hintText: 'Vd: 4-cell, 54WHr',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                        hasValue: _batteryController.text.isNotEmpty,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _batteryController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
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
                    const SizedBox(height: 6),                    TextFormField(
                      controller: _weightController,
                      decoration: _getInputDecoration(
                        hintText: 'Vd: 1.8 kg',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                        hasValue: _weightController.text.isNotEmpty,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _weightController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
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
                    const SizedBox(height: 6),                    TextFormField(
                      controller: _colorController,
                      decoration: _getInputDecoration(
                        hintText: 'Vd: Đen, Bạc...',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                        hasValue: _colorController.text.isNotEmpty,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _colorController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
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
                    const SizedBox(height: 6),                    TextFormField(
                      controller: _dimensionsController,
                      decoration: _getInputDecoration(
                        hintText: 'Vd: 360 x 252 x 19.9 mm',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                        hasValue: _dimensionsController.text.isNotEmpty,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _dimensionsController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
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
                    const SizedBox(height: 6),                    TextFormField(
                      controller: _webcamController,
                      decoration: _getInputDecoration(
                        hintText: 'Vd: HD 720p',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                        hasValue: _webcamController.text.isNotEmpty,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _webcamController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
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
                    const SizedBox(height: 6),                    TextFormField(
                      controller: _securityController,
                      decoration: _getInputDecoration(
                        hintText: 'Vd: Vân tay, khuôn mặt',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        enabled: !widget.isViewOnly,
                        hasValue: _securityController.text.isNotEmpty,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _securityController.text.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      enabled: !widget.isViewOnly,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),          // Ports
          const Text(
            'Cổng kết nối',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _portsController,
            decoration: _getInputDecoration(
              hintText: 'Vd: 2x USB-C, 2x USB-A, 1x HDMI, 1x Audio Jack',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              enabled: !widget.isViewOnly,
              hasValue: _portsController.text.isNotEmpty,
            ),
            style: TextStyle(
              fontSize: 13,
              fontWeight: _portsController.text.isNotEmpty
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
            enabled: !widget.isViewOnly,
            onChanged: (value) {
              setState(() {});
            },
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
          const SizedBox(height: 6),          TextFormField(
            controller: _warrantyController,
            decoration: _getInputDecoration(
              hintText: 'Vd: 24 tháng',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              enabled: !widget.isViewOnly,
              hasValue: _warrantyController.text.isNotEmpty,
            ),
            style: TextStyle(
              fontSize: 13,
              fontWeight: _warrantyController.text.isNotEmpty
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
            enabled: !widget.isViewOnly,
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 12),          // Promotions
          const Text(
            'Khuyến mãi',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _promotionsController,
            maxLines: 2,
            decoration: _getInputDecoration(
              hintText: 'Vd: Balo, chuột không dây, PMH 200.000đ',
              contentPadding: const EdgeInsets.all(12),
              enabled: !widget.isViewOnly,
              hasValue: _promotionsController.text.isNotEmpty,
            ),
            style: TextStyle(
              fontSize: 13,
              fontWeight: _promotionsController.text.isNotEmpty
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
            enabled: !widget.isViewOnly,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductImageSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          const Text(
            'Hình ảnh sản phẩm',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          
          _buildImageToggleSelector(),
          
          _buildImageFormatNote(),
          const SizedBox(height: 20),

          // Upload status indicator
          if (_isUploadingImages)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Đang tải lên hình ảnh...',
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),          _buildMainImageUrlInput(),
            
          // Main product image
          InkWell(
            onTap: (widget.isViewOnly || _isUrlInput) ? null : _pickMainImage,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: _mainImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.file(
                            _mainImage!,
                            fit: BoxFit.contain,
                          ),
                        )
                      : (_mainImageUrl.isNotEmpty                          
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: CustomImageView(
                                key: ValueKey('product_main_${DateTime.now().millisecondsSinceEpoch}'),
                                imagePath: _mainImageUrl,
                                fit: BoxFit.contain,
                                height: 180,
                                width: double.infinity,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.grey.shade50,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate,
                                    size: 40,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Ảnh sản phẩm chính',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  if (!widget.isViewOnly && !_isUrlInput)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        'Nhấn để chọn ảnh',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )),
                ),
                if (!widget.isViewOnly &&
                    (_mainImage != null || _mainImageUrl.isNotEmpty))
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            onPressed: _pickMainImage,
                            tooltip: 'Chỉnh sửa ảnh',
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(width: 2),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                size: 18, color: Colors.red),
                            onPressed: _removeMainImage,
                            tooltip: 'Xóa ảnh',
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),          const SizedBox(height: 20),
          
          // Tiêu đề ảnh phụ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ảnh bổ sung',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
              if (!widget.isViewOnly)
                TextButton.icon(
                  onPressed: _addAdditionalImageSlot,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Thêm ảnh', style: TextStyle(fontSize: 13)),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          _buildAdditionalImageUrlInputs(),
          
          // Hiển thị grid các ảnh phụ trong chế độ upload file
          _buildAdditionalImagesGrid(),
        ],
      ),
    );
  }
}