import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResponsiveUtils {
  static double get screenWidth => Get.width;
  static double get screenHeight => Get.height;
  
  // Screen size categories
  static bool get isSmallScreen => screenWidth < 360;
  static bool get isMediumScreen => screenWidth >= 360 && screenWidth < 400;
  static bool get isLargeScreen => screenWidth >= 400;
  
  // Dynamic padding based on screen size
  static double get basePadding => isSmallScreen ? 12.0 : isMediumScreen ? 16.0 : 20.0;
  static double get cardPadding => isSmallScreen ? 12.0 : 16.0;
  static double get sectionSpacing => isSmallScreen ? 16.0 : 20.0;
  
  // Dynamic font sizes
  static double get titleFontSize => isSmallScreen ? 20.0 : isMediumScreen ? 22.0 : 24.0;
  static double get headingFontSize => isSmallScreen ? 16.0 : 18.0;
  static double get bodyFontSize => isSmallScreen ? 14.0 : 16.0;
  static double get captionFontSize => isSmallScreen ? 12.0 : 14.0;
  
  // Dynamic sizes
  static double get buttonHeight => isSmallScreen ? 44.0 : 48.0;
  static double get iconSize => isSmallScreen ? 20.0 : 24.0;
  static double get avatarSize => isSmallScreen ? 40.0 : 48.0;
  
  // Calendar specific
  static double get calendarCellSize => (screenWidth - (basePadding * 2) - 48) / 7;
  static double get progressWidgetSize => screenWidth * 0.4; // 40% of screen width
  
  // Medicine card specific
  static double get medicineCardHeight => isSmallScreen ? 80.0 : 100.0;
  
  // Bottom sheet max height
  static double get bottomSheetMaxHeight => screenHeight * 0.8;
  
  // Grid spacing
  static double get gridSpacing => isSmallScreen ? 8.0 : 12.0;
  
  // Safe area helpers
  static EdgeInsets get safePadding => EdgeInsets.only(
    top: Get.mediaQuery.padding.top,
    bottom: Get.mediaQuery.padding.bottom,
  );
  
  static EdgeInsets get screenPadding => EdgeInsets.all(basePadding);
  
  static EdgeInsets get cardMargin => EdgeInsets.symmetric(
    horizontal: basePadding,
    vertical: basePadding / 2,
  );
}