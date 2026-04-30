import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:enaya/core/helpers/responsive_helper.dart';
import 'package:enaya/core/theme/app_colors.dart';

class GreetingSection extends StatelessWidget {
  final String receptionistName;
  final String shiftStatus;
  final DateTime shiftStart;
  final DateTime shiftEnd;

  const GreetingSection({
    super.key,
    required this.receptionistName,
    required this.shiftStatus,
    required this.shiftStart,
    required this.shiftEnd,
  });

  String _localizedGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'greeting_morning'.tr();
    if (hour < 17) return 'greeting_afternoon'.tr();
    return 'greeting_evening'.tr();
  }

  IconData get _greetingIcon {
    final hour = DateTime.now().hour;
    if (hour < 12) return Icons.wb_sunny_rounded;
    if (hour < 17) return Icons.wb_cloudy_rounded;
    return Icons.nightlight_round;
  }

  String _shiftTimeRange(BuildContext context) =>
      '${_formatTime(context, shiftStart)} - ${_formatTime(context, shiftEnd)}';

  String _formatTime(BuildContext context, DateTime dateTime) {
    return DateFormat.jm(context.locale.toString()).format(dateTime);
  }

  Color get _statusColor {
    switch (shiftStatus.toLowerCase()) {
      case 'active':
        return AppColors.medicalGreen;
      case 'break':
        return AppColors.accent;
      default:
        return AppColors.gray500;
    }
  }

  String _localizedShiftStatus() {
    switch (shiftStatus.toLowerCase()) {
      case 'active':
        return 'status_active'.tr();
      case 'break':
        return 'status_break'.tr();
      default:
        return shiftStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile; // if you have ResponsiveHelper
    // أو استخدم MediaQuery.of(context).size.width < 700

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الترحيب والأيقونة
                Row(
                  children: [
                    Icon(_greetingIcon, size: 26, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${_localizedGreeting(context)}, $receptionistName 👋',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // معلومات الوردية والحالة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statusChip(context),
                    Row(
                      children: [
                        const Icon(Icons.schedule, color: AppColors.gray500, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          _shiftTimeRange(context),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: AppColors.gray700),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // الجزء الأيسر: الترحيب والأيقونة
                Expanded(
                  child: Row(
                    children: [
                      Icon(_greetingIcon, size: 26, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${_localizedGreeting(context)}, $receptionistName 👋',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // الجزء الأيمن: الحالة + وقت الوردية بشكل عمودي أو أفقي حسب الحاجة
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _statusChip(context),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        const Icon(Icons.schedule, color: AppColors.gray500, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          _shiftTimeRange(context),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: AppColors.gray700),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _statusChip(BuildContext context) {
    final color = _statusColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _localizedShiftStatus(),
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
