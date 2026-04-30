import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loaders/app_loaders.dart';
import '../widgets/auth_card_container.dart';
import '../../../../core/widgets/common/logo.dart';
import '../../../../core/widgets/common/portrait_only_scope.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../mixins/auth_form_mixin.dart';
import '../widgets/auth_text_field.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen>
    with TickerProviderStateMixin, AuthFormMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onVerifyPressed(AuthCubit cubit) {
    if (!_formKey.currentState!.validate()) return;
    setState(() => errorMessage = null);
    cubit.verifyEmail(email: widget.email, verificationCode: _codeController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return PortraitOnlyScope(
      child: BlocProvider(
        create: (_) => getIt<AuthCubit>(),
        child: Scaffold(
          body: SafeArea(
            child: OrientationBuilder(
              builder: (context, _) {
                final config = ResponsiveLayout.of(context);

                return AuthCardContainer(
                  config: config,
                  children: [
                    _buildLogo(config),
                    SizedBox(height: 22.h),
                    _buildHeader(context, config),
                    SizedBox(height: 30.h),
                    _buildForm(config),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(ResponsiveLayoutConfig config) {
    return Container(
      width: config.logoSize,
      height: config.logoSize,
      decoration: BoxDecoration(color: AppColors.primary.withAlpha(35), shape: BoxShape.circle),
      child: LogoIcon(width: config.iconSize, height: config.iconSize),
    );
  }

  Widget _buildHeader(BuildContext context, ResponsiveLayoutConfig config) {
    return Column(
      children: [
        Text(
          'verify_email'.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: config.titleFontSize),
        ),
        SizedBox(height: 10.h),
        Text(
          'enter_verification_code'.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: config.bodyFontSize),
        ),
        SizedBox(height: 5.h),
        Text(
          widget.email,
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildForm(ResponsiveLayoutConfig config) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AuthTextField(
            labelText: 'verification_code'.tr(),
            hintText: '123456',
            controller: _codeController,
            prefixIcon: Icons.verified_user_outlined,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'enter_verification_code'.tr();
              if (value.length < 6) {
                return 'invalid_code'.tr(); // Placeholder for invalid code translation
              }
              return null;
            },
          ),
          SizedBox(height: 24.h),
          _buildVerifySection(config),
          SizedBox(height: 16.h),
          _buildResendSection(config),
        ],
      ),
    );
  }

  Widget _buildVerifySection(ResponsiveLayoutConfig config) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isError) {
          setState(() => errorMessage = state.errorMessage ?? 'error_occurred'.tr());
          _fadeController.forward(from: 0);
          context.read<AuthCubit>().clearStatus();
        } else if (state.isSuccess) {
          setState(() {
            errorMessage = null;
            isNavigating = true;
          });
          successAnimationController.forward().then((_) {
            if (mounted) {
              context.go(AppRouter.login);
            }
          });
          return;
        }
      },
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedBuilder(
              animation: successAnimation,
              builder: (_, _) => Transform.scale(
                scale: successAnimation.value,
                child: ElevatedButton(
                  onPressed: (state.isLoading || isNavigating)
                      ? null
                      : () => _onVerifyPressed(cubit),
                  child: state.isLoading ? AppLoaders.inline() : Text('verify'.tr()),
                ),
              ),
            ),
            if (errorMessage != null && !state.isSuccess)
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Text(
                    errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.error, fontSize: config.bodyFontSize),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildResendSection(ResponsiveLayoutConfig config) {
    return TextButton(
      onPressed: () {
        // Logic to resend code
        getIt<AuthCubit>().sendEmailVerification(widget.email);
      },
      child: Text(
        'resend_code'.tr(),
        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
      ),
    );
  }
}
