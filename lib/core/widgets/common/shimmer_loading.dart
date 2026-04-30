import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isDark
        // ignore: deprecated_member_use
        ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.3)
        : Colors.grey.shade300;

    final highlightColor = isDark
        // ignore: deprecated_member_use
        ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.15)
        : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(milliseconds: 1200),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

// Example for a Table Row Skeleton
class TableRowSkeleton extends StatelessWidget {
  const TableRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const SkeletonLoader(width: 60, height: 18),
          const SizedBox(width: 20),
          const Expanded(child: SkeletonLoader(width: double.infinity, height: 18)),
          const SizedBox(width: 20),
          const SkeletonLoader(width: 80, height: 18),
        ],
      ),
    );
  }
}
