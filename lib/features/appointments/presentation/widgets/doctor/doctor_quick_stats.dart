import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class DoctorQuickStats extends StatelessWidget {
  final int total;
  final int completed;
  final int waiting;
  final Function(int index)? onTap;
  final int? selectedIndex;

  const DoctorQuickStats({
    super.key,
    required this.total,
    required this.completed,
    required this.waiting,
    this.onTap,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            0,
            'total'.tr(),
            total.toString(),
            Theme.of(context).colorScheme.primary,
          ),
          _buildDivider(context),
          _buildStatItem(
            context,
            1,
            'waiting'.tr(),
            waiting.toString(),
            Colors.orange,
          ),
          _buildDivider(context),
          _buildStatItem(
            context,
            2,
            'completed'.tr(),
            completed.toString(),
            AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    int index,
    String label,
    String value,
    Color color,
  ) {
    final isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => onTap?.call(index),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? color
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      height: 30,
      width: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}
