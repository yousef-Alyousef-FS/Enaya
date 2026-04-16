import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../mixins/responsive_layout_mixin.dart';
import '../theme/app_colors.dart';

class AuthCardContainer extends StatelessWidget {
  final ResponsiveLayoutConfig config;
  final List<Widget> children;
  final int gradientAlpha;

  const AuthCardContainer({
    super.key,
    required this.config,
    required this.children,
    this.gradientAlpha = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withAlpha(gradientAlpha),
                  Theme.of(context).scaffoldBackgroundColor,
                ],
              ),
            ),
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: config.cardMaxWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: config.cardHorizontalPadding,
                vertical: config.scrollVerticalPadding,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(
                    config.isPortrait ? 28.r : 20.r,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 26,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: config.cardHorizontalPadding,
                  vertical: config.cardVerticalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
