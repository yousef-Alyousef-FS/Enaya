import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/mixins/responsive_layout_mixin.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_loaders.dart';
import '../../../../core/widgets/auth_card_container.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with ResponsiveLayoutMixin, TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _message;
  bool _isSuccess = false;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _triggerMessage(String msg, bool success) {
    setState(() {
      _message = msg;
      _isSuccess = success;
    });
    _fadeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('change_password'.tr()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: OrientationBuilder(
            builder: (context, _) {
              final config = getResponsiveConfig(context);

              return AuthCardContainer(
                config: config,
                gradientAlpha: 41,
                children: [
                  Text(
                    'change_password'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.displayLarge?.copyWith(fontSize: config.titleFontSize),
                  ),
                  SizedBox(height: config.isPortrait ? 10.h : 8.h),
                  Text(
                    'change_password_description'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontSize: config.bodyFontSize),
                  ),
                  SizedBox(height: config.isPortrait ? 30.h : 20.h),
                  _buildForm(config),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForm(config) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AuthTextField(
            labelText: 'current_password'.tr(),
            hintText: 'current_password'.tr(),
            controller: _currentPasswordController,
            isPassword: true,
            prefixIcon: Icons.lock_clock_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) return 'enter_password'.tr();
              return null;
            },
          ),
          SizedBox(height: config.isPortrait ? 16.h : 12.h),
          AuthTextField(
            labelText: 'new_password'.tr(),
            hintText: 'new_password'.tr(),
            controller: _newPasswordController,
            isPassword: true,
            prefixIcon: Icons.lock_outline,
            validator: (value) {
              if (value == null || value.isEmpty) return 'enter_password'.tr();
              if (value.length < 6) return 'password_too_short'.tr();
              return null;
            },
          ),
          SizedBox(height: config.isPortrait ? 16.h : 12.h),
          AuthTextField(
            labelText: 'confirm_new_password'.tr(),
            hintText: 'confirm_new_password'.tr(),
            controller: _confirmPasswordController,
            isPassword: true,
            prefixIcon: Icons.lock_outline,
            validator: (value) {
              if (value == null || value.isEmpty) return 'enter_confirm_password'.tr();
              if (value != _newPasswordController.text) return 'passwords_do_not_match'.tr();
              return null;
            },
          ),
          SizedBox(height: config.isPortrait ? 20.h : 14.h),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              final cubit = context.read<AuthCubit>();

              if (state.isError) {
                _triggerMessage(state.errorMessage ?? 'error_occurred'.tr(), false);
                cubit.clearStatus();
                return;
              }

              if (state.isSuccess) {
                _triggerMessage('change_password_success'.tr(), true);
                cubit.clearStatus();
              }
            },
            builder: (context, state) {
              final cubit = context.read<AuthCubit>();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () {
                            if (!_formKey.currentState!.validate()) return;
                            setState(() => _message = null);
                            cubit.changePassword(
                              currentPassword: _currentPasswordController.text,
                              newPassword: _newPasswordController.text,
                            );
                          },
                    child: state.isLoading
                        ? AppLoaders.inline()
                        : Text(
                            'change_password'.tr(),
                            style: TextStyle(fontSize: config.buttonFontSize),
                          ),
                  ),
                  if (_message != null)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: Text(
                          _message!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _isSuccess ? Colors.green : Theme.of(context).colorScheme.error,
                            fontSize: config.bodyFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: config.isPortrait ? 6.h : 4.h),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      'cancel'.tr(),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: config.buttonFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
