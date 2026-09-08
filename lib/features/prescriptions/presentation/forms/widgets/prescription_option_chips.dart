import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Reusable chip list widget used for dosage, frequency, and instruction suggestions.
/// Keeps UI clean and separated from the main form.
class PrescriptionOptionChips extends StatelessWidget {
  final String label;
  final List<String> options;
  final ValueChanged<String> onSelected;

  const PrescriptionOptionChips({
    super.key,
    required this.label,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.gray500,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,

          // ⭐ FIXED: show the actual translated option, not "option"
          children: options.map((option) {
            return ChoiceChip(
              label: Text(option.tr()),

              selected: false,
              onSelected: (_) => onSelected(option),

              backgroundColor: isDark
                  ? AppColors.darkSurfaceSoft
                  : AppColors.gray50,
              selectedColor: AppColors.primary.withValues(alpha: 0.15),

              labelStyle: TextStyle(
                color: isDark ? Colors.white : AppColors.gray800,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
