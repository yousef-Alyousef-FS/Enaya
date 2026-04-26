import 'package:flutter/material.dart';
import '../constants/layout_breakpoints.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < LayoutBreakpoints.mobileMaxWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= LayoutBreakpoints.mobileMaxWidth &&
      MediaQuery.of(context).size.width < LayoutBreakpoints.desktopMinWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= LayoutBreakpoints.desktopMinWidth;

  // Media Query Helpers
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
}

extension ResponsiveExtension on BuildContext {
  bool get isMobile => ResponsiveHelper.isMobile(this);
  bool get isTablet => ResponsiveHelper.isTablet(this);
  bool get isDesktop => ResponsiveHelper.isDesktop(this);

  double get width => ResponsiveHelper.screenWidth(this);
  double get height => ResponsiveHelper.screenHeight(this);
}
