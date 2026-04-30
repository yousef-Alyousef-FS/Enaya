import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppDialogs {
  // -----------------------------
  // 🔥 Base Dialog Builder
  // -----------------------------
  static AwesomeDialog _baseDialog(
    BuildContext context, {
    required DialogType type,
    required String title,
    required String message,
    VoidCallback? onOk,
    Color? okColor,
    bool showCancel = false,
    VoidCallback? onCancel,
    bool dismissible = true,
  }) {
    return AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.bottomSlide,
      title: title,
      desc: message,
      dismissOnTouchOutside: dismissible,
      btnOkText: 'ok'.tr(),
      btnOkOnPress: onOk,
      btnOkColor: okColor,
      btnCancelText: showCancel ? 'cancel'.tr() : null,
      btnCancelOnPress: showCancel ? onCancel : null,
    );
  }

  // -----------------------------
  // ❌ Error Dialog
  // -----------------------------
  static Future<void> showError(
    BuildContext context, {
    required String message,
    bool dismissible = true,
  }) {
    return _baseDialog(
      context,
      type: DialogType.error,
      title: 'error'.tr(),
      message: message,
      okColor: Colors.red,
      dismissible: dismissible,
    ).show();
  }

  // -----------------------------
  // ✅ Success Dialog
  // -----------------------------
  static Future<void> showSuccess(
    BuildContext context, {
    required String message,
    VoidCallback? onConfirm,
    bool dismissible = true,
  }) {
    return _baseDialog(
      context,
      type: DialogType.success,
      title: 'success'.tr(),
      message: message,
      onOk: onConfirm,
      dismissible: dismissible,
    ).show();
  }

  // -----------------------------
  // ⚠️ Warning Dialog
  // -----------------------------
  static Future<void> showWarning(
    BuildContext context, {
    required String message,
    bool dismissible = true,
  }) {
    return _baseDialog(
      context,
      type: DialogType.warning,
      title: 'warning'.tr(),
      message: message,
      dismissible: dismissible,
    ).show();
  }

  // -----------------------------
  // ❓ Confirm Dialog
  // -----------------------------
  static Future<void> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool dismissible = false,
  }) {
    return _baseDialog(
      context,
      type: DialogType.question,
      title: title,
      message: message,
      showCancel: true,
      onOk: onConfirm,
      onCancel: onCancel,
      dismissible: dismissible,
    ).show();
  }
}
