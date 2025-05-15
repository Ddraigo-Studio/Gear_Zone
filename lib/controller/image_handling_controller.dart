import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gear_zone/controller/product_controller.dart';

/// Controller class for handling all image-related functionality for products
class ImageHandlingController extends ChangeNotifier {
  // Variables to track image files
  File? _mainImage;
  final List<File> _additionalImages = [];
  
  // Variables for image URLs
  String _mainImageUrl = '';
  final List<String> _additionalImageUrls = [];
  
  // Controllers for URL input fields
  final TextEditingController _mainImageUrlController = TextEditingController();
  final List<TextEditingController> _additionalImageUrlControllers = [];
  
  // Flag for upload mode (URL vs file upload)
  bool _isUrlInput = false;
  
  // Flag for upload status
  bool _isUploadingImages = false;
  
  // Reference to product controller for uploading
  final ProductController _productController = ProductController();
  
  // Getters
  File? get mainImage => _mainImage;
  List<File> get additionalImages => _additionalImages;
  String get mainImageUrl => _mainImageUrl;
  List<String> get additionalImageUrls => _additionalImageUrls;
  TextEditingController get mainImageUrlController => _mainImageUrlController;
  List<TextEditingController> get additionalImageUrlControllers => _additionalImageUrlControllers;
  bool get isUrlInput => _isUrlInput;
  bool get isUploadingImages => _isUploadingImages;
  
  // Constructor to set listeners
  ImageHandlingController() {
    _mainImageUrlController.addListener(_updateMainImageUrlPreview);
  }
  
  @override
  void dispose() {
    // Remove listeners and dispose controllers
    _mainImageUrlController.removeListener(_updateMainImageUrlPreview);
    _mainImageUrlController.dispose();
    
    for (var controller in _additionalImageUrlControllers) {
      controller.dispose();
    }
    _additionalImageUrlControllers.clear();
    
    super.dispose();
  }
  
  // Method to initialize with existing product data
  void initWithProductData(String mainImageUrl, List<String> additionalImageUrls) {
    // Reset any existing data
    reset();
    
    // Set URLs
    _mainImageUrl = mainImageUrl;
    _additionalImageUrls.clear();
    _additionalImageUrls.addAll(additionalImageUrls);
    
    // Set URL controllers
    _mainImageUrlController.text = mainImageUrl;
    
    // Create controllers for additional image URLs
    for (int i = 0; i < additionalImageUrls.length; i++) {
      final controller = TextEditingController(text: additionalImageUrls[i]);
      _additionalImageUrlControllers.add(controller);
      
      // Add listener for each controller
      final int index = i;
      controller.addListener(() => _updateAdditionalImageUrlPreview(index));
    }
    
    notifyListeners();
  }
  
  // Method to pick image from gallery
  Future<File?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  // Method to pick main product image
  Future<void> pickMainImage() async {
    final File? pickedImage = await _pickImage();
    if (pickedImage != null) {
      _mainImage = pickedImage;
      _mainImageUrl = ''; // Clear URL if we pick a new file
      notifyListeners();
    }
  }

  // Method to pick additional product image
  Future<void> pickAdditionalImage(int index) async {
    final File? pickedImage = await _pickImage();
    if (pickedImage != null) {
      while (_additionalImages.length <= index) {
        _additionalImages.add(File(''));
      }
      _additionalImages[index] = pickedImage;

      // Clear URL at this position if it exists
      if (_additionalImageUrls.length > index) {
        _additionalImageUrls[index] = '';
      }
      
      notifyListeners();
    }
  }

  // Method to remove the main product image
  void removeMainImage() {
    _mainImage = null;
    _mainImageUrl = '';
    notifyListeners();
  }

  // Method to remove an additional product image
  void removeAdditionalImage(int index) {
    if (_additionalImages.length > index) {
      _additionalImages[index] = File('');
    }

    if (_additionalImageUrls.length > index) {
      _additionalImageUrls[index] = '';
    }
    
    notifyListeners();
  }
  
  // Method to add a slot for an additional image
  void addAdditionalImageSlot() {
    _additionalImages.add(File(''));
    notifyListeners();
  }
  
  // Method to add a controller for additional image URL
  void addAdditionalUrlController() {
    final controller = TextEditingController();
    _additionalImageUrlControllers.add(controller);
    
    // Add listener for the new controller
    final int index = _additionalImageUrlControllers.length - 1;
    controller.addListener(() => _updateAdditionalImageUrlPreview(index));
    
    notifyListeners();
  }
  
  // Method to remove a controller for additional image URL
  void removeAdditionalUrlController(int index) {
    if (index < 0 || index >= _additionalImageUrlControllers.length) return;
    
    final controller = _additionalImageUrlControllers[index];
    final int finalIndex = index; // Capture the index for the lambda
    
    // Remove listener before disposing controller
    controller.removeListener(() => _updateAdditionalImageUrlPreview(finalIndex));
    
    // Dispose controller
    controller.dispose();
    
    // Remove controller from list
    _additionalImageUrlControllers.removeAt(index);
    
    // Remove URL if it exists
    if (index < _additionalImageUrls.length) {
      _additionalImageUrls.removeAt(index);
    }
    
    notifyListeners();
  }
  
  // Method to update main image URL preview
  void _updateMainImageUrlPreview() {
    _mainImageUrl = _mainImageUrlController.text;
    notifyListeners();
  }
  
  // Method to update additional image URL preview
  void _updateAdditionalImageUrlPreview(int index) {
    if (index < 0 || index >= _additionalImageUrlControllers.length) return;
    
    // Extend list if needed
    while (_additionalImageUrls.length <= index) {
      _additionalImageUrls.add('');
    }
    
    _additionalImageUrls[index] = _additionalImageUrlControllers[index].text;
    notifyListeners();
  }
  
  // Method to toggle between URL input and file upload
  void toggleInputMode(bool useUrlInput) {
    _isUrlInput = useUrlInput;
    notifyListeners();
  }
  
  // Method to upload all images and get URLs
  Future<Map<String, dynamic>> uploadAllImages(
    String productId, 
    BuildContext context
  ) async {
    String mainImageUrl = _mainImageUrl; // Keep old URL if no new image
    List<String> additionalImageUrls = List.from(_additionalImageUrls);
    
    _isUploadingImages = true;
    notifyListeners();
    
    try {
      // Check which mode we're using (URL or file upload)
      if (_isUrlInput) {
        // URL mode: Get URLs from controllers
        
        // Get main image URL from controller
        if (_mainImageUrlController.text.isNotEmpty) {
          mainImageUrl = _mainImageUrlController.text;
        }
        
        // Get additional image URLs
        for (int i = 0; i < _additionalImageUrlControllers.length; i++) {
          final urlText = _additionalImageUrlControllers[i].text;
          if (urlText.isNotEmpty) {
            // Extend list if needed
            while (additionalImageUrls.length <= i) {
              additionalImageUrls.add('');
            }
            additionalImageUrls[i] = urlText;
          }
        }
      } else {
        // File upload mode
        
        // Upload main image if it exists and path is not empty
        if (_mainImage != null && _mainImage!.path.isNotEmpty) {
          // Show notification when uploading main image
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đang tải lên ảnh chính...'),
                duration: Duration(seconds: 1),
              ),
            );
          }

          mainImageUrl = await _productController.uploadProductImage(
              _mainImage!, productId, isMainImage: true) ?? '';
        }
        
        // Upload additional images with non-empty paths
        List<Future<void>> uploadTasks = [];

        for (int i = 0; i < _additionalImages.length; i++) {
          if (_additionalImages[i].path.isNotEmpty) {
            final int index = i; // Capture the index for use in the async task

            // Create upload task for additional image
            uploadTasks.add(Future(() async {
              // Show notification when uploading additional image
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đang tải lên ảnh ${index + 2}...'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }

              String? url = await _productController.uploadProductImage(
                  _additionalImages[index], productId, isMainImage: false);

              if (url != null && url.isNotEmpty) {
                // Replace URL at corresponding position or add new
                if (additionalImageUrls.length > index) {
                  additionalImageUrls[index] = url;
                } else {
                  additionalImageUrls.add(url);
                }
              }
            }));
          }
        }
        
        // Wait for all upload tasks to complete
        if (uploadTasks.isNotEmpty) {
          await Future.wait(uploadTasks);
        }
      }
    } catch (e) {
      // Handle error when uploading images
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải lên hình ảnh: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      rethrow;
    } finally {
      _isUploadingImages = false;
      notifyListeners();
    }

    // Filter out empty URLs in the additional images list
    final filteredAdditionalImageUrls =
        additionalImageUrls.where((url) => url.isNotEmpty).toList();

    return {
      'mainImageUrl': mainImageUrl,
      'additionalImageUrls': filteredAdditionalImageUrls
    };
  }
  
  // Method to get all non-empty image URLs
  List<String> getNonEmptyAdditionalImageUrls() {
    return _additionalImageUrls.where((url) => url.isNotEmpty).toList();
  }
  
  // Method to reset all data
  void reset() {
    _mainImage = null;
    _mainImageUrl = '';
    _mainImageUrlController.text = '';
    
    _additionalImages.clear();
    _additionalImageUrls.clear();
    
    // Remove listeners and dispose controllers
    for (var controller in _additionalImageUrlControllers) {
      controller.removeListener(() {});
      controller.dispose();
    }
    _additionalImageUrlControllers.clear();
    
    _isUploadingImages = false;
    notifyListeners();
  }
}