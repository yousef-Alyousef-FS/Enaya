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
import '../../../../core/widgets/logo.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../mixins/auth_form_mixin.dart';
import '../widgets/auth_text_field.dart';

enum UserRole {
  receptionist(1),
  doctor(2),
  patient(3);

  final int id;
  const UserRole(this.id);

  static UserRole fromId(int id) {
    return UserRole.values.firstWhere((e) => e.id == id, orElse: () => UserRole.patient);
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin, ResponsiveLayoutMixin, AuthFormMixin {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));

    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // -----------------------------
  // Navigation Logic
  // -----------------------------
  void _handleNavigation(BuildContext context, AuthState state) {
    final user = state.currentUser;
    if (user == null) return;

    final role = UserRole.fromId(user.roleId);

    final route = switch (role) {
      UserRole.receptionist => AppRouter.receptionistHome,
      UserRole.doctor => AppRouter.doctorHome,
      UserRole.patient => AppRouter.patientHome,
    };

    context.go(route);
  }

  // -----------------------------
  // Validation
  // -----------------------------
  String? _validateEmailOrUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'enter_username_or_email'.tr();
    }

    // إذا كان username → مقبول
    if (!value.contains('@')) return null;

    // إذا كان email → لازم يكون صحيح
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'invalid_email'.tr();
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

  void _onLoginPressed(AuthCubit cubit) {
    if (!_formKey.currentState!.validate()) return;

    setState(() => errorMessage = null);

    cubit.login(_emailController.text.trim(), _passwordController.text);
  }

  // -----------------------------
  // UI
  // -----------------------------
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: Scaffold(
        body: SafeArea(
          child: OrientationBuilder(
            builder: (context, _) {
              final config = getResponsiveConfig(context);

              return AuthCardContainer(
                config: config,
                children: [
                  _buildLogo(config),
                  SizedBox(height: config.isPortrait ? 22.h : 16.h),

                  _buildHeader(context, config),
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

  Widget _buildLogo(ResponsiveLayoutConfig config) {
    return Container(
      width: config.logoSize,
      height: config.logoSize,
      decoration: BoxDecoration(color: AppColors.primary.withAlpha(35), shape: BoxShape.circle),
      child: LogoIcon(
        width: config.iconSize,
        height: config.iconSize,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ResponsiveLayoutConfig config) {
    return Column(
      children: [
        Text(
          'welcome_back'.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: config.titleFontSize),
        ),
        SizedBox(height: config.isPortrait ? 10.h : 8.h),
        Text(
          'login_description'.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: config.bodyFontSize),
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
            labelText: 'username_or_email'.tr(),
            hintText: 'username_or_email'.tr(),
            controller: _emailController,
            prefixIcon: Icons.person_outline,
            keyboardType: TextInputType.emailAddress,
            semanticLabel: 'username_or_email'.tr(),
            validator: _validateEmailOrUsername,
          ),
          SizedBox(height: config.isPortrait ? 18.h : 12.h),

          AuthTextField(
            labelText: 'password'.tr(),
            hintText: 'password'.tr(),
            controller: _passwordController,
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            semanticLabel: 'password'.tr(),
            validator: _validatePassword,
          ),
          SizedBox(height: config.isPortrait ? 10.h : 8.h),

          _buildForgotPassword(config),
          SizedBox(height: config.isPortrait ? 18.h : 12.h),

          _buildLoginSection(config),
          SizedBox(height: config.isPortrait ? 24.h : 16.h),

          _buildSignupSection(config),
        ],
      ),
    );
  }

  Widget _buildForgotPassword(config) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => context.push(AppRouter.forgotPassword),
        child: Text(
          'forgot_password'.tr(),
          style: TextStyle(
            color: AppColors.primary,
            fontSize: config.buttonFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginSection(config) {
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
              _handleNavigation(context, state);
              // We don't reverse or clear status here because we are leaving the screen
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
                  onPressed: (state.isLoading || isNavigating) ? null : () => _onLoginPressed(cubit),
                  child: state.isLoading ? AppLoaders.inline() : Text('login'.tr()),
                ),
              ),
            ),

            // Error message with fade animation
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

  Widget _buildSignupSection(config) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('dont_have_account'.tr(), style: TextStyle(fontSize: config.buttonFontSize)),
        TextButton(
          onPressed: () => context.push(AppRouter.signup),
          child: Text(
            'sign_up'.tr(),
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: config.buttonFontSize,
            ),
          ),
        ),
      ],
    );
  }
}
