import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:enaya/core/widgets/loaders/app_loaders.dart';

class LogoIcon extends StatelessWidget {
  final Color? color;
  final double? width;
  final double? height;
  const LogoIcon({super.key, this.color, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/enaya.svg',
      width: width ?? 200,
      height: height ?? 200,
      colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.primary,
        BlendMode.srcIn,
      ),
      placeholderBuilder: (context) => AppLoaders.splash(),
    );
  }
}
