import 'package:enaya/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable dashboard statistic card used to display key metrics
/// such as number of patients, appointments, completed tasks, etc.
///
/// The card includes:
/// - Title (small label)
/// - Main value (highlighted number)
/// - Subtitle (additional context)
/// - Icon with accent background
/// - Optional tap interaction
class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    /// The main card UI
    final card = Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.03 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: accentColor.withAlpha((0.16 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 18, color: accentColor),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 6.h),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.gray600)),
        ],
      ),
    );

    /// If no onTap is provided, return a static card
    if (onTap == null) return card;

    /// If onTap exists, wrap card with InkWell for interaction
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18), child: card);
  }
}
