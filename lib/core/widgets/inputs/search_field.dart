import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// A standardized search field used across the application.
class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;

  /// Triggered when clear icon is pressed.
  final VoidCallback? onClear;

  /// Optional custom hint text key/value.
  final String? hint;
  final double? height;

  const AppSearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onClear,
    this.hint,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    // Root control variable that directly affects rendered search field height.
    final finalHeight = height ?? 66.0;

    final decoration = InputDecoration(
      hintText: hint ?? 'search_patient'.tr(),
      hintStyle: TextStyle(fontSize: 14, color: cs.onSurfaceVariant.withAlpha(160)),
      prefixIcon: Icon(Icons.search_rounded, size: 20, color: cs.primary),
      prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      suffixIcon: controller != null && controller!.text.isNotEmpty
          ? IconButton(
              icon: Icon(Icons.clear_rounded, size: 18, color: cs.onSurfaceVariant),
              onPressed: () {
                controller!.clear();
                if (onClear != null) onClear!();
              },
            )
          : null,
      suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      isDense: false,
      filled: true,
      fillColor: cs.surface,
      constraints: BoxConstraints.tightFor(height: finalHeight),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: cs.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: cs.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: cs.primary, width: 1.5),
      ),
    );

    return SizedBox(
      width: double.infinity,
      height: finalHeight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          textAlignVertical: TextAlignVertical.center,
          decoration: decoration,
        ),
      ),
    );
  }
}
