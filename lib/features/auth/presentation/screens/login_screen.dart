import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/mixins/responsive_layout_mixin.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_loaders.dart';
import '../../../../core/widgets/auth_card_container.dart';
import '../mixins/auth_form_mixin.dart';
import '../state/auth_view_model.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin, ResponsiveLayoutMixin, AuthFormMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AuthViewModel>(),
      child: Scaffold(
        body: SafeArea(
          child: OrientationBuilder(
            builder: (context, _) {
              final config = getResponsiveConfig(context);

              return AuthCardContainer(
                config: config,
                children: [
                  Container(
                    width: config.isPortrait ? 72.w : 56.w,
                    height: config.isPortrait ? 72.w : 56.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(35),
                      shape: BoxShape.circle,
                    ),
                    child: LogoIcon(
                      width: config.isPortrait ? 36.sp : 28.sp,
                      height: config.isPortrait ? 36.sp : 28.sp,
                    ),
                  ),
                  SizedBox(height: config.isPortrait ? 22.h : 16.h),
                  Text(
                    'welcome_back'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: config.titleFontSize,
                    ),
                  ),
                  SizedBox(height: config.isPortrait ? 10.h : 8.h),
                  Text(
                    'login_description'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: config.bodyFontSize,
                    ),
                  ),
                  SizedBox(height: config.isPortrait ? 30.h : 20.h),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthTextField(
                          labelText: 'username_or_email'.tr(),
                          hintText: 'username_or_email'.tr(),
                          controller: _emailController,
                          prefixIcon: Icons.person_outline,
                          keyboardType: TextInputType.emailAddress,
                          semanticLabel: 'username_or_email'.tr(),
                          validator: (value) => value!.isEmpty
                              ? 'enter_username_or_email'.tr()
                              : null,
                        ),
                        SizedBox(height: config.isPortrait ? 18.h : 12.h),
                        AuthTextField(
                          labelText: 'password'.tr(),
                          hintText: 'password'.tr(),
                          controller: _passwordController,
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          semanticLabel: 'password'.tr(),
                          validator: (value) =>
                              value!.isEmpty ? 'enter_password'.tr() : null,
                        ),
                        SizedBox(height: config.isPortrait ? 10.h : 8.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context.push(AppRouter.forgotPassword);
                            },
                            child: Text(
                              'forgot_password'.tr(),
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: config.buttonFontSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: config.isPortrait ? 18.h : 12.h),
                        Consumer<AuthViewModel>(
                          builder: (context, viewModel, child) {
                            handleAuthStateChange(viewModel, () {
                              if (mounted) {
                                final user = viewModel.currentUser;
                                if (user != null) {
                                  String route;
                                  switch (user.roleId) {
                                    case 1: //Receptionist
                                      route = AppRouter.receptionistHome;
                                      break;
                                    case 2: // Doctor
                                      route = AppRouter.doctorHome;
                                      break;
                                    case 3: // Patient
                                      route = AppRouter.patientHome;
                                      break;
                                    default:
                                      route = AppRouter.patientHome; // Default
                                  }
                                  print(
                                    '🔄 Navigating to route: $route for user role: ${user.roleId}',
                                  );
                                  context.go(route);
                                } else {
                                  print(
                                    '❌ No user found in viewModel.currentUser',
                                  );
                                }
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
                                                viewModel.login(
                                                  _emailController.text,
                                                  _passwordController.text,
                                                );
                                              }
                                            },
                                      child: viewModel.isLoading
                                          ? AppLoaders.buttonLoader()
                                          : Text('login'.tr()),
                                    ),
                                  ),
                                ),
                                buildErrorMessage(),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: config.isPortrait ? 24.h : 16.h),
                        Center(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                'dont_have_account'.tr(),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontSize: config.buttonFontSize),
                              ),
                              TextButton(
                                onPressed: () {
                                  GoRouter.of(context).push(AppRouter.signup);
                                },
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
