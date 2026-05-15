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
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = Theme.of(context);
        final cs = theme.colorScheme;
        final finalHeight =
            height ?? (constraints.maxHeight.isFinite ? constraints.maxHeight : 48.0);

        final decoration = InputDecoration(
          hintText: hint ?? 'search_patient'.tr(),
          hintStyle: TextStyle(fontSize: 14, color: cs.onSurfaceVariant.withAlpha(160)),
          prefixIcon: Icon(Icons.search_rounded, size: 20, color: cs.primary),
          suffixIcon: controller != null && controller!.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, size: 18, color: cs.onSurfaceVariant),
                  onPressed: () {
                    controller!.clear();
                    if (onClear != null) onClear!();
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          filled: true,
          fillColor: cs.surface,
          constraints: BoxConstraints.tightFor(height: finalHeight),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.primary, width: 1.5),
          ),
        );

        final field = TextFormField(
          controller: controller,
          onChanged: onChanged,
          decoration: decoration,
        );

        // Enforce parent's height so the field expands when wrapped in SizedBox(height: ...)
        return SizedBox(width: double.infinity, height: finalHeight, child: field);
      },
    );
  }
}
