/// Screen Base Mixin
/// يوفر helper methods مشتركة لجميع الشاشات
import 'package:enaya/core/widgets/dialogs/app_dialogs.dart';
import 'package:flutter/material.dart';

mixin ScreenBaseMixin<T extends StatefulWidget> on State<T> {
  /// إظهار رسالة Snack Bar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), duration: duration, action: action));
  }

  /// إظهار رسالة خطأ Dialog
  void showErrorDialog(String message, {String title = 'خطأ', VoidCallback? onRetry}) {
    AppDialogs.showError(context, message: message, dismissible: true);
  }

  /// إظهار رسالة نجاح
  void showSuccessMessage(String message, {VoidCallback? onDismiss}) {
    showSnackBar(message);
    onDismiss?.call();
  }

  /// إظهار Dialog تأكيد
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
  }

  /// الرجوع إلى الشاشة السابقة مع نتيجة
  void pop<T>([T? result]) => Navigator.of(context).pop<T>(result);

  /// الذهاب إلى شاشة جديدة
  Future<T?> push<T>(Widget screen) =>
      Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => screen));

  /// استبدال الشاشة الحالية
  Future<T?> pushReplacement<T>(Widget screen) =>
      Navigator.of(context).pushReplacement<T, T>(MaterialPageRoute(builder: (_) => screen));

  /// الحصول على theme
  ThemeData get theme => Theme.of(context);

  /// الحصول على media query
  MediaQueryData get mediaQuery => MediaQuery.of(context);

  /// الحصول على screen size
  Size get screenSize => mediaQuery.size;

  /// هل الشاشة في mode عمودي؟
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  /// هل الجهاز جوال؟
  bool get isMobile => screenSize.width < 600;

  /// هل الجهاز tablet؟
  bool get isTablet => screenSize.width >= 600 && screenSize.width < 1200;

  /// هل الجهاز desktop؟
  bool get isDesktop => screenSize.width >= 1200;
}
