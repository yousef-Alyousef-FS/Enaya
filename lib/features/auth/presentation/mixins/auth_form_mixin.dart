import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/view_models/base_view_model.dart';

mixin AuthFormMixin<T extends StatefulWidget>
  on State<T>, TickerProviderStateMixin<T> {
  late AnimationController successAnimationController;
  late Animation<double> successAnimation;
  String? errorMessage;

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
    successAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: successAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void handleAuthStateChange(BaseViewModel viewModel, VoidCallback onSuccess) {
    if (viewModel.state == ViewState.error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(
          () => errorMessage = viewModel.errorMessage ?? 'error_occurred'.tr(),
        );
        viewModel.resetState();
      });
    }
    if (viewModel.state == ViewState.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // نغير الحالة فوراً لمنع التكرار (Race Condition)
        viewModel.resetState();
        setState(() => errorMessage = null);
        successAnimationController.forward().then((_) {
          if (mounted) {
            onSuccess();
            // نعيد الأنيميشن لوضعه الطبيعي للمرة القادمة
            successAnimationController.reverse();
          }
        });
      });
    }
  }

  Widget buildErrorMessage() {
    return errorMessage != null
        ? Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              errorMessage!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 14,
              ),
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
