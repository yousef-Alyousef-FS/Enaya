import 'package:flutter/material.dart';

import '../layout/responsive_layout.dart';
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
    final layout = ResponsiveLayout.of(context);

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
            constraints: BoxConstraints(maxWidth: layout.cardMaxWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: layout.cardHorizontalPadding,
                vertical: layout.scrollVerticalPadding,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(layout.isPortrait ? 24 : 16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 26,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: layout.cardHorizontalPadding,
                  vertical: layout.cardVerticalPadding,
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
