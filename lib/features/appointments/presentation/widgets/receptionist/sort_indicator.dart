import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SortIndicator extends StatelessWidget {
  final String? selectedDoctorName;
  final VoidCallback? onClear;

  const SortIndicator({super.key, required this.selectedDoctorName, this.onClear});

  @override
  Widget build(BuildContext context) {
    if (selectedDoctorName == null) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.medical_services_rounded, color: theme.colorScheme.primary, size: 18),
          const SizedBox(width: 8),
          Text(
            '${'sorted_by'.tr()}: $selectedDoctorName',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          if (onClear != null) ...[
            const Spacer(),
            GestureDetector(
              onTap: onClear,
              child: Icon(Icons.close_rounded, color: theme.colorScheme.primary, size: 18),
            ),
          ],
        ],
      ),
    );
  }
}
