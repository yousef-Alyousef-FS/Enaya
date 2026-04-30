import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/loaders/app_loaders.dart';
import '../widgets/auth_card_container.dart';
import '../../../../core/widgets/common/portrait_only_scope.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

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
    _emailController.dispose();
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
    return PortraitOnlyScope(
      child: BlocProvider(
        create: (_) => getIt<AuthCubit>(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('forgot_password'.tr()),
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
                      'enter_email_reset'.tr(),
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
      ),
    );
  }

  Widget _buildForm(ResponsiveLayoutConfig config) {
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
              if (value == null || value.trim().isEmpty) {
                return 'enter_valid_email'.tr();
              }
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegex.hasMatch(value.trim())) {
                return 'enter_valid_email'.tr();
              }
              return null;
            },
          ),
          SizedBox(height: config.isPortrait ? 18.h : 12.h),

          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              final cubit = context.read<AuthCubit>();

              if (state.isError) {
                _triggerMessage(state.errorMessage ?? 'error_occurred'.tr(), false);
                cubit.clearStatus();
                return;
              }

              if (state.isSuccess) {
                _triggerMessage('reset_email_sent'.tr(), true);
                context.push(
                  '${AppRouter.resetPassword}?email=${Uri.encodeComponent(_emailController.text.trim())}',
                );
                // No clearStatus here to keep the success message until we navigate
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
                            if (_formKey.currentState!.validate()) {
                              setState(() => _message = null);
                              cubit.forgotPassword(_emailController.text.trim());
                            }
                          },
                    child: state.isLoading
                        ? AppLoaders.inline()
                        : Text(
                            'send_reset_link'.tr(),
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
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
