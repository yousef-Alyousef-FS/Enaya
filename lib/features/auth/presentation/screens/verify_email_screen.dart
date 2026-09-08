import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
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
    _codeController.addListener(_clearError);
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
    _codeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onVerifyPressed(AuthCubit cubit) {
    if (!_formKey.currentState!.validate()) return;
    setState(() => errorMessage = null);
    cubit.verifyEmail(
      email: widget.email,
      verificationCode: _codeController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveLayout.of(context);

    return PortraitOnlyScope(
      child: BlocProvider(
        create: (_) => getIt<AuthCubit>(),
        child: Scaffold(
          body: SafeArea(
            child: AuthCardContainer(
              config: config,
              children: [
                _buildLogo(config),
                const SizedBox(height: 24),
                _buildHeader(context, config),
                const SizedBox(height: 32),
                _buildForm(config),
              ],
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
          'verify_email'.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.displayLarge?.copyWith(fontSize: config.titleFontSize),
        ),
        const SizedBox(height: 12),
        Text(
          'enter_verification_code'.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontSize: config.bodyFontSize),
        ),
        const SizedBox(height: 8),
        Text(
          widget.email,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
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
              if (value == null || value.isEmpty) {
                return 'enter_verification_code'.tr();
              }
              if (value.length < 6) {
                return 'invalid_code'.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          _buildVerifySection(config),
          const SizedBox(height: 16),
          _buildResendSection(config),
        ],
      ),
    );
  }

  Widget _buildVerifySection(ResponsiveLayoutConfig config) {
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
        } else if (state.isSuccess) {
          context.go(AppRouter.login);
          return;
        }
      },
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: (state.isLoading || isNavigating)
                  ? null
                  : () => _onVerifyPressed(cubit),
              child: state.isLoading
                  ? AppLoaders.inline()
                  : Text('verify'.tr()),
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
                    ),
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
        getIt<AuthCubit>().sendEmailVerification(widget.email);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('verification_code_sent'.tr())));
      },
      child: Text(
        'resend_code'.tr(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
