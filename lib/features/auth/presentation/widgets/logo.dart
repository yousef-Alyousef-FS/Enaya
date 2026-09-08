import 'package:enaya/core/widgets/loaders/app_loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoIcon extends StatelessWidget {
  final Color? color;
  final double? width;
  final double? height;
  const LogoIcon({super.key, this.color, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logo.svg',
      width: width ?? 200,
      height: height ?? 200,
      placeholderBuilder: (context) => AppLoaders.splash(),
    );
  }
}
