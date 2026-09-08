import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Centralized loading widgets for common UI contexts.
class AppLoaders {
  /// Small loader suitable for buttons.
  static Widget inline({Color? color, double size = 18}) {
    return Builder(
      builder: (context) => SpinKitChasingDots(
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      ),
    );
  }

  /// Loader for compact contexts (e.g. small panels).
  static Widget button({Color? color, double size = 22.0}) {
    return Builder(
      builder: (context) => SpinKitThreeBounce(
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      ),
    );
  }

  /// Full-screen centered loader.
  static Widget screen({Color? color, double size = 45.0}) {
    return Center(
      child: Builder(
        builder: (context) => SpinKitDoubleBounce(
          color: color ?? Theme.of(context).primaryColor,
          size: size,
        ),
      ),
    );
  }

  /// Splash-style loader used on the intro screen.
  static Widget splash({Color? color, double size = 40.0}) {
    return Builder(
      builder: (context) => SpinKitFoldingCube(
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      ),
    );
  }

  /// Overlay loader that covers the screen with a translucent background.
  static Widget overlay({Color? background, Color? loaderColor}) {
    return Builder(
      builder: (context) {
        final bg = background ?? Colors.black54;
        final lc = loaderColor ?? Theme.of(context).primaryColor;
        return Container(
          color: bg,
          child: Center(child: SpinKitCircle(color: lc, size: 55)),
        );
      },
    );
  }
}
