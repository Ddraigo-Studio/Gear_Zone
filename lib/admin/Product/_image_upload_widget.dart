import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:gear_zone/widgets/custom_image_view.dart';

class ImageUploadBox extends StatelessWidget {
  final String label;
  final int? index;
  final List<File> imageFiles;
  final List<String> imageUrls;
  final bool isViewOnly;
  final Function(int) onPickImage;
  final Function(int) onRemoveImage;

  const ImageUploadBox({
    super.key,
    required this.label,
    this.index,
    required this.imageFiles,
    required this.imageUrls,
    required this.isViewOnly,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    // Check if we have an image file or URL for this index
    bool hasFile = index != null && 
        imageFiles.length > index! && 
        imageFiles[index!].path.isNotEmpty;
    
    bool hasUrl = index != null && 
        imageUrls.length > index! && 
        imageUrls[index!].isNotEmpty;
    
    return InkWell(
      onTap: isViewOnly ? null : () => index != null ? onPickImage(index!) : null,
      child: Stack(
        children: [
          DottedBorder(
            color: Colors.blue.shade200,
            strokeWidth: 1.5,
            dashPattern: [6, 3], // 6px line, 3px gap
            borderType: BorderType.RRect,
            radius: const Radius.circular(4),
            child: Container(
              height: 80,
              width: double.infinity,
              child: hasFile
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Image.file(
                      imageFiles[index!],
                      fit: BoxFit.contain,
                    ),
                  )
                : (hasUrl
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: CustomImageView(
                          imagePath: imageUrls[index!],
                          fit: BoxFit.contain,
                          height: 80,
                          width: double.infinity,
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
                      )),
            ),
          ),
          
          // Only show edit/delete buttons when not in view-only mode and there's an image
          if (!isViewOnly && index != null && (hasFile || hasUrl))
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => onPickImage(index!),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.edit_outlined, size: 16),
                      ),
                    ),
                    const SizedBox(width: 2),
                    InkWell(
                      onTap: () => onRemoveImage(index!),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
