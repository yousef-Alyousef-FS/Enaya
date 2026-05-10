import 'package:flutter/material.dart';

/// Shared form helpers for auth screens.
///
/// Provides a success animation controller and common error message rendering.
mixin AuthFormMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  /// Controller for subtle success transition effects.
  late AnimationController successAnimationController;

  /// Scale animation used after successful actions.
  late Animation<double> successAnimation;

  /// Last validation or server error message.
  String? errorMessage;

  /// Prevents duplicate navigation while async auth actions complete.
  bool isNavigating = false;

  @override
  void initState() {
    super.initState();
    _initializeSuccessAnimation();
  }

  /// Initializes success feedback animation.
  void _initializeSuccessAnimation() {
    successAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    successAnimation =
        Tween<double>(
          begin: 1.0,
          end: 1.0, // Disabled scale effect for better "Standard" feel
        ).animate(
          CurvedAnimation(
            parent: successAnimationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  /// Builds a compact error label when [errorMessage] is present.
  Widget buildErrorMessage() {
    return errorMessage != null
        ? Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              errorMessage!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          )
        : const SizedBox.shrink();
  }

  @override
  void dispose() {
    successAnimationController.dispose();
    super.dispose();
  }
}
