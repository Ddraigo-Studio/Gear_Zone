import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    this.placeHolder = 'assets/images/image_not_found.png',
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
  }  Widget _buildImageView() {
    if (imagePath == null || imagePath!.isEmpty) {
      return Image.asset(
        placeHolder,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
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
        );
        
      case ImageType.network:
        // For web platform, use Image.network directly
        if (imagePath == null || imagePath!.isEmpty) {
          return Image.asset(
            placeHolder,
            height: height,
            width: width,
            fit: fit,
            color: color,
          );
        }
        
        // Use regular Image.network instead of CachedNetworkImage for web
        return Image.network(
          imagePath!,
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
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / 
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              placeHolder,
              height: height,
              width: width,
              fit: fit ?? BoxFit.cover,
            );
          },
        );
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
    
    // This code should not be reached unless there's an error
    return Image.asset(
      placeHolder,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
    );
  }
}