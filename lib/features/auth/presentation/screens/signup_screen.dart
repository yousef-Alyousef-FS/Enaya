import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_loaders.dart';
import '../../../../core/widgets/auth_card_container.dart';
import '../../../../core/widgets/portrait_only_scope.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../mixins/auth_form_mixin.dart';
import '../widgets/auth_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with TickerProviderStateMixin, AuthFormMixin {
  final _formKey = GlobalKey<FormState>();

  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // -----------------------------
  // Validation
  // -----------------------------
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'enter_valid_email'.tr();
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'enter_valid_email'.tr();
    }

    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'enter_phone_number'.tr();
    }

    if (value.length < 8) {
      return 'invalid_phone_number'.tr();
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'enter_password'.tr();
    }
    if (value.length < 6) {
      return 'password_too_short'.tr();
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'enter_confirm_password'.tr();
    }
    if (value != _passwordController.text) {
      return 'passwords_do_not_match'.tr();
    }
    return null;
  }

  void _onSignupPressed(AuthCubit cubit) {
    if (!_formKey.currentState!.validate()) return;

    setState(() => errorMessage = null);

    cubit.signup(
      _emailController.text.trim(),
      _passwordController.text,
      _userNameController.text.trim(),
      _phoneController.text.trim(),
    );
  }

  // -----------------------------
  // UI
  // -----------------------------
  @override
  Widget build(BuildContext context) {
    return PortraitOnlyScope(
      child: BlocProvider(
        create: (_) => getIt<AuthCubit>(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('create_account'.tr()),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: OrientationBuilder(
              builder: (context, _) {
                final config = ResponsiveLayout.of(context);

                return AuthCardContainer(
                  config: config,
                  children: [
                    Text(
                      'join_enaya'.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(fontSize: config.titleFontSize),
                    ),
                    SizedBox(height: config.isPortrait ? 10.h : 8.h),
                    Text(
                      'signup_description'.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(fontSize: config.bodyFontSize),
                    ),
                    SizedBox(height: config.isPortrait ? 32.h : 24.h),

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

  Widget _buildForm(ResponsiveLayoutConfig config) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthTextField(
            labelText: 'full_name'.tr(),
            hintText: 'full_name'.tr(),
            controller: _userNameController,
            prefixIcon: Icons.person_outline,
            validator: (value) => value!.isEmpty ? 'enter_your_name'.tr() : null,
          ),
          SizedBox(height: config.isPortrait ? 16.h : 12.h),

          AuthTextField(
            labelText: 'email_address'.tr(),
            hintText: 'email_address'.tr(),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: _validateEmail,
          ),
          SizedBox(height: config.isPortrait ? 16.h : 12.h),

          AuthTextField(
            labelText: 'phone_number'.tr(),
            hintText: 'phone_number'.tr(),
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
            validator: _validatePhone,
          ),
          SizedBox(height: config.isPortrait ? 16.h : 12.h),

          AuthTextField(
            labelText: 'password'.tr(),
            hintText: 'password'.tr(),
            controller: _passwordController,
            isPassword: true,
            prefixIcon: Icons.lock_outline,
            validator: _validatePassword,
          ),
          SizedBox(height: config.isPortrait ? 16.h : 12.h),

          AuthTextField(
            labelText: 'confirm_password'.tr(),
            hintText: 'confirm_password'.tr(),
            controller: _confirmPasswordController,
            isPassword: true,
            prefixIcon: Icons.lock_outline,
            validator: _validateConfirmPassword,
          ),
          SizedBox(height: config.isPortrait ? 30.h : 22.h),

          _buildSignupButton(config),
          SizedBox(height: config.isPortrait ? 20.h : 14.h),

          _buildLoginRedirect(config),
        ],
      ),
    );
  }

  Widget _buildSignupButton(ResponsiveLayoutConfig config) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        final cubit = context.read<AuthCubit>();

        if (state.isError) {
          setState(() => errorMessage = state.errorMessage ?? 'error_occurred'.tr());
          _fadeController.forward(from: 0);
          cubit.clearStatus();
          return;
        }

        if (state.isSuccess) {
          setState(() {
            errorMessage = null;
            isNavigating = true;
          });
          successAnimationController.forward().then((_) {
            if (mounted) {
              context.go(AppRouter.patientHome);
              // No reverse or clearStatus needed as we navigate away
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
                      : () => _onSignupPressed(cubit),
                  child: state.isLoading ? AppLoaders.inline() : Text('sign_up'.tr()),
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
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: config.bodyFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildLoginRedirect(ResponsiveLayoutConfig config) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('already_have_account'.tr(), style: TextStyle(fontSize: config.bodyFontSize)),
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'login'.tr(),
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: config.buttonFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
