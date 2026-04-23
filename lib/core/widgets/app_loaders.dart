import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../theme/app_colors.dart';

class AppLoaders {
  /// Loader for buttons
  static Widget button({
    Color? color,
    double size = 22.0,
  }) {
    return SpinKitThreeBounce(
      color: color,
      size: size,
    );
  }

  /// Loader centered on screen
  static Widget screen({
    Color? color,
    double size = 45.0,
  }) {
    return Center(
      child: SpinKitDoubleBounce(
        color: color ?? AppColors.primary,
        size: size,
      ),
    );
  }

  /// Loader for splash screen
  static Widget splash({
    Color color = Colors.white,
    double size = 40.0,
  }) {
    return SpinKitFoldingCube(
      color: color,
      size: size,
    );
  }

  /// Overlay loader (full screen blur)
  static Widget overlay({
    Color background = Colors.black54,
    Color loaderColor = AppColors.primary,
  }) {
    return Container(
      color: background,
      child: Center(
        child: SpinKitCircle(
          color: loaderColor,
          size: 55,
        ),
      ),
    );
  }

  /// Loader for small UI elements (cards, list tiles, textfields)
  static Widget inline({
    Color? color,
    double size = 18,
  }) {
    return SpinKitChasingDots(
      color: color ?? AppColors.primary,
      size: size,
    );
  }
}
