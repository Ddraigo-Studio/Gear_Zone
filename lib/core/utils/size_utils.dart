import 'package:flutter/material.dart';

// These are the Viewport values of your Figma Design.
const num FIGMA_DESIGN_WIDTH = 390;
const num FIGMA_DESIGN_HEIGHT = 844;
const num FIGMA_DESIGN_STATUS_BAR = 0;

extension ResponsiveExtension on num {
  double get _width => SizeUtils.width;
  // Screen ratio with proper proportional scaling for desktop
  double get _screenRatio {
    if (SizeUtils.deviceType == DeviceType.desktop) {
      // For desktop, we want larger proportional scaling
      return (_width / 1440).clamp(0.9, 1.2); // Increased for proper desktop scaling proportional to screen size
    } else if (SizeUtils.deviceType == DeviceType.tablet) {
      // For tablet, use a ratio between mobile and desktop
      return (_width / 768).clamp(0.8, 1.0); // Using 768px as reference for tablet
    } else {
      // For mobile, use the original design width
      return _width / FIGMA_DESIGN_WIDTH;
    }
  }
  
  // Height and general sizing - adjusted for device type
  double get h => (this * _screenRatio);
  // Font sizes - with proper proportional scaling for desktop
  double get fSize {
    if (SizeUtils.deviceType == DeviceType.desktop) {
      return (this * 1.1).clamp(this * 1.0, this * 1.2); // Larger fonts for desktop
    } else if (SizeUtils.deviceType == DeviceType.tablet) {
      return (this * 0.95).clamp(this * 0.9, this * 1.0); // Medium fonts for tablet
    } else {
      return (this * 0.85).clamp(this * 0.8, this * 0.9); // Smaller scaling for mobile
    }
  }
}

extension FormatExtension on double {
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }

  double isNonZero({num defaultValue = 0.0}) {
    return this > 0 ? this : defaultValue.toDouble();
  }
}

enum DeviceType { mobile, tablet, desktop }

typedef ResponsiveBuild = Widget Function(
  BuildContext context,
  Orientation orientation,
  DeviceType deviceType,
);

class Sizer extends StatelessWidget {
  const Sizer({super.key, required this.builder});

  /// Builds the widget whenever the orientation changes.
  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeUtils.setScreenSize(constraints, orientation);
        return builder(context, orientation, SizeUtils.deviceType);
      });
    });
  }
}

// ignore_for_file: must_be_immutable
class SizeUtils {
  /// Device's BoxConstraints
  static late BoxConstraints boxConstraints;

  /// Device's Orientation
  static late Orientation orientation;

  /// Type of Device
  static late DeviceType deviceType;

  /// Device's Height
  static late double height;

  /// Device's Width
  static late double width;
  static void setScreenSize(
    BoxConstraints constraints,
    Orientation currentOrientation,
  ) {
    boxConstraints = constraints;
    orientation = currentOrientation;
    
    // Set width and height based on orientation
    if (orientation == Orientation.portrait) {
      width = boxConstraints.maxWidth.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      height = boxConstraints.maxHeight.isNonZero();
    } else {
      width = boxConstraints.maxHeight.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      height = boxConstraints.maxWidth.isNonZero();
    }
    
    // Detect device type based on width and adjust for desktop breakpoints
    final maxWidth = boxConstraints.maxWidth;
    
    // Better device type detection:
    // Desktop: 1200px and above
    // Tablet: 700px to 1199px
    // Mobile: below 700px
    if (maxWidth >= 1200) {
      deviceType = DeviceType.desktop;
    } else if (maxWidth >= 700) {
      deviceType = DeviceType.tablet;
    } else {
      deviceType = DeviceType.mobile;
    }
    
    // Print debug info
    print('Device Type: $deviceType, Width: $width, Height: $height');
  }  /// Helper method to calculate proportional width based on device type
  static double getProportionalWidth(double size) {
    double factor = 1.0;
    
    if (deviceType == DeviceType.desktop) {
      // On desktop, we want a more proportional scaling that's larger than mobile
      factor = (width / 1440).clamp(0.8, 1.0); // Increased for proper desktop scaling
    } else if (deviceType == DeviceType.tablet) {
      // On tablet, scale slightly more than mobile
      factor = (width / 768).clamp(0.7, 0.9); // Using 768px as reference width for tablet
    } else {
      // On mobile, use the direct proportion
      factor = width / FIGMA_DESIGN_WIDTH;
    }
    
    return size * factor;
  }
  /// Get a scale factor based on screen width
  static double getScaleFactor() {
    if (deviceType == DeviceType.desktop) {
      return 1.0; // Desktop now gets proper scaling for consistent proportions
    } else if (deviceType == DeviceType.tablet) {
      return 0.9; // Tablet gets slightly smaller than desktop
    } else {
      return 0.8; // Mobile is now smaller than desktop
    }
  }
    /// Get optimal number of grid items in a row based on screen width
  static int getGridItemCount() {
    if (deviceType == DeviceType.desktop) {
      // For desktop view, fit more items by using fixed values:
      // For smaller screens (1200-1599px): 5 items
      // For medium screens (1600-1999px): 6 items
      // For large screens (2000px+): 7 items
      if (width >= 2000) {
        return 7;
      } else if (width >= 1600) {
        return 6;
      } else {
        return 5;
      }
    } else if (deviceType == DeviceType.tablet) {
      return 10; // Tablets always show 3 items per row
    } else {
      return 10; // Mobile always shows 2 items per row
    }
  }
}
