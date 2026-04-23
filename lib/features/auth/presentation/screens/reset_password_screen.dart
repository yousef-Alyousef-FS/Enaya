import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/mixins/responsive_layout_mixin.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_loaders.dart';
import '../../../../core/widgets/auth_card_container.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? initialEmail;

  const ResetPasswordScreen({super.key, this.initialEmail});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with ResponsiveLayoutMixin, TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  final _verificationCodeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _message;
  bool _isSuccess = false;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _verificationCodeController.dispose();
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
          title: Text('reset_password'.tr()),
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
                    'reset_password'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.displayLarge?.copyWith(fontSize: config.titleFontSize),
                  ),
                  SizedBox(height: config.isPortrait ? 10.h : 8.h),
                  Text(
                    'enter_code_new_password'.tr(),
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
            labelText: 'email_address'.tr(),
            hintText: 'email_address'.tr(),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'enter_valid_email'.tr();
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegex.hasMatch(value.trim())) return 'enter_valid_email'.tr();
              return null;
            },
          ),
          SizedBox(height: config.isPortrait ? 16.h : 12.h),
          AuthTextField(
            labelText: 'verification_code'.tr(),
            hintText: 'verification_code'.tr(),
            controller: _verificationCodeController,
            prefixIcon: Icons.verified_outlined,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'enter_verification_code'.tr();
              }
              if (value.trim().length < 4) {
                return 'enter_verification_code'.tr();
              }
              return null;
            },
          ),
          SizedBox(height: config.isPortrait ? 16.h : 12.h),
          AuthTextField(
            labelText: 'new_password'.tr(),
            hintText: 'new_password'.tr(),
            controller: _newPasswordController,
            prefixIcon: Icons.lock_outline,
            isPassword: true,
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
            prefixIcon: Icons.lock_outline,
            isPassword: true,
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
                _triggerMessage('password_reset_success'.tr(), true);
                // No immediate clearStatus here
              }
            },
            builder: (context, state) {
              final cubit = context.read<AuthCubit>();
              final isButtonDisabled = state.isLoading || state.isSuccess;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: isButtonDisabled
                        ? null
                        : () {
                            if (!_formKey.currentState!.validate()) return;
                            setState(() => _message = null);
                            cubit.resetPassword(
                              email: _emailController.text.trim(),
                              verificationCode: _verificationCodeController.text.trim(),
                              newPassword: _newPasswordController.text,
                            );
                          },
                    child: state.isLoading
                        ? AppLoaders.inline()
                        : Text(
                            'reset_password'.tr(),
                            style: TextStyle(fontSize: config.buttonFontSize),
                          ),
                  ),
                  if (_message != null && !state.isSuccess)
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
                  SizedBox(height: config.isPortrait ? 10.h : 8.h),
                  TextButton(
                    onPressed: () => context.go(AppRouter.login),
                    child: Text(
                      'back_to_login'.tr(),
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
