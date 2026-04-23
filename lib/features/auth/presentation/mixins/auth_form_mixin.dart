import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin AuthFormMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late AnimationController successAnimationController;
  late Animation<double> successAnimation;
  String? errorMessage;
  bool isNavigating = false;

  @override
  void initState() {
    super.initState();
    _initializeSuccessAnimation();
  }

  void _initializeSuccessAnimation() {
    successAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    successAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: successAnimationController, curve: Curves.easeInOut));
  }

  Widget buildErrorMessage() {
    return errorMessage != null
        ? Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          )
        : const SizedBox.shrink();
  }

  @override
  void dispose() {
    successAnimationController.dispose();
    super.dispose();
  }
}
