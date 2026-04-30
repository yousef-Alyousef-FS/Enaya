import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class SectionWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const SectionWrapper({super.key, required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
      ),
      child: child,
    );
  }
}
