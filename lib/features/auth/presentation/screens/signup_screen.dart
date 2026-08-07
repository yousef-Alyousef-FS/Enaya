import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/loaders/app_loaders.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../mixins/auth_form_mixin.dart';
import '../widgets/auth_card_container.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/logo.dart';
import '../widgets/portrait_only_scope.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin, AuthFormMixin {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AnimationController _fadeController;

  late final Animation<double> _fadeAnimation;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(_clearError);
    _emailController.addListener(_clearError);
    _phoneController.addListener(_clearError);
    _passwordController.addListener(_clearError);
    _confirmPasswordController.addListener(_clearError);

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
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

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
    if (!_agreeToTerms) {
      setState(() => errorMessage = 'agree_to_terms_error'.tr());
      return;
    }
    setState(() => errorMessage = null);
    cubit.signup(
      _emailController.text.trim(),
      _passwordController.text,
      _usernameController.text.trim(),
      _phoneController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveLayout.of(context);

    return PortraitOnlyScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('create_account'.tr()),
          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(36),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              context.read<AuthCubit>().clearStatus();
              setState(() => errorMessage = null);
              context.pop();
            },
          ),
        ),
        body: SafeArea(
          child: AuthCardContainer(
            config: config,
            children: [
              LogoIcon(width: config.logoSize, height: config.logoSize),
              const SizedBox(height: 24),
              Text(
                'join_enaya'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: config.titleFontSize,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'signup_description'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontSize: config.bodyFontSize),
              ),
              const SizedBox(height: 32),
              _buildForm(config),
            ],
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
            labelText: 'username'.tr(),
            hintText: 'username'.tr(),
            controller: _usernameController,
            prefixIcon: Icons.alternate_email_rounded,
            validator: (value) => value!.isEmpty ? 'required'.tr() : null,
          ),
          const SizedBox(height: 16),
          AuthTextField(
            labelText: 'email_address'.tr(),
            hintText: 'email_address'.tr(),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          AuthTextField(
            labelText: 'phone_number'.tr(),
            hintText: 'phone_number'.tr(),
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
            validator: _validatePhone,
          ),
          const SizedBox(height: 16),
          AuthTextField(
            labelText: 'password'.tr(),
            hintText: 'password'.tr(),
            controller: _passwordController,
            isPassword: true,
            prefixIcon: Icons.lock_outline,
            validator: _validatePassword,
          ),
          const SizedBox(height: 16),
          AuthTextField(
            labelText: 'confirm_password'.tr(),
            hintText: 'confirm_password'.tr(),
            controller: _confirmPasswordController,
            isPassword: true,
            prefixIcon: Icons.lock_outline,
            validator: _validateConfirmPassword,
          ),
          const SizedBox(height: 16),
          _buildTermsCheckbox(),
          const SizedBox(height: 32),
          _buildSignupButton(config),
          const SizedBox(height: 24),
          _buildLoginRedirect(config),
        ],
      ),
    );
  }

  Widget _buildSignupButton(ResponsiveLayoutConfig config) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        final cubit = context.read<AuthCubit>();

        // Only handle errors if this screen is the current active screen
        if (!(ModalRoute.of(context)?.isCurrent ?? false)) return;

        if (state.isError) {
          if (!mounted) return;
          setState(
            () => errorMessage = state.errorMessage ?? 'error_occurred'.tr(),
          );
          if (_fadeController.isAnimating) {
            _fadeController.stop();
          }
          _fadeController.forward(from: 0);
          cubit.clearStatus();
          return;
        }
        if (state.isSuccess) {
          if (!mounted) return;
          final user = state.currentUser;
          if (user != null && user.profileCompleted == false) {
            context.go(AppRouter.completeProfile);
          } else {
            context.go(AppRouter.patientHome);
          }
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
              key: const ValueKey('signup_btn'),
              onPressed: (state.isLoading)
                  ? null
                  : () => _onSignupPressed(cubit),
              child: state.isLoading
                  ? AppLoaders.inline()
                  : Text('sign_up'.tr()),
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

  Widget _buildLoginRedirect(ResponsiveLayoutConfig config) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'already_have_account'.tr(),
            style: TextStyle(fontSize: config.bodyFontSize),
          ),
          TextButton(
            key: const ValueKey('signup_login_redirect_btn'),
            onPressed: () {
              context.read<AuthCubit>().clearStatus();
              setState(() => errorMessage = null);
              context.pop();
            },
            child: Text(
              'login'.tr(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: config.buttonFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (value) {
            setState(() {
              _agreeToTerms = value ?? false;
              if (errorMessage != null) errorMessage = null;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _agreeToTerms = !_agreeToTerms;
                if (errorMessage != null) errorMessage = null;
              });
            },
            child: Text(
              'i_agree_to_terms'.tr(),
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}
