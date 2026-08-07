import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/loaders/app_loaders.dart';
import '../../domain/entities/user_role.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../mixins/auth_form_mixin.dart';
import '../widgets/auth_card_container.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/logo.dart';
import '../widgets/portrait_only_scope.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin, AuthFormMixin {
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

    _emailController.addListener(_clearError);
    _passwordController.addListener(_clearError);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  void _clearError() {
    if (errorMessage != null) {
      setState(() => errorMessage = null);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _handleNavigation(BuildContext context, AuthState state) {
    final user = state.currentUser;
    if (user == null) return;

    final role = UserRole.fromId(user.roleId);

    final route = switch (role) {
      UserRole.receptionist => AppRouter.receptionistHome,
      UserRole.doctor => AppRouter.doctorHome,
      UserRole.patient =>
        user.profileCompleted == false
            ? AppRouter.completeProfile
            : AppRouter.patientHome,
    };

    context.go(route);
  }

  String? _validateEmailOrUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'enter_username_or_email'.tr();
    }
    if (!value.contains('@')) return null;
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

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveLayout.of(context);

    return PortraitOnlyScope(
      child: Scaffold(
        body: SafeArea(
          child: AuthCardContainer(
            config: config,
            children: [
              LogoIcon(width: config.logoSize, height: config.logoSize),
              const SizedBox(height: 24),
              _buildHeader(context, config),
              const SizedBox(height: 60),
              _buildForm(config),
            ],
          ),
        ),
      ),
    );
  }
  // a methon to build the logo using the asset enaya.svg

  Widget _buildHeader(BuildContext context, ResponsiveLayoutConfig config) {
    return Column(
      children: [
        Text(
          'welcome_back'.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.displayLarge?.copyWith(fontSize: config.titleFontSize),
        ),
        const SizedBox(height: 8),
        Text(
          'login_description'.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontSize: config.bodyFontSize),
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
          const SizedBox(height: 16),
          AuthTextField(
            labelText: 'password'.tr(),
            hintText: 'password'.tr(),
            controller: _passwordController,
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            semanticLabel: 'password'.tr(),
            validator: _validatePassword,
          ),
          const SizedBox(height: 8),
          _buildForgotPassword(config),
          const SizedBox(height: 16),
          _buildLoginSection(config),
          const SizedBox(height: 16),
          _buildSignupSection(config),
        ],
      ),
    );
  }

  Widget _buildForgotPassword(ResponsiveLayoutConfig config) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        key: const ValueKey('forgot_password_btn'),
        onPressed: () {
          context.read<AuthCubit>().clearStatus();
          setState(() => errorMessage = null);
          context.push(AppRouter.forgotPassword);
        },
        child: Text(
          'forgot_password'.tr(),
          style: TextStyle(
            inherit: false,
            color: Theme.of(context).colorScheme.primary,
            fontSize: config.buttonFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginSection(ResponsiveLayoutConfig config) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        final cubit = context.read<AuthCubit>();

        // Only handle errors if this screen is the current active screen
        if (!(ModalRoute.of(context)?.isCurrent ?? false)) return;

        if (state.isError) {
          setState(
            () => errorMessage = state.errorMessage ?? 'error_occurred'.tr(),
          );
          _fadeController.forward(from: 0);
          cubit.clearStatus();
          return;
        }
        if (state.isSuccess) {
          _handleNavigation(context, state);
          return;
        }
      },
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              key: const ValueKey('login_btn'),
              onPressed: (state.isLoading)
                  ? null
                  : () => _onLoginPressed(cubit),
              child: state.isLoading ? AppLoaders.inline() : Text('login'.tr()),
            ),
            if (errorMessage != null && !state.isSuccess)
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withAlpha(
                        isDark ? 30 : 20,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.error.withAlpha(50),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: theme.colorScheme.error,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            errorMessage!,
                            style: TextStyle(
                              color: theme.colorScheme.error,
                              fontSize: config.bodyFontSize - 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSignupSection(ResponsiveLayoutConfig config) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'dont_have_account'.tr(),
          style: TextStyle(fontSize: config.buttonFontSize),
        ),
        TextButton(
          key: const ValueKey('signup_btn'),
          onPressed: () {
            context.read<AuthCubit>().clearStatus();
            setState(() => errorMessage = null);
            context.push(AppRouter.signup);
          },
          child: Text(
            'sign_up'.tr(),
            style: TextStyle(
              inherit: false,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: config.buttonFontSize,
            ),
          ),
        ),
      ],
    );
  }
}
