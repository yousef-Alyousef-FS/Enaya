import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../theme/app_colors.dart';

class AppLoaders {
  static Widget buttonLoader({Color color = Colors.white, double size = 25.0}) {
    return SpinKitThreeBounce(
      color: color,
      size: size,
    );
  }

  static Widget screenLoader() {
    return const Center(
      child: SpinKitDoubleBounce(
        color: AppColors.primary,
        size: 50.0,
      ),
    );
  }

  static Widget splashLoader() {
    return const SpinKitFoldingCube(
      color: Colors.white,
      size: 40.0,
    );
  }
}
