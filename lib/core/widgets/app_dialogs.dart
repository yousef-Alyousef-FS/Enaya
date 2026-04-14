import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class AppDialogs {
  static void showError(BuildContext context, {required String message}) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: 'Error',
      desc: message,
      btnOkOnPress: () {},
      btnOkColor: Colors.red,
    ).show();
  }

  static void showSuccess(BuildContext context, {required String message, VoidCallback? onConfirm}) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: 'Success',
      desc: message,
      btnOkOnPress: onConfirm,
    ).show();
  }

  static void showWarning(BuildContext context, {required String message}) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'Warning',
      desc: message,
      btnOkOnPress: () {},
    ).show();
  }
}
