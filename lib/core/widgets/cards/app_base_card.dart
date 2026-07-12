import 'package:flutter/material.dart';

/// A standardized card component following Material 3 principles.
/// [CORE_REFINE]: Updated to use surfaceTintColor and modern shadow handling.
class AppBaseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double borderRadius;
  final double elevation;
  final BorderSide? borderSide;
  final VoidCallback? onTap;
  final Clip clipBehavior;

  const AppBaseCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.backgroundColor,
    this.gradient,
    this.borderRadius = 20, // Increased default radius for modern look
    this.elevation = 0, // Lower elevation, better outline focus for M3
    this.borderSide,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget content = Container(
      padding: padding,
      margin: margin,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? theme.colorScheme.surface) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderSide != null ? Border.fromBorderSide(borderSide!) : Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: isDark ? 0.2 : 0.5),
          width: 1,
        ),
        boxShadow: elevation > 0 ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.05),
            blurRadius: elevation * 4,
            offset: Offset(0, elevation * 2),
          )
        ] : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      );
    }

    return content;
  }
}
