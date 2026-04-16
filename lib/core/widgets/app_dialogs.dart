import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppDialogs {
  static void showError(BuildContext context, {required String message}) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: 'error'.tr(),
      desc: message,
      btnOkText: 'ok'.tr(),
      btnOkOnPress: () {},
      btnOkColor: Colors.red,
    ).show();
  }

  static void showSuccess(BuildContext context, {required String message, VoidCallback? onConfirm}) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: 'success'.tr(),
      desc: message,
      btnOkText: 'ok'.tr(),
      btnOkOnPress: onConfirm,
    ).show();
  }

  static void showWarning(BuildContext context, {required String message}) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'warning'.tr(),
      desc: message,
      btnOkText: 'ok'.tr(),
      btnOkOnPress: () {},
    ).show();
  }

  static void showConfirm(BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: title,
      desc: message,
      btnCancelText: 'cancel'.tr(),
      btnOkText: 'confirm'.tr(),
      btnCancelOnPress: () {},
      btnOkOnPress: onConfirm,
    ).show();
  }
}
