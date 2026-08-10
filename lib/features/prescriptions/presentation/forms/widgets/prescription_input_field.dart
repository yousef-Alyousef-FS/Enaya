import 'package:flutter/material.dart';
import 'package:enaya/core/theme/app_colors.dart';

/// A reusable input field widget used inside the prescription form.
/// Keeps UI clean and separated from logic.
class PrescriptionInputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String? hint;
  final int maxLines;

  const PrescriptionInputField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: AppColors.gray500,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType:
              maxLines > 1 ? TextInputType.multiline : TextInputType.text,
          textInputAction:
              maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
          enableSuggestions: true,
          autocorrect: true,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.gray400, fontSize: 14),
            filled: true,
            fillColor:
                isDark ? AppColors.darkSurfaceSoft : AppColors.gray50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
