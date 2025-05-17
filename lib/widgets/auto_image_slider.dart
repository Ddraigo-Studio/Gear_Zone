import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../model/product.dart';
import '../theme/theme_helper.dart';

class MyImageSlider extends StatefulWidget {
  final ProductModel? product;

  const MyImageSlider({super.key, this.product});

  @override
  State<MyImageSlider> createState() => _MyImageSliderState();
}

class _MyImageSliderState extends State<MyImageSlider> {
  late List<Widget> myitems;
  int myCurrentIndex = 0;
  late PageController _pageController;
  
  // Thêm hàm kiểm tra URL hình ảnh
  bool isValidImageUrl(String url) {
    if (url.isEmpty) return false;
    
    // Kiểm tra định dạng URL có chứa tên file hình ảnh hợp lệ
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
    
    // Imgur URLs đặc biệt - cũng được coi là hợp lệ ngay cả khi không có đuôi file
    if (url.contains('imgur.com') || url.contains('i.imgur.com')) {
      return true;
    }
    
    return validExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }
  
  // Hàm chuyển đổi URL Imgur để tải được ảnh
  String processImgurUrl(String url) {
    String processedUrl = url;
    
    // Nếu URL thuộc imgur.com nhưng không phải định dạng i.imgur.com
    if (url.contains('imgur.com') && !url.contains('i.imgur.com')) {
      // Trường hợp 1: URL kiểu https://imgur.com/abcd123
      if (!url.endsWith('.jpg') && !url.endsWith('.png') && !url.endsWith('.gif')) {
        // Lấy ID hình ảnh
        String imgId = url.split('/').last;
        // Xóa phần query parameters nếu có
        imgId = imgId.split('?').first;
        // Tạo URL mới với định dạng i.imgur.com
        processedUrl = 'https://i.imgur.com/$imgId.jpg';
      } 
      // Trường hợp 2: URL kiểu https://imgur.com/abcd123.jpg
      else {
        processedUrl = url.replaceFirst('imgur.com', 'i.imgur.com');
      }
      
      print("Đã chuyển URL $url thành $processedUrl");
    }
    
    return processedUrl;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeImages();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  void _initializeImages() {
    // Khởi tạo danh sách rỗng
    myitems = [];
    
    if (widget.product != null) {
      // Debug thông tin sản phẩm
      print("Thông tin sản phẩm: ${widget.product!.name}");
      print("URL ảnh chính: ${widget.product!.imageUrl}");
      print("Số lượng ảnh phụ: ${widget.product!.additionalImages.length}");
      print("Danh sách ảnh phụ: ${widget.product!.additionalImages}");
        // Thêm ảnh chính vào đầu danh sách
      if (widget.product!.imageUrl.isNotEmpty) {
        try {
          if (widget.product!.imageUrl.startsWith('http') ||
              widget.product!.imageUrl.startsWith('https')) {
            // Nếu là URL trực tuyến
            
            // Xử lý URL Imgur đặc biệt
            String processedUrl = processImgurUrl(widget.product!.imageUrl);
            
            print("Đang tải ảnh chính từ URL: $processedUrl");
            myitems.add(Image.network(
              processedUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / 
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                print("Lỗi tải ảnh chính: $error");
                return Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.grey[400]),
                  ),
                );
              },
            ));
          } else {
            // Nếu là đường dẫn local
            print("Đang tải ảnh local từ: ${widget.product!.imageUrl}");
            myitems.add(Image.asset(
              widget.product!.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                print("Lỗi tải ảnh local: $error");
                return Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.grey[400]),
                  ),
                );
              },
            ));
          }
        } catch (e) {
          print("Lỗi khi tải ảnh chính: $e");
        }
      }      // Thêm các ảnh phụ
      if (widget.product!.additionalImages.isNotEmpty) {
        for (String imgUrl in widget.product!.additionalImages) {
          // Chỉ xử lý các URL ảnh đã tồn tại
          if (imgUrl.isNotEmpty) {
            if (imgUrl.startsWith('https') || imgUrl.startsWith('http')) {
              // Xử lý URL Imgur
              String processedUrl = processImgurUrl(imgUrl);
              
              myitems.add(Image.network(
                processedUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[100],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / 
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                // Hiển thị icon thay vì ảnh mặc định nếu không tải được
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[100],
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey[400]
                      ),
                    ),
                  );
                },
              ));
            } else {
              // Đường dẫn local
              myitems.add(
                Image.asset(
                imgUrl,
                fit: BoxFit.contain,
                // Hiển thị icon thay vì ảnh mặc định nếu không tải được
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[100],
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey[400]
                      ),
                    ),
                  );
                },
              ));
            }
          }
        }
      }
    }
  }

  @override
  void didUpdateWidget(MyImageSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product != widget.product) {
      _initializeImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Trường hợp không có ảnh nào
    if (myitems.isEmpty) {
      myitems = [
        Container(
          color: Colors.grey[100],
          child: Center(
            child: Icon(
              Icons.image_not_supported,
              size: 50,
              color: Colors.grey[400],
            ),
          ),
        ),
      ];
    }

    return Column(
      children: [
        // Hình ảnh chính hiển thị
        Container(
          width: double.infinity,
          height: 300, // Tăng chiều cao cho hình ảnh chính
          child: PageView.builder(
            controller: _pageController,
            itemCount: myitems.length,
            onPageChanged: (index) {
              setState(() {
                myCurrentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: myitems[index],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12),

        // Danh sách ảnh thumbnail cho phép chọn
        Container(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: myitems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    myCurrentIndex = index;
                    _pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 65,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: index == myCurrentIndex
                          ? appTheme.deepPurpleA100
                          : Colors.grey.shade200,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: myitems[index],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
