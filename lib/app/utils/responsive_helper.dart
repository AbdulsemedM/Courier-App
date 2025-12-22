import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Breakpoints
  static const double tabletBreakpoint = 600.0;
  static const double desktopBreakpoint = 1200.0;

  // Check if device is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tabletBreakpoint && width < desktopBreakpoint;
  }

  // Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  // Check if device is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < tabletBreakpoint;
  }

  // Get responsive width
  static double getResponsiveWidth(BuildContext context, {
    double mobile = 1.0,
    double? tablet,
    double? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (isDesktop(context) && desktop != null) {
      return width * desktop;
    } else if (isTablet(context) && tablet != null) {
      return width * tablet;
    }
    return width * mobile;
  }

  // Get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context, {
    EdgeInsets mobile = const EdgeInsets.all(16.0),
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  // Get responsive grid cross axis count
  static int getGridCrossAxisCount(BuildContext context, {
    required int mobile,
    int? tablet,
    int? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  // Get responsive font size
  static double getResponsiveFontSize(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  // Get max content width for centered layouts
  static double getMaxContentWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 1200.0;
    } else if (isTablet(context)) {
      return 800.0;
    }
    return double.infinity;
  }
}


