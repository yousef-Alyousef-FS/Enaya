import 'package:flutter/widgets.dart';

class ResponsiveGridConfig {
  final int crossAxisCount;
  final double spacing;
  final double itemWidth;

  const ResponsiveGridConfig({
    required this.crossAxisCount,
    required this.spacing,
    required this.itemWidth,
  });

  factory ResponsiveGridConfig.fromConstraints(BoxConstraints constraints) {
    final maxWidth = constraints.maxWidth;

    const spacing = 10.0;

    // 🔥 الحد الأدنى لعرض الكارد (مهم جدًا)
    const minItemWidth = 180.0;
    const maxItemWidth = 280.0;

    // 🔥 حساب أولي ديناميكي
    int count = (maxWidth / minItemWidth).floor();

    // 🔥 حماية من التطرف
    count = count.clamp(1, 6);

    // 🔥 إعادة حساب العرض الحقيقي بعد توزيع المسافات
    final totalSpacing = spacing * (count - 1);
    final availableWidth = maxWidth - totalSpacing;

    double itemWidth = availableWidth / count;

    // 🔥 حماية إضافية للعرض
    itemWidth = itemWidth.clamp(minItemWidth, maxItemWidth);

    // 🔥 إعادة ضبط count إذا لزم الأمر بعد clamp
    count = (maxWidth / itemWidth).floor().clamp(1, 6);

    //من اجل تخطي 3
    count == 3 ? count = 2: count = count;

    return ResponsiveGridConfig(
      crossAxisCount: count,
      spacing: spacing,
      itemWidth: itemWidth,
    );
  }

  double get crossAxisSpacing => spacing;
  double get mainAxisSpacing => spacing;
}