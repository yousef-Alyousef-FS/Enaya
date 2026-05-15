import 'package:flutter/material.dart';

/// A standardized card component to ensure consistent shadows, borders, and radii.
///
/// It supports solid background and gradient styles.
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
    this.borderRadius = 16,
    this.elevation = 4,
    this.borderSide,
    this.onTap,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = Container(
      padding: padding,
      margin: margin,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: gradient == null
            ? (backgroundColor ?? theme.colorScheme.surface)
            : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderSide != null
            ? Border.fromBorderSide(borderSide!)
            : Border.all(
                color: theme.colorScheme.outlineVariant.withAlpha(120),
              ),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: theme.shadowColor.withAlpha(
                    (theme.brightness == Brightness.dark
                            ? elevation * 1.5
                            : elevation * 2)
                        .round()
                        .clamp(0, 255),
                  ),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                ),
              ]
            : null,
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
