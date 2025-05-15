import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Thêm hàm xử lý URL Imgur
String processImgurUrl(String url) {
  String processedUrl = url;
  
  // Nếu URL thuộc imgur.com nhưng không phải định dạng i.imgur.com
  if (url.contains('imgur.com') && !url.contains('i.imgur.com')) {
    // Trường hợp 1: URL kiểu https://imgur.com/abcd123
    if (!url.endsWith('.jpg') && !url.endsWith('.png') && !url.endsWith('.gif') && !url.endsWith('.jpeg')) {
      // Lấy ID hình ảnh
      String imgId = url.split('/').last;
      // Xóa phần query parameters nếu có
      imgId = imgId.split('?').first;
      // Tạo URL mới với định dạng i.imgur.com
      processedUrl = 'https://i.imgur.com/$imgId.png';
    } 
    // Trường hợp 2: URL kiểu https://imgur.com/abcd123.jpg
    else {
      processedUrl = url.replaceFirst('imgur.com', 'i.imgur.com');
    }
  }
  
  return processedUrl;
}

extension ImageTypeExtension on String {
  ImageType get imageType {
    // Check if the string is empty before processing
    if (this.isEmpty) {
      return ImageType.unknown;
    }
    
    // Check for network images first (URLs)
    if (this.startsWith('http') || this.startsWith('https')) {
      return ImageType.network;
    } 
    // Check for SVG files
    else if (this.endsWith('.svg')) {
      return ImageType.svg;
    } 
    // Check for file:// protocol
    else if (this.startsWith('file://')) {
      return ImageType.file;
    } 
    // Default to PNG/local asset
    else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file, unknown }

class CustomImageView extends StatelessWidget {
  const CustomImageView({
    super.key, 
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'assets/images/img_logo.png',
  });

  /// [imagePath] is required parameter for showing image
  final String? imagePath;

  final double? height;

  final double? width;

  final Color? color;

  final BoxFit? fit;

  final String placeHolder;

  final Alignment? alignment;

  final VoidCallback? onTap;

  final EdgeInsetsGeometry? margin;

  final BorderRadius? radius;

  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment!, child: _buildWidget())
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  /// build the image with border radius
  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  /// build the image with border and border radius style
  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }  Widget _buildImageView() {    if (imagePath == null || imagePath!.isEmpty) {
      return Container(
        height: height,
        width: width,
        color: Colors.grey[100],
        child: Center(
          child: Icon(
            Icons.image_not_supported,
            size: height != null ? height! * 0.3 : 24,
            color: Colors.grey[400],
          ),
        ),
      );
    }
  
    switch (imagePath!.imageType) {
      case ImageType.svg:
        return Container(
          height: height,
          width: width,
          child: SvgPicture.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.contain,
            colorFilter: this.color != null
                ? ColorFilter.mode(
                    this.color ?? Colors.transparent, BlendMode.srcIn)
                : null,
          ),
        );

      case ImageType.file:
        return Image.file(
          File(imagePath!),
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
        );          case ImageType.network:
        // Kiểm tra lại nếu đường dẫn rỗng (mặc dù đã kiểm tra ở trên nhưng đề phòng)
        if (imagePath == null || imagePath!.isEmpty) {
          return Container(
            height: height,
            width: width,
            color: Colors.grey[100],
            child: Center(
              child: Icon(
                Icons.image_not_supported,
                size: height != null ? height! * 0.3 : 24,
                color: Colors.grey[400],
              ),
            ),
          );
        }
          try {
          // Sử dụng Image.network thay vì CachedNetworkImage do CachedNetworkImage bị lỗi
          final processedUrl = processImgurUrl(imagePath!);
          return Image.network(
            processedUrl,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: height,
                width: width,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null && loadingProgress.expectedTotalBytes! > 0
                        ? loadingProgress.cumulativeBytesLoaded / 
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              // Không in ra log lỗi nếu không cần thiết
              return Container(
                height: height,
                width: width,
                color: Colors.grey[100],
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: height != null ? height! * 0.3 : 24,
                    color: Colors.grey[400],
                  ),
                ),
              );
            },
          );
        } catch (e) {
          // Xử lý mọi lỗi trong quá trình xử lý URL hoặc tạo widget
          return Container(
            height: height,
            width: width,
            color: Colors.grey[100],
            child: Center(
              child: Icon(
                Icons.broken_image,
                size: height != null ? height! * 0.3 : 24,
                color: Colors.grey[400],
              ),
            ),
          );
        }
          case ImageType.png:
      case ImageType.unknown:
        return Image.asset(
          imagePath!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
        );
    }
    
  }
}