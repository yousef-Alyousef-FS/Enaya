import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/mixins/responsive_layout_mixin.dart';
import '../../../../core/view_models/base_view_model.dart';
import '../../../../core/widgets/app_loaders.dart';
import '../../../../core/widgets/auth_card_container.dart';
import '../state/auth_view_model.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with ResponsiveLayoutMixin, TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  String? _message;
  bool _isSuccess = false;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

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
    return ChangeNotifierProvider(
      create: (_) => getIt<AuthViewModel>(),
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
              final config = getResponsiveConfig(context);

              return AuthCardContainer(
                config: config,
                gradientAlpha: 41,
                children: [
                  Text(
                    'reset_password'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: config.titleFontSize,
                    ),
                  ),
                  SizedBox(height: config.isPortrait ? 10.h : 8.h),
                  Text(
                    'enter_email_reset'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: config.bodyFontSize,
                    ),
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

          Consumer<AuthViewModel>(
            builder: (context, viewModel, _) {
              // Handle error
              if (viewModel.state == ViewState.error) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _triggerMessage(
                    viewModel.errorMessage ?? 'error_occurred'.tr(),
                    false,
                  );
                  viewModel.resetState();
                });
              }

              // Handle success
              if (viewModel.state == ViewState.success) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _triggerMessage('reset_email_sent'.tr(), true);
                  viewModel.resetState();
                });
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _message = null);
                        viewModel.forgotPassword(
                          _emailController.text.trim(),
                        );
                      }
                    },
                    child: viewModel.isLoading
                        ? AppLoaders.inline()
                        : Text(
                      'send_reset_link'.tr(),
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
                            color: _isSuccess
                                ? Colors.green
                                : Theme.of(context).colorScheme.error,
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
