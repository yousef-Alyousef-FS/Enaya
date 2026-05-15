import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A standardized text field used across the application to ensure visual consistency.
/// It follows the Enaya design system with specific border radius, colors, and padding.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? errorText;
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onSubmitted,
    this.errorText,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.minLines,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final textField = TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          minLines: minLines,
          focusNode: focusNode,
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 15,
            height: 1.2,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : AppColors.gray400,
              fontSize: 14,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorText: errorText,
            filled: true,
            fillColor: isDark ? AppColors.darkSurface : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            isDense: true,

            // Default Border
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? AppColors.gray700 : AppColors.gray200),
            ),

            // Enabled Border
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? AppColors.gray700 : AppColors.gray200),
            ),

            // Focused Border
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),

            // Error Border
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.medicalRed),
            ),
          ),
        );

        // If label, wrap textField in Column with label and spacing
        if (label != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.secondary,
                ),
              ),
              const SizedBox(height: 8),
              textField,
            ],
          );
        }

        return textField;
      },
    );
  }
}
