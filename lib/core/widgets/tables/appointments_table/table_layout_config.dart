import 'package:flutter/material.dart';

enum TableDeviceType { mobile, tablet, desktop }
class TableLayoutConfig {
  final TableDeviceType type;
  final double spacing;
  final bool isMobile;
  final bool isTablet;

  const TableLayoutConfig({
    required this.type,
    required this.spacing,
    required this.isMobile,
    required this.isTablet,
  });

  factory TableLayoutConfig.fromWidth(double width) {
    if (width < 500) {
      return TableLayoutConfig(
        type: TableDeviceType.mobile,
        spacing: width * 0.04, // ديناميكي
        isMobile: true,
        isTablet: false,
      );
    } else if (width < 1100) {
      return TableLayoutConfig(
        type: TableDeviceType.tablet,
        spacing: width * 0.03, // ديناميكي
        isMobile: false,
        isTablet: true,
      );
    } else {
      return TableLayoutConfig(
        type: TableDeviceType.desktop,
        spacing: width * 0.02, // ديناميكي
        isMobile: false,
        isTablet: false,
      );
    }
  }
}
