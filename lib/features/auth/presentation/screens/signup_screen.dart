import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/mixins/responsive_layout_mixin.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/app_loaders.dart';
import '../../../../core/widgets/auth_card_container.dart';
import '../mixins/auth_form_mixin.dart';
import '../state/auth_view_model.dart';
import '../widgets/auth_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin, ResponsiveLayoutMixin, AuthFormMixin {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AuthViewModel>(),
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
              final config = getResponsiveConfig(context);

              return AuthCardContainer(
                config: config,
                children: [
                  Text(
                    'join_enaya'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: config.titleFontSize,
                    ),
                  ),
                  SizedBox(height: config.isPortrait ? 10.h : 8.h),
                  Text(
                    'signup_description'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: config.bodyFontSize,
                    ),
                  ),
                  SizedBox(height: config.isPortrait ? 32.h : 24.h),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthTextField(
                          labelText: 'full_name'.tr(),
                          hintText: 'full_name'.tr(),
                          controller: _userNameController,
                          prefixIcon: Icons.person_outline,
                          semanticLabel: 'full_name'.tr(),
                          validator: (value) =>
                              value!.isEmpty ? 'enter_your_name'.tr() : null,
                        ),
                        SizedBox(height: config.isPortrait ? 16.h : 12.h),
                        AuthTextField(
                          labelText: 'email_address'.tr(),
                          hintText: 'email_address'.tr(),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          semanticLabel: 'email_address'.tr(),
                          validator: (value) => !value!.contains('@')
                              ? 'enter_valid_email'.tr()
                              : null,
                        ),
                        SizedBox(height: config.isPortrait ? 16.h : 12.h),
                        AuthTextField(
                          labelText: 'phone_number'.tr(),
                          hintText: 'phone_number'.tr(),
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                          semanticLabel: 'phone_number'.tr(),
                          validator: (value) =>
                              value!.isEmpty ? 'enter_phone_number'.tr() : null,
                        ),
                        SizedBox(height: config.isPortrait ? 16.h : 12.h),
                        AuthTextField(
                          labelText: 'password'.tr(),
                          hintText: 'password'.tr(),
                          controller: _passwordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          semanticLabel: 'password'.tr(),
                          validator: (value) => value!.length < 6
                              ? 'password_too_short'.tr()
                              : null,
                        ),
                        SizedBox(height: config.isPortrait ? 16.h : 12.h),
                        AuthTextField(
                          labelText: 'confirm_password'.tr(),
                          hintText: 'confirm_password'.tr(),
                          controller: _confirmPasswordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          semanticLabel: 'confirm_password'.tr(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'enter_confirm_password'.tr();
                            }
                            if (value != _passwordController.text) {
                              return 'passwords_do_not_match'.tr();
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: config.isPortrait ? 30.h : 22.h),
                        Consumer<AuthViewModel>(
                          builder: (context, viewModel, child) {
                            handleAuthStateChange(viewModel, () {
                              if (mounted) {
                                context.go(AppRouter.patientHome);
                              }
                            });

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AnimatedBuilder(
                                  animation: successAnimation,
                                  builder: (context, child) => Transform.scale(
                                    scale: successAnimation.value,
                                    child: ElevatedButton(
                                      onPressed: viewModel.isLoading
                                          ? null
                                          : () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  errorMessage = null;
                                                });
                                                viewModel.signup(
                                                  _emailController.text,
                                                  _passwordController.text,
                                                  _userNameController.text,
                                                  _phoneController.text,
                                                );
                                              }
                                            },
                                      child: viewModel.isLoading
                                          ? AppLoaders.buttonLoader()
                                          : Text('sign_up'.tr()),
                                    ),
                                  ),
                                ),
                                buildErrorMessage(),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: config.isPortrait ? 20.h : 14.h),
                        Center(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                'already_have_account'.tr(),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontSize: config.bodyFontSize),
                              ),
                              TextButton(
                                onPressed: () => context.pop(),
                                child: Text(
                                  'login'.tr(),
                                  style: TextStyle(
                                    color: const Color.fromRGBO(
                                      108,
                                      99,
                                      255,
                                      1,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    fontSize: config.buttonFontSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
