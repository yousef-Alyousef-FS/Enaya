import 'package:enaya/core/widgets/dialogs/app_dialogs.dart';
import 'package:flutter/material.dart';

/// Reusable UI helpers for stateful screens.
///
/// This mixin centralizes common concerns like snackbars, dialogs,
/// navigation helpers, and basic responsive flags.
mixin ScreenBaseMixin<T extends StatefulWidget> on State<T> {
  /// Shows a snackbar message.
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: duration, action: action),
    );
  }

  /// Shows an error dialog with optional retry affordance.
  void showErrorDialog(
    String message, {
    String title = 'خطأ',
    VoidCallback? onRetry,
  }) {
    AppDialogs.showError(context, message: message, dismissible: true);
  }

  /// Shows a success message and executes optional dismissal callback.
  void showSuccessMessage(String message, {VoidCallback? onDismiss}) {
    showSnackBar(message);
    onDismiss?.call();
  }

  /// Shows a confirmation dialog and returns `true` when confirmed.
  Future<bool> showConfirmDialog(
    String title,
    String message, {
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
  }) async {
    if (!mounted) {
      return false;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(cancelText),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );

    return result ?? false;

    // End confirmation dialog flow.
  }

  /// Pops current route and returns optional result.
  void pop<T>([T? result]) => Navigator.of(context).pop<T>(result);

  /// Pushes a new screen using MaterialPageRoute.
  Future<T?> push<T>(Widget screen) =>
      Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => screen));

  /// Replaces current screen with a new one.
  Future<T?> pushReplacement<T>(Widget screen) => Navigator.of(
    context,
  ).pushReplacement<T, T>(MaterialPageRoute(builder: (_) => screen));

  /// Current active theme.
  ThemeData get theme => Theme.of(context);

  /// Current media query.
  MediaQueryData get mediaQuery => MediaQuery.of(context);

  /// Current viewport size.
  Size get screenSize => mediaQuery.size;

  /// `true` when the device is currently in portrait orientation.
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  /// `true` for mobile-sized layouts.
  bool get isMobile => screenSize.width < 600;

  /// `true` for tablet-sized layouts.
  bool get isTablet => screenSize.width >= 600 && screenSize.width < 1200;

  /// `true` for desktop-sized layouts.
  bool get isDesktop => screenSize.width >= 1200;
}
