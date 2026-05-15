import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/loaders/app_loaders.dart';
import '../widgets/auth_card_container.dart';
import '../widgets/logo.dart';
import '../widgets/portrait_only_scope.dart';

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
    return UserRole.values.firstWhere(
      (e) => e.id == id,
      orElse: () => UserRole.patient,
    );
  }
}

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

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
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
      UserRole.patient => AppRouter.patientHome,
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
                    const SizedBox(height: 24),
                    _buildHeader(context, config),
                    const SizedBox(height: 32),
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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(35),
        shape: BoxShape.circle,
      ),
      child: LogoIcon(width: config.iconSize, height: config.iconSize),
    );
  }

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
          _buildBiometricOption(),
          const SizedBox(height: 24),
          _buildSignupSection(config),
        ],
      ),
    );
  }

  Widget _buildForgotPassword(ResponsiveLayoutConfig config) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => context.push(AppRouter.forgotPassword),
        child: Text(
          'forgot_password'.tr(),
          style: TextStyle(
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: (state.isLoading)
                  ? null
                  : () => _onLoginPressed(cubit),
              child: state.isLoading ? AppLoaders.inline() : Text('login'.tr()),
            ),
            if (errorMessage != null && !state.isSuccess)
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
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
          onPressed: () => context.push(AppRouter.signup),
          child: Text(
            'sign_up'.tr(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: config.buttonFontSize,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBiometricOption() {
    final isBiometricSupported =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    return Center(
      child: AnimatedOpacity(
        opacity: isBiometricSupported ? 1.0 : 0.45,
        duration: const Duration(milliseconds: 250),
        child: IconButton(
          icon: Icon(
            Icons.fingerprint,
            size: 40,
            color: isBiometricSupported
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onPressed: isBiometricSupported
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('biometric_login_not_implemented'.tr()),
                    ),
                  );
                }
              : null,
          tooltip: 'biometric_login'.tr(),
        ),
      ),
    );
  }
}
