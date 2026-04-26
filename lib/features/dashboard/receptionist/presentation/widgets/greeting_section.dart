import 'package:flutter/material.dart';
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

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  IconData get _greetingIcon {
    final hour = DateTime.now().hour;
    if (hour < 12) return Icons.wb_sunny_rounded;
    if (hour < 17) return Icons.wb_cloudy_rounded;
    return Icons.nightlight_round;
  }

  String get _shiftTimeRange {
    return '${_formatTime(shiftStart)} - ${_formatTime(shiftEnd)}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Color get _statusColor {
    switch (shiftStatus) {
      case 'Active':
        return AppColors.medicalGreen;
      case 'Break':
        return AppColors.accent;
      default:
        return AppColors.gray500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(_greetingIcon, size: 26, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '$_greeting, $receptionistName 👋',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _statusChip(context),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.schedule, color: AppColors.gray500, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      _shiftTimeRange,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.gray700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(BuildContext context) {
    final color = _statusColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha((0.16 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        shiftStatus,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
